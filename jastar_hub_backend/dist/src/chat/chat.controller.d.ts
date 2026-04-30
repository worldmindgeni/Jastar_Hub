import { ChatService } from './chat.service';
export declare class ChatController {
    private readonly chatService;
    constructor(chatService: ChatService);
    getConversations(req: any): Promise<{
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
    getMessages(req: any, partnerId: string, skip?: string, take?: string): Promise<({
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
