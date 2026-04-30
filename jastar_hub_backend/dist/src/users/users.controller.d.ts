import { UsersService } from './users.service';
export declare class UsersController {
    private readonly usersService;
    constructor(usersService: UsersService);
    getProfile(req: any): Promise<{
        id: string;
        email: string;
        password: string;
        name: string;
        avatarUrl: string | null;
        bio: string | null;
        role: import("@prisma/client").$Enums.Role;
        interests: string[];
        rank: string;
        points: number;
        eventsAttended: number;
        eventsOrganized: number;
        followers: number;
        following: number;
        createdAt: Date;
        updatedAt: Date;
    } | null>;
    updateProfile(req: any, updateData: any): Promise<{
        id: string;
        email: string;
        password: string;
        name: string;
        avatarUrl: string | null;
        bio: string | null;
        role: import("@prisma/client").$Enums.Role;
        interests: string[];
        rank: string;
        points: number;
        eventsAttended: number;
        eventsOrganized: number;
        followers: number;
        following: number;
        createdAt: Date;
        updatedAt: Date;
    }>;
    findAll(): Promise<{
        id: string;
        email: string;
        password: string;
        name: string;
        avatarUrl: string | null;
        bio: string | null;
        role: import("@prisma/client").$Enums.Role;
        interests: string[];
        rank: string;
        points: number;
        eventsAttended: number;
        eventsOrganized: number;
        followers: number;
        following: number;
        createdAt: Date;
        updatedAt: Date;
    }[]>;
}
