import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { ChatService } from './chat.service';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
})
export class ChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private connectedUsers = new Map<string, string>(); // userId -> socketId

  constructor(private chatService: ChatService) {}

  handleConnection(client: Socket) {
    console.log(`Client connected: ${client.id}`);
  }

  handleDisconnect(client: Socket) {
    // Remove user from connected map
    for (const [userId, socketId] of this.connectedUsers.entries()) {
      if (socketId === client.id) {
        this.connectedUsers.delete(userId);
        this.server.emit('userOffline', { userId });
        break;
      }
    }
    console.log(`Client disconnected: ${client.id}`);
  }

  @SubscribeMessage('register')
  handleRegister(
    @MessageBody() data: { userId: string },
    @ConnectedSocket() client: Socket,
  ) {
    this.connectedUsers.set(data.userId, client.id);
    client.join(`user_${data.userId}`);
    this.server.emit('userOnline', { userId: data.userId });
    return { status: 'registered' };
  }

  @SubscribeMessage('joinRoom')
  handleJoinRoom(
    @MessageBody() data: { roomId: string },
    @ConnectedSocket() client: Socket,
  ) {
    client.join(data.roomId);
    return { status: 'joined', roomId: data.roomId };
  }

  @SubscribeMessage('sendMessage')
  async handleMessage(
    @MessageBody()
    data: { senderId: string; receiverId: string; content: string },
    @ConnectedSocket() client: Socket,
  ) {
    const message = await this.chatService.saveMessage(data);

    // Send to receiver if online
    const receiverSocketId = this.connectedUsers.get(data.receiverId);
    if (receiverSocketId) {
      this.server.to(receiverSocketId).emit('messageReceived', message);
    }

    // Also emit back to sender for confirmation
    client.emit('messageSent', message);
    return message;
  }

  @SubscribeMessage('typing')
  handleTyping(
    @MessageBody()
    data: { senderId: string; receiverId: string; isTyping: boolean },
    @ConnectedSocket() client: Socket,
  ) {
    const receiverSocketId = this.connectedUsers.get(data.receiverId);
    if (receiverSocketId) {
      this.server.to(receiverSocketId).emit('userTyping', {
        userId: data.senderId,
        isTyping: data.isTyping,
      });
    }
  }

  @SubscribeMessage('markRead')
  async handleMarkRead(
    @MessageBody() data: { userId: string; partnerId: string },
  ) {
    // Mark all messages from partner as read
    const receiverSocketId = this.connectedUsers.get(data.partnerId);
    if (receiverSocketId) {
      this.server.to(receiverSocketId).emit('messagesRead', {
        byUserId: data.userId,
      });
    }
  }
}
