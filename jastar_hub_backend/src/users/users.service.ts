import { Injectable, ConflictException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Prisma, User } from '@prisma/client';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async findOne(where: Prisma.UserWhereUniqueInput): Promise<User | null> {
    return this.prisma.user.findUnique({ where });
  }

  async createUser(data: Prisma.UserCreateInput): Promise<User> {
    return this.prisma.user.create({ data });
  }

  async updateUser(id: string, data: Prisma.UserUpdateInput): Promise<User> {
    return this.prisma.user.update({
      where: { id },
      data,
    });
  }

  async findAll(): Promise<User[]> {
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
    }) as unknown as User[];
  }

  async getLeaderboard(): Promise<User[]> {
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
    }) as unknown as User[];
  }

  async followUser(followerId: string, followingId: string) {
    if (followerId === followingId) {
      throw new ConflictException('Cannot follow yourself');
    }

    const existing = await this.prisma.follow.findUnique({
      where: { followerId_followingId: { followerId, followingId } },
    });
    if (existing) {
      throw new ConflictException('Already following this user');
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

  async unfollowUser(followerId: string, followingId: string) {
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

  async getFollowers(userId: string) {
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

  async getFollowing(userId: string) {
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
}
