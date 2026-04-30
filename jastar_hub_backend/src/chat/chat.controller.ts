import {
  Controller,
  Get,
  Query,
  UseGuards,
  Request,
  Param,
} from '@nestjs/common';
import { ChatService } from './chat.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('chat')
@UseGuards(JwtAuthGuard)
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  @Get('conversations')
  async getConversations(@Request() req: any) {
    return this.chatService.getConversations(req.user.id);
  }

  @Get('messages/:partnerId')
  async getMessages(
    @Request() req: any,
    @Param('partnerId') partnerId: string,
    @Query('skip') skip?: string,
    @Query('take') take?: string,
  ) {
    return this.chatService.getMessageHistory(
      req.user.id,
      partnerId,
      skip ? parseInt(skip) : 0,
      take ? parseInt(take) : 50,
    );
  }
}
