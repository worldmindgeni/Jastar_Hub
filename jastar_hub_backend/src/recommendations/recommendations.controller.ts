import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { RecommendationsService } from './recommendations.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('recommendations')
@UseGuards(JwtAuthGuard)
export class RecommendationsController {
  constructor(private readonly recService: RecommendationsService) {}

  @Get()
  async getRecommendations(@Request() req: any) {
    return this.recService.getRecommendations(req.user.id);
  }
}
