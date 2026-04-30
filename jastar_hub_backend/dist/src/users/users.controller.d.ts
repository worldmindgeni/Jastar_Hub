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
    getLeaderboard(): Promise<{
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
    followUser(id: string, req: any): Promise<{
        following: boolean;
    }>;
    unfollowUser(id: string, req: any): Promise<{
        following: boolean;
    }>;
    getFollowers(id: string): Promise<{
        id: string;
        name: string;
        avatarUrl: string | null;
        rank: string;
        points: number;
    }[]>;
    getFollowing(id: string): Promise<{
        id: string;
        name: string;
        avatarUrl: string | null;
        rank: string;
        points: number;
    }[]>;
}
