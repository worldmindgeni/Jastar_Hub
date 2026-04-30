import { PrismaService } from '../prisma/prisma.service';
import { NotificationType } from '@prisma/client';
export declare class NotificationsService {
    private prisma;
    constructor(prisma: PrismaService);
    create(data: {
        userId: string;
        type: NotificationType;
        title: string;
        message: string;
        data?: any;
    }): Promise<{
        id: string;
        createdAt: Date;
        data: import("@prisma/client/runtime/client").JsonValue | null;
        title: string;
        isRead: boolean;
        message: string;
        userId: string;
        type: import("@prisma/client").$Enums.NotificationType;
    }>;
    findAllForUser(userId: string, skip?: number, take?: number): Promise<{
        id: string;
        createdAt: Date;
        data: import("@prisma/client/runtime/client").JsonValue | null;
        title: string;
        isRead: boolean;
        message: string;
        userId: string;
        type: import("@prisma/client").$Enums.NotificationType;
    }[]>;
    getUnreadCount(userId: string): Promise<{
        count: number;
    }>;
    markAsRead(id: string, userId: string): Promise<import("@prisma/client").Prisma.BatchPayload>;
    markAllAsRead(userId: string): Promise<import("@prisma/client").Prisma.BatchPayload>;
    delete(id: string, userId: string): Promise<import("@prisma/client").Prisma.BatchPayload>;
}
