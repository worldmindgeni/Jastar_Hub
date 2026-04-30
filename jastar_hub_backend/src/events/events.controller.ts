import {
  Controller,
  Get,
  Post,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
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
    @Query('skip') skip?: string,
    @Query('take') take?: string,
    @Query('sort') sort?: string,
  ): Promise<Event[]> {
    const where: Prisma.EventWhereInput = {};
    if (category && category !== 'all') where.category = category;
    if (city) where.city = city;
    if (search) {
      where.OR = [
        { title: { contains: search, mode: 'insensitive' } },
        { description: { contains: search, mode: 'insensitive' } },
      ];
    }

    let orderBy: Prisma.EventOrderByWithRelationInput = { date: 'asc' };
    if (sort === 'popular') orderBy = { attendeesCount: 'desc' };
    if (sort === 'newest') orderBy = { createdAt: 'desc' };
    if (sort === 'price') orderBy = { price: 'asc' };

    return this.eventsService.findAll({
      where,
      orderBy,
      skip: skip ? parseInt(skip) : undefined,
      take: take ? parseInt(take) : undefined,
    });
  }

  @Get('trending')
  async getTrending(@Query('take') take?: string) {
    return this.eventsService.getTrending(take ? parseInt(take) : 10);
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

  @UseGuards(AuthGuard('jwt'))
  @Post(':id/favorite')
  async toggleFavorite(@Param('id') id: string, @Request() req: any) {
    return this.eventsService.toggleFavorite(id, req.user.id);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('user/favorites')
  async getUserFavorites(@Request() req: any) {
    return this.eventsService.getUserFavorites(req.user.id);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('user/organized')
  async getUserOrganizedEvents(@Request() req: any) {
    return this.eventsService.getUserOrganizedEvents(req.user.id);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('user/joined')
  async getUserJoinedEvents(@Request() req: any) {
    return this.eventsService.getUserJoinedEvents(req.user.id);
  }

  @UseGuards(AuthGuard('jwt'))
  @Post(':id/interact')
  async trackInteraction(
    @Param('id') id: string,
    @Request() req: any,
    @Body('type') type: string,
  ) {
    return this.eventsService.trackInteraction(id, req.user.id, type);
  }
}
