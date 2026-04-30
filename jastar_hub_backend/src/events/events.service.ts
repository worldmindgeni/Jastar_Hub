import { Injectable, NotFoundException } from '@nestjs/common';
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
      take,
      cursor,
      where: finalWhere,
      orderBy,
      include: {
        organizer: {
          select: { id: true, name: true, avatarUrl: true },
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
      },
    });

    if (!event) {
      throw new NotFoundException(`Event with ID ${id} not found`);
    }
    return event;
  }

  async createEvent(data: Prisma.EventCreateInput): Promise<Event> {
    return this.prisma.event.create({
      data,
    });
  }

  async joinEvent(eventId: string, userId: string) {
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

  async updateEvent(id: string, data: Prisma.EventUpdateInput): Promise<Event> {
    return this.prisma.event.update({
      where: { id },
      data,
    });
  }

  async deleteEvent(where: Prisma.EventWhereUniqueInput): Promise<Event> {
    return this.prisma.event.delete({
      where,
    });
  }
}
