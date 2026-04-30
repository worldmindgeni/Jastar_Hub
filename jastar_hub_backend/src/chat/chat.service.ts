import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ChatService {
  constructor(private prisma: PrismaService) {}

  async saveMessage(data: {
    senderId: string;
    receiverId: string;
    content: string;
  }) {
    return this.prisma.message.create({
      data: {
        content: data.content,
        senderId: data.senderId,
        receiverId: data.receiverId,
      },
      include: {
        sender: { select: { id: true, name: true, avatarUrl: true } },
      },
    });
  }

  async getConversations(userId: string) {
    // Get distinct conversation partners
    const sent = await this.prisma.message.findMany({
      where: { senderId: userId },
      select: { receiverId: true },
      distinct: ['receiverId'],
    });
    const received = await this.prisma.message.findMany({
      where: { receiverId: userId },
      select: { senderId: true },
      distinct: ['senderId'],
    });

    const partnerIds = new Set([
      ...sent.map((m) => m.receiverId),
      ...received.map((m) => m.senderId),
    ]);

    const conversations = [];
    for (const partnerId of partnerIds) {
      const partner = await this.prisma.user.findUnique({
        where: { id: partnerId },
        select: { id: true, name: true, avatarUrl: true },
      });

      const lastMessage = await this.prisma.message.findFirst({
        where: {
          OR: [
            { senderId: userId, receiverId: partnerId },
            { senderId: partnerId, receiverId: userId },
          ],
        },
        orderBy: { createdAt: 'desc' },
      });

      const unreadCount = await this.prisma.message.count({
        where: {
          senderId: partnerId,
          receiverId: userId,
          isRead: false,
        },
      });

      conversations.push({
        partner,
        lastMessage,
        unreadCount,
      });
    }

    // Sort by last message date
    conversations.sort((a, b) => {
      const dateA = a.lastMessage?.createdAt?.getTime() || 0;
      const dateB = b.lastMessage?.createdAt?.getTime() || 0;
      return dateB - dateA;
    });

    return conversations;
  }

  async getMessageHistory(
    userId: string,
    partnerId: string,
    skip = 0,
    take = 50,
  ) {
    const messages = await this.prisma.message.findMany({
      where: {
        OR: [
          { senderId: userId, receiverId: partnerId },
          { senderId: partnerId, receiverId: userId },
        ],
      },
      orderBy: { createdAt: 'desc' },
      skip,
      take,
      include: {
        sender: { select: { id: true, name: true, avatarUrl: true } },
      },
    });

    // Mark received messages as read
    await this.prisma.message.updateMany({
      where: {
        senderId: partnerId,
        receiverId: userId,
        isRead: false,
      },
      data: { isRead: true },
    });

    return messages.reverse();
  }
}
