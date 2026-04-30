import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Patch,
} from '@nestjs/common';
/**
 * Administrative controller for managing users, events, and moderation.
 * Access is restricted to users with the ADMIN role.
 */
// Touch for re-indexing
import { UsersService } from '../users/users.service';
import { EventsService } from '../events/events.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role, EventStatus } from '@prisma/client';

@Controller('admin')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(Role.ADMIN)
export class AdminController {
  constructor(
    private readonly usersService: UsersService,
    private readonly eventsService: EventsService,
  ) {}

  @Get('users')
  async getAllUsers() {
    return this.usersService.findAll();
  }

  @Post('make-admin/:id')
  async makeAdmin(@Param('id') id: string) {
    return this.usersService.updateUser(id, { role: Role.ADMIN });
  }

  @Get('users/leaderboard')
  async getLeaderboard() {
    return this.usersService.getLeaderboard();
  }

  @Get('events/pending')
  async getPendingEvents() {
    return this.eventsService.findAll({ where: { status: EventStatus.PENDING } });
  }

  @Patch('events/moderate/:id')
  async moderateEvent(
    @Param('id') id: string,
    @Body('status') status: EventStatus,
  ) {
    return this.eventsService.updateEvent(id, { status });
  }
}
