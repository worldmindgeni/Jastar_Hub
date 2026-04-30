import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Prisma, User } from '@prisma/client';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async findOne(where: Prisma.UserWhereUniqueInput): Promise<User | null> {
    return this.prisma.user.findUnique({
      where,
    });
  }

  async createUser(data: Prisma.UserCreateInput): Promise<User> {
    return this.prisma.user.create({
      data,
    });
  }

  async updateUser(id: String, data: Prisma.UserUpdateInput): Promise<User> {
    return this.prisma.user.update({
      where: { id: id as string },
      data,
    });
  }

  async findAll(): Promise<User[]> {
    return this.prisma.user.findMany();
  }

  async getLeaderboard(): Promise<User[]> {
    return this.prisma.user.findMany({
      orderBy: { points: 'desc' },
      take: 10,
    });
  }
}
