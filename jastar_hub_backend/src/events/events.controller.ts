import { Controller, Get, Post, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
import { EventsService } from './events.service';
import { Prisma, Event } from '@prisma/client';
import { AuthGuard } from '@nestjs/passport';

@Controller('events')
export class EventsController {
  constructor(private readonly eventsService: EventsService) {}

  @Get()
  async getEvents(
    @Query('category') category?: string,
    @Query('city') city?: string,
    @Query('search') search?: string,
  ): Promise<Event[]> {
    const where: Prisma.EventWhereInput = {};
    if (category) where.category = category;
    if (city) where.city = city;
    if (search) {
      where.OR = [
        { title: { contains: search, mode: 'insensitive' } },
        { description: { contains: search, mode: 'insensitive' } },
      ];
    }

    return this.eventsService.findAll({
      where,
      orderBy: { date: 'asc' },
    });
  }

  @Get(':id')
  async getEventById(@Param('id') id: string): Promise<Event> {
    return this.eventsService.findOne(id);
  }

  @UseGuards(AuthGuard('jwt'))
  @Post()
  async createEvent(
    @Request() req: any,
    @Body() eventData: Omit<Prisma.EventCreateInput, 'organizer'>,
  ): Promise<Event> {
    return this.eventsService.createEvent({
      ...eventData,
      organizer: {
        connect: { id: req.user.id },
      },
    });
  }
  @UseGuards(AuthGuard('jwt'))
  @Post(':id/join')
  async joinEvent(@Param('id') id: string, @Request() req: any) {
    return this.eventsService.joinEvent(id, req.user.id);
  }

  @UseGuards(AuthGuard('jwt'))
  @Post(':id/leave')
  async leaveEvent(@Param('id') id: string, @Request() req: any) {
    return this.eventsService.leaveEvent(id, req.user.id);
  }
}
