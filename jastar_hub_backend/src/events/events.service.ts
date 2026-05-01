import {
  Injectable,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Prisma, Event } from '@prisma/client';

@Injectable()
export class EventsService {
  constructor(private prisma: PrismaService) {}

  async findAll(params: {
    skip?: number;
    take?: number;
    cursor?: Prisma.EventWhereUniqueInput;
    where?: Prisma.EventWhereInput;
    orderBy?: Prisma.EventOrderByWithRelationInput;
  }): Promise<Event[]> {
    const { skip, take, cursor, where, orderBy } = params;

    // Default to only showing APPROVED events for general list
    const finalWhere = {
      ...where,
      status: where?.status || 'APPROVED',
    };

    return this.prisma.event.findMany({
      skip,
      take: take || 20,
      cursor,
      where: finalWhere,
      orderBy: orderBy || { date: 'asc' },
      include: {
        organizer: {
          select: { id: true, name: true, avatarUrl: true },
        },
        _count: {
          select: { favorites: true },
        },
      },
    });
  }

  async findOne(id: string): Promise<Event> {
    const event = await this.prisma.event.findUnique({
      where: { id },
      include: {
        organizer: {
          select: { id: true, name: true, avatarUrl: true },
        },
        _count: {
          select: { favorites: true, participations: true },
        },
      },
    });

    if (!event) {
      throw new NotFoundException(`Event with ID ${id} not found`);
    }
    return event;
  }

  async createEvent(data: Prisma.EventCreateInput): Promise<Event> {
    return this.prisma.event.create({ data });
  }

  async joinEvent(eventId: string, userId: string) {
    // Check if already joined
    const existing = await this.prisma.participation.findUnique({
      where: { userId_eventId: { userId, eventId } },
    });
    if (existing) {
      throw new ConflictException('Already joined this event');
    }

    return this.prisma.$transaction(async (tx) => {
      const participation = await tx.participation.create({
        data: { eventId, userId },
      });
      await tx.event.update({
        where: { id: eventId },
        data: { attendeesCount: { increment: 1 } },
      });
      await tx.user.update({
        where: { id: userId },
        data: {
          points: { increment: 10 },
          eventsAttended: { increment: 1 },
        },
      });
      return participation;
    });
  }

  async leaveEvent(eventId: string, userId: string) {
    return this.prisma.$transaction(async (tx) => {
      const participation = await tx.participation.delete({
        where: { userId_eventId: { userId, eventId } },
      });
      await tx.event.update({
        where: { id: eventId },
        data: { attendeesCount: { decrement: 1 } },
      });
      return participation;
    });
  }

  async toggleFavorite(eventId: string, userId: string) {
    const existing = await this.prisma.favorite.findUnique({
      where: { userId_eventId: { userId, eventId } },
    });

    if (existing) {
      await this.prisma.favorite.delete({
        where: { id: existing.id },
      });
      return { isFavorite: false };
    } else {
      await this.prisma.favorite.create({
        data: { userId, eventId },
      });
      return { isFavorite: true };
    }
  }

  async getUserFavorites(userId: string): Promise<Event[]> {
    const favorites = await this.prisma.favorite.findMany({
      where: { userId },
      include: {
        event: {
          include: {
            organizer: {
              select: { id: true, name: true, avatarUrl: true },
            },
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });
    return favorites.map((f) => f.event);
  }

  async trackInteraction(eventId: string, userId: string, type: string) {
    return this.prisma.eventInteraction.create({
      data: { eventId, userId, type },
    });
  }

  async updateEvent(id: string, data: Prisma.EventUpdateInput): Promise<Event> {
    return this.prisma.event.update({
      where: { id },
      data,
    });
  }

  async deleteEvent(where: Prisma.EventWhereUniqueInput): Promise<Event> {
    return this.prisma.event.delete({ where });
  }

  async getTrending(take: number = 10): Promise<Event[]> {
    return this.prisma.event.findMany({
      where: { status: 'APPROVED' },
      orderBy: { attendeesCount: 'desc' },
      take,
      include: {
        organizer: {
          select: { id: true, name: true, avatarUrl: true },
        },
      },
    });
  }

  async getUserOrganizedEvents(userId: string): Promise<Event[]> {
    return this.prisma.event.findMany({
      where: { organizerId: userId },
      include: {
        organizer: { select: { id: true, name: true, avatarUrl: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async getUserJoinedEvents(userId: string): Promise<Event[]> {
    const participations = await this.prisma.participation.findMany({
      where: { userId },
      include: {
        event: {
          include: {
            organizer: { select: { id: true, name: true, avatarUrl: true } },
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });
    return participations.map((p) => p.event);
  }

  async getUserWithInterests(id: string) {
    return this.prisma.user.findUnique({
      where: { id },
      select: { id: true, interests: true },
    });
  }
}
