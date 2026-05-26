import {
  Controller,
  Post,
  Get,
  Body,
  Param,
  Query,
  Request,
  UseGuards,
} from '@nestjs/common';
import { AiService, ChatMessage } from './ai.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('ai')
export class AiController {
  constructor(private readonly aiService: AiService) {}

  // POST /ai/chat — чат с ассистентом (доступен без авторизации)
  @Post('chat')
  async chat(@Body() body: ChatMessage) {
    return this.aiService.chat(body);
  }

  // GET /ai/recommendations — персональные рекомендации (нужен JWT)
  @UseGuards(JwtAuthGuard)
  @Get('recommendations')
  async getRecommendations(@Request() req: any) {
    return this.aiService.getRecommendations(req.user.id);
  }

  // GET /ai/similar/:id — похожие события
  @Get('similar/:id')
  async getSimilar(
    @Param('id') id: string,
    @Query('limit') limit?: string,
  ) {
    return this.aiService.getSimilar(id, limit ? parseInt(limit) : 5);
  }

  // GET /ai/trending — популярные события
  @Get('trending')
  async getTrending(@Query('limit') limit?: string) {
    return this.aiService.getTrending(limit ? parseInt(limit) : 10);
  }
}
