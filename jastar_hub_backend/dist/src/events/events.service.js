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
    async findOne(id) {
        const event = await this.prisma.event.findUnique({
            where: { id },
            include: {
                organizer: {
                    select: { id: true, name: true, avatarUrl: true },
                },
            },
        });
        if (!event) {
            throw new common_1.NotFoundException(`Event with ID ${id} not found`);
        }
        return event;
    }
    async createEvent(data) {
        return this.prisma.event.create({
            data,
        });
    }
    async joinEvent(eventId, userId) {
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
    async updateEvent(id, data) {
        return this.prisma.event.update({
            where: { id },
            data,
        });
    }
    async deleteEvent(where) {
        return this.prisma.event.delete({
            where,
        });
    }
};
exports.EventsService = EventsService;
exports.EventsService = EventsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], EventsService);
//# sourceMappingURL=events.service.js.map