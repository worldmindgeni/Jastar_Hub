import { Module, forwardRef } from '@nestjs/common';
import { EventsService } from './events.service';
import { EventsController } from './events.controller';
import { RecommendationsModule } from '../recommendations/recommendations.module';

@Module({
  imports: [forwardRef(() => RecommendationsModule)],
  providers: [EventsService],
  controllers: [EventsController],
  exports: [EventsService],
})
export class EventsModule {}
