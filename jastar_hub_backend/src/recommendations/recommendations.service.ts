import { Injectable } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';

@Injectable()
export class RecommendationsService {
  private readonly AI_SERVICE_URL =
    process.env.AI_SERVICE_URL || 'http://localhost:8000';

  constructor(private readonly httpService: HttpService) {}

  async getRecommendations(userId: string) {
    try {
      const response = await firstValueFrom(
        this.httpService.get(`${this.AI_SERVICE_URL}/recommend/${userId}`),
      );
      return response.data;
    } catch (error) {
      console.error('AI Service unreachable, returning empty recommendations');
      return [];
    }
  }
}
