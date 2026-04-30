"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.EventsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let EventsService = class EventsService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async findAll(params) {
        const { skip, take, cursor, where, orderBy } = params;
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
    async findOne(id) {
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
            throw new common_1.NotFoundException(`Event with ID ${id} not found`);
        }
        return event;
    }
    async createEvent(data) {
        return this.prisma.event.create({ data });
    }
    async joinEvent(eventId, userId) {
        const existing = await this.prisma.participation.findUnique({
            where: { userId_eventId: { userId, eventId } },
        });
        if (existing) {
            throw new common_1.ConflictException('Already joined this event');
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
    async leaveEvent(eventId, userId) {
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
    async toggleFavorite(eventId, userId) {
        const existing = await this.prisma.favorite.findUnique({
            where: { userId_eventId: { userId, eventId } },
        });
        if (existing) {
            await this.prisma.favorite.delete({
                where: { id: existing.id },
            });
            return { isFavorite: false };
        }
        else {
            await this.prisma.favorite.create({
                data: { userId, eventId },
            });
            return { isFavorite: true };
        }
    }
    async getUserFavorites(userId) {
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
    async trackInteraction(eventId, userId, type) {
        return this.prisma.eventInteraction.create({
            data: { eventId, userId, type },
        });
    }
    async updateEvent(id, data) {
        return this.prisma.event.update({
            where: { id },
            data,
        });
    }
    async deleteEvent(where) {
        return this.prisma.event.delete({ where });
    }
    async getTrending(take = 10) {
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
    async getUserOrganizedEvents(userId) {
        return this.prisma.event.findMany({
            where: { organizerId: userId },
            include: {
                organizer: { select: { id: true, name: true, avatarUrl: true } },
            },
            orderBy: { createdAt: 'desc' },
        });
    }
    async getUserJoinedEvents(userId) {
        const participations = await this.prisma.participation.findMany({
            where: { userId },
            include: {
                event: {
                    include: { organizer: { select: { id: true, name: true, avatarUrl: true } } },
                },
            },
            orderBy: { createdAt: 'desc' },
        });
        return participations.map(p => p.event);
    }
};
exports.EventsService = EventsService;
exports.EventsService = EventsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], EventsService);
//# sourceMappingURL=events.service.js.map