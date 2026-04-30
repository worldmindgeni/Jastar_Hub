import { PrismaService } from '../prisma/prisma.service';
import { Prisma, User } from '@prisma/client';
export declare class UsersService {
    private prisma;
    constructor(prisma: PrismaService);
    findOne(where: Prisma.UserWhereUniqueInput): Promise<User | null>;
    createUser(data: Prisma.UserCreateInput): Promise<User>;
    updateUser(id: String, data: Prisma.UserUpdateInput): Promise<User>;
    findAll(): Promise<User[]>;
    getLeaderboard(): Promise<User[]>;
}
