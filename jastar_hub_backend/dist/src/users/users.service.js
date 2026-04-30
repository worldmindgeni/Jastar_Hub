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
exports.UsersService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let UsersService = class UsersService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async findOne(where) {
        return this.prisma.user.findUnique({ where });
    }
    async createUser(data) {
        return this.prisma.user.create({ data });
    }
    async updateUser(id, data) {
        return this.prisma.user.update({
            where: { id },
            data,
        });
    }
    async findAll() {
        return this.prisma.user.findMany({
            select: {
                id: true,
                email: true,
                name: true,
                avatarUrl: true,
                bio: true,
                role: true,
                interests: true,
                rank: true,
                points: true,
                eventsAttended: true,
                eventsOrganized: true,
                followers: true,
                following: true,
                createdAt: true,
                updatedAt: true,
                password: false,
            },
        });
    }
    async getLeaderboard() {
        return this.prisma.user.findMany({
            orderBy: { points: 'desc' },
            take: 20,
            select: {
                id: true,
                name: true,
                avatarUrl: true,
                rank: true,
                points: true,
                eventsAttended: true,
                password: false,
                email: true,
                bio: true,
                role: true,
                interests: true,
                eventsOrganized: true,
                followers: true,
                following: true,
                createdAt: true,
                updatedAt: true,
            },
        });
    }
    async followUser(followerId, followingId) {
        if (followerId === followingId) {
            throw new common_1.ConflictException('Cannot follow yourself');
        }
        const existing = await this.prisma.follow.findUnique({
            where: { followerId_followingId: { followerId, followingId } },
        });
        if (existing) {
            throw new common_1.ConflictException('Already following this user');
        }
        return this.prisma.$transaction(async (tx) => {
            await tx.follow.create({
                data: { followerId, followingId },
            });
            await tx.user.update({
                where: { id: followerId },
                data: { following: { increment: 1 } },
            });
            await tx.user.update({
                where: { id: followingId },
                data: { followers: { increment: 1 } },
            });
            return { following: true };
        });
    }
    async unfollowUser(followerId, followingId) {
        return this.prisma.$transaction(async (tx) => {
            await tx.follow.delete({
                where: { followerId_followingId: { followerId, followingId } },
            });
            await tx.user.update({
                where: { id: followerId },
                data: { following: { decrement: 1 } },
            });
            await tx.user.update({
                where: { id: followingId },
                data: { followers: { decrement: 1 } },
            });
            return { following: false };
        });
    }
    async getFollowers(userId) {
        const follows = await this.prisma.follow.findMany({
            where: { followingId: userId },
            include: {
                follower: {
                    select: { id: true, name: true, avatarUrl: true, rank: true, points: true },
                },
            },
        });
        return follows.map((f) => f.follower);
    }
    async getFollowing(userId) {
        const follows = await this.prisma.follow.findMany({
            where: { followerId: userId },
            include: {
                following: {
                    select: { id: true, name: true, avatarUrl: true, rank: true, points: true },
                },
            },
        });
        return follows.map((f) => f.following);
    }
};
exports.UsersService = UsersService;
exports.UsersService = UsersService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], UsersService);
//# sourceMappingURL=users.service.js.map