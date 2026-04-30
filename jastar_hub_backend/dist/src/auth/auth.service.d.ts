import { UsersService } from '../users/users.service';
import { JwtService } from '@nestjs/jwt';
import { RegisterDto, LoginDto } from './dto/auth.dto';
export declare class AuthService {
    private usersService;
    private jwtService;
    constructor(usersService: UsersService, jwtService: JwtService);
    register(registerDto: RegisterDto): Promise<{
        access_token: string;
        user: {
            id: string;
            email: string;
            name: string;
        };
    }>;
    login(loginDto: LoginDto): Promise<{
        access_token: string;
        user: {
            id: string;
            email: string;
            name: string;
            avatarUrl: string | null;
            rank: string;
            points: number;
            role: import("@prisma/client").$Enums.Role;
        };
    }>;
    getProfile(userId: string): Promise<{
        id: string;
        email: string;
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
}
