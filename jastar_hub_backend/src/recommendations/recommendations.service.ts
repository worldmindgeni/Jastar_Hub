import { Injectable, Inject, forwardRef } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';
import { EventsService } from '../events/events.service';

@Injectable()
export class RecommendationsService {
  private readonly AI_SERVICE_URL =
    process.env.AI_SERVICE_URL || 'http://localhost:8000';

  constructor(
    private readonly httpService: HttpService,
    @Inject(forwardRef(() => EventsService))
    private readonly eventsService: EventsService,
  ) {}

  async getRecommendations(userId: string) {
    try {
      const response = await firstValueFrom(
        this.httpService.get(`${this.AI_SERVICE_URL}/recommend/${userId}`),
      );
      
      const eventIds = response.data;
      if (Array.isArray(eventIds) && eventIds.length > 0) {
        return this.eventsService.findAll({
          where: { id: { in: eventIds } },
          take: 10,
        });
      }
    } catch (error) {
      console.error('AI Service unreachable or error, returning fallback trending events');
    }

    // Fallback: return trending events if AI service is failing
    return this.eventsService.getTrending(10);
  }
}
