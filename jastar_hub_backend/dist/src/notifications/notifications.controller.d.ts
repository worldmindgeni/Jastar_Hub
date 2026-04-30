import { NotificationsService } from './notifications.service';
export declare class NotificationsController {
    private readonly notificationsService;
    constructor(notificationsService: NotificationsService);
    getNotifications(req: any, skip?: string, take?: string): Promise<{
        id: string;
        createdAt: Date;
        data: import("@prisma/client/runtime/client").JsonValue | null;
        title: string;
        isRead: boolean;
        message: string;
        userId: string;
        type: import("@prisma/client").$Enums.NotificationType;
    }[]>;
    getUnreadCount(req: any): Promise<{
        count: number;
    }>;
    markAsRead(id: string, req: any): Promise<import("@prisma/client").Prisma.BatchPayload>;
    markAllAsRead(req: any): Promise<import("@prisma/client").Prisma.BatchPayload>;
    deleteNotification(id: string, req: any): Promise<import("@prisma/client").Prisma.BatchPayload>;
}
