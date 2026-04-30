import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { EventsModule } from './events/events.module';
import { AdminModule } from './admin/admin.module';
import { ChatModule } from './chat/chat.module';
import { RecommendationsModule } from './recommendations/recommendations.module';

@Module({
  imports: [PrismaModule, AuthModule, UsersModule, EventsModule, AdminModule, ChatModule, RecommendationsModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
