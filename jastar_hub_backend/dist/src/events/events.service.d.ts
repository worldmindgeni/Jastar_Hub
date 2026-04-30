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
    toggleFavorite(eventId: string, userId: string): Promise<{
        isFavorite: boolean;
    }>;
    getUserFavorites(userId: string): Promise<Event[]>;
    trackInteraction(eventId: string, userId: string, type: string): Promise<{
        id: string;
        createdAt: Date;
        eventId: string;
        userId: string;
        type: string;
    }>;
    updateEvent(id: string, data: Prisma.EventUpdateInput): Promise<Event>;
    deleteEvent(where: Prisma.EventWhereUniqueInput): Promise<Event>;
    getTrending(take?: number): Promise<Event[]>;
    getUserOrganizedEvents(userId: string): Promise<Event[]>;
    getUserJoinedEvents(userId: string): Promise<Event[]>;
}
