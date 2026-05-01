import { Injectable, Inject, forwardRef } from '@nestjs/common';
import { EventsService } from '../events/events.service';

@Injectable()
export class RecommendationsService {
  constructor(
    @Inject(forwardRef(() => EventsService))
    private readonly eventsService: EventsService,
  ) {}

  async getRecommendations(userId: string) {
    try {
      // 1. Get all events and the specific user
      const [events, user] = await Promise.all([
        this.eventsService.findAll({ take: 100 }),
        // Assuming eventsService or a shared UsersService can fetch user interests
        // For simplicity, we'll fetch via eventsService or replace with actual user fetch
        this.eventsService.getUserWithInterests(userId),
      ]);

      if (!user || events.length === 0) {
        return this.eventsService.getTrending(10);
      }

      const userInterests = user.interests || [];
      if (userInterests.length === 0) {
        return this.eventsService.getTrending(10);
      }

      // 2. Simple Content-Based Filtering (Native TS Implementation)
      // We calculate similarity between user interest tags and event description/category
      const scoredEvents = events.map(event => {
        const eventText = `${event.title} ${event.description} ${event.category}`.toLowerCase();
        let score = 0;

        // Count interest matches
        userInterests.forEach(interest => {
          if (eventText.includes(interest.toLowerCase())) {
            score += 1.0;
          }
        });

        // Add popularity weight (30%)
        const maxAttendees = Math.max(...events.map(e => e.attendeesCount), 1);
        const popularityScore = (event.attendeesCount || 0) / maxAttendees;
        
        const finalScore = (score * 0.7) + (popularityScore * 0.3);
        return { event, score: finalScore };
      });

      // 3. Sort and return top 10
      return scoredEvents
        .sort((a, b) => b.score - a.score)
        .slice(0, 10)
        .map(item => item.event);

    } catch (error) {
      console.error('Error calculating native recommendations:', error);
      return this.eventsService.getTrending(10);
    }
  }
}
