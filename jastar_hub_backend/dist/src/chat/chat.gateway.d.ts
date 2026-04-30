import { OnGatewayConnection, OnGatewayDisconnect } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { PrismaService } from '../prisma/prisma.service';
export declare class ChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
    private prisma;
    server: Server;
    constructor(prisma: PrismaService);
    handleConnection(client: Socket): void;
    handleDisconnect(client: Socket): void;
    handleMessage(data: {
        senderId: string;
        receiverId: string;
        content: string;
    }, client: Socket): Promise<{
        id: string;
        createdAt: Date;
        content: string;
        receiverId: string;
        senderId: string;
    }>;
}
