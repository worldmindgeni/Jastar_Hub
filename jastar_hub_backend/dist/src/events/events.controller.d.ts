import { EventsService } from './events.service';
import { Prisma, Event } from '@prisma/client';
export declare class EventsController {
    private readonly eventsService;
    constructor(eventsService: EventsService);
    getEvents(category?: string, city?: string, search?: string): Promise<Event[]>;
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
}
