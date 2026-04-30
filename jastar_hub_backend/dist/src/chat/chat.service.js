"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ChatService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let ChatService = class ChatService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async saveMessage(data) {
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
    async getConversations(userId) {
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
        conversations.sort((a, b) => {
            const dateA = a.lastMessage?.createdAt?.getTime() || 0;
            const dateB = b.lastMessage?.createdAt?.getTime() || 0;
            return dateB - dateA;
        });
        return conversations;
    }
    async getMessageHistory(userId, partnerId, skip = 0, take = 50) {
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
};
exports.ChatService = ChatService;
exports.ChatService = ChatService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], ChatService);
//# sourceMappingURL=chat.service.js.map