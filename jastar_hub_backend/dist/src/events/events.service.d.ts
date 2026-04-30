import { PrismaService } from '../prisma/prisma.service';
import { Prisma, Event } from '@prisma/client';
export declare class EventsService {
    private prisma;
    constructor(prisma: PrismaService);
    findAll(params: {
        skip?: number;
        take?: number;
        cursor?: Prisma.EventWhereUniqueInput;
        where?: Prisma.EventWhereInput;
        orderBy?: Prisma.EventOrderByWithRelationInput;
    }): Promise<Event[]>;
    findOne(id: string): Promise<Event>;
    createEvent(data: Prisma.EventCreateInput): Promise<Event>;
    joinEvent(eventId: string, userId: string): Promise<{
        id: string;
        createdAt: Date;
        eventId: string;
        userId: string;
    }>;
    leaveEvent(eventId: string, userId: string): Promise<{
        id: string;
        createdAt: Date;
        eventId: string;
        userId: string;
    }>;
    updateEvent(id: string, data: Prisma.EventUpdateInput): Promise<Event>;
    deleteEvent(where: Prisma.EventWhereUniqueInput): Promise<Event>;
}
