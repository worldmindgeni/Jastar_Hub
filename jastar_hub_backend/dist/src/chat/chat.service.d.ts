import { PrismaService } from '../prisma/prisma.service';
export declare class ChatService {
    private prisma;
    constructor(prisma: PrismaService);
    saveMessage(data: {
        senderId: string;
        receiverId: string;
        content: string;
    }): Promise<{
        sender: {
            id: string;
            name: string;
            avatarUrl: string | null;
        };
    } & {
        id: string;
        createdAt: Date;
        isRead: boolean;
        content: string;
        receiverId: string;
        senderId: string;
    }>;
    getConversations(userId: string): Promise<{
        partner: {
            id: string;
            name: string;
            avatarUrl: string | null;
        } | null;
        lastMessage: {
            id: string;
            createdAt: Date;
            isRead: boolean;
            content: string;
            receiverId: string;
            senderId: string;
        } | null;
        unreadCount: number;
    }[]>;
    getMessageHistory(userId: string, partnerId: string, skip?: number, take?: number): Promise<({
        sender: {
            id: string;
            name: string;
            avatarUrl: string | null;
        };
    } & {
        id: string;
        createdAt: Date;
        isRead: boolean;
        content: string;
        receiverId: string;
        senderId: string;
    })[]>;
}
