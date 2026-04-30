import { EventsService } from './events.service';
import { Prisma, Event } from '@prisma/client';
export declare class EventsController {
    private readonly eventsService;
    constructor(eventsService: EventsService);
    getEvents(category?: string, city?: string, search?: string, skip?: string, take?: string, sort?: string): Promise<Event[]>;
    getTrending(take?: string): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        organizerId: string;
        title: string;
        description: string;
        imageUrl: string;
        category: string;
        date: Date;
        location: string;
        city: string;
        latitude: number;
        longitude: number;
        price: number;
        attendeesCount: number;
        maxAttendees: number;
        status: import("@prisma/client").$Enums.EventStatus;
    }[]>;
    getEventById(id: string): Promise<Event>;
    createEvent(req: any, eventData: Omit<Prisma.EventCreateInput, 'organizer'>): Promise<Event>;
    joinEvent(id: string, req: any): Promise<{
        id: string;
        createdAt: Date;
        eventId: string;
        userId: string;
    }>;
    leaveEvent(id: string, req: any): Promise<{
        id: string;
        createdAt: Date;
        eventId: string;
        userId: string;
    }>;
    toggleFavorite(id: string, req: any): Promise<{
        isFavorite: boolean;
    }>;
    getUserFavorites(req: any): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        organizerId: string;
        title: string;
        description: string;
        imageUrl: string;
        category: string;
        date: Date;
        location: string;
        city: string;
        latitude: number;
        longitude: number;
        price: number;
        attendeesCount: number;
        maxAttendees: number;
        status: import("@prisma/client").$Enums.EventStatus;
    }[]>;
    getUserOrganizedEvents(req: any): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        organizerId: string;
        title: string;
        description: string;
        imageUrl: string;
        category: string;
        date: Date;
        location: string;
        city: string;
        latitude: number;
        longitude: number;
        price: number;
        attendeesCount: number;
        maxAttendees: number;
        status: import("@prisma/client").$Enums.EventStatus;
    }[]>;
    getUserJoinedEvents(req: any): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        organizerId: string;
        title: string;
        description: string;
        imageUrl: string;
        category: string;
        date: Date;
        location: string;
        city: string;
        latitude: number;
        longitude: number;
        price: number;
        attendeesCount: number;
        maxAttendees: number;
        status: import("@prisma/client").$Enums.EventStatus;
    }[]>;
    trackInteraction(id: string, req: any, type: string): Promise<{
        id: string;
        createdAt: Date;
        eventId: string;
        userId: string;
        type: string;
    }>;
}
