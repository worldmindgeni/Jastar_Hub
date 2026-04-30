import { OnGatewayConnection, OnGatewayDisconnect } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { ChatService } from './chat.service';
export declare class ChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
    private chatService;
    server: Server;
    private connectedUsers;
    constructor(chatService: ChatService);
    handleConnection(client: Socket): void;
    handleDisconnect(client: Socket): void;
    handleRegister(data: {
        userId: string;
    }, client: Socket): {
        status: string;
    };
    handleJoinRoom(data: {
        roomId: string;
    }, client: Socket): {
        status: string;
        roomId: string;
    };
    handleMessage(data: {
        senderId: string;
        receiverId: string;
        content: string;
    }, client: Socket): Promise<{
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
    handleTyping(data: {
        senderId: string;
        receiverId: string;
        isTyping: boolean;
    }, client: Socket): void;
    handleMarkRead(data: {
        userId: string;
        partnerId: string;
    }): Promise<void>;
}
