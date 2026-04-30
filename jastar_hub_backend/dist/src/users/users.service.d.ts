import { PrismaService } from '../prisma/prisma.service';
import { Prisma, User } from '@prisma/client';
export declare class UsersService {
    private prisma;
    constructor(prisma: PrismaService);
    findOne(where: Prisma.UserWhereUniqueInput): Promise<User | null>;
    createUser(data: Prisma.UserCreateInput): Promise<User>;
    updateUser(id: string, data: Prisma.UserUpdateInput): Promise<User>;
    findAll(): Promise<User[]>;
    getLeaderboard(): Promise<User[]>;
    followUser(followerId: string, followingId: string): Promise<{
        following: boolean;
    }>;
    unfollowUser(followerId: string, followingId: string): Promise<{
        following: boolean;
    }>;
    getFollowers(userId: string): Promise<{
        id: string;
        name: string;
        avatarUrl: string | null;
        rank: string;
        points: number;
    }[]>;
    getFollowing(userId: string): Promise<{
        id: string;
        name: string;
        avatarUrl: string | null;
        rank: string;
        points: number;
    }[]>;
}
