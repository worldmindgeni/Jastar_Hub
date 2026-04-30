import { Module } from '@nestjs/common';
import { AdminController } from './admin.controller';
import { UsersModule } from '../users/users.module';
import { EventsModule } from '../events/events.module';

@Module({
  imports: [UsersModule, EventsModule],
  controllers: [AdminController],
})
export class AdminModule {}
