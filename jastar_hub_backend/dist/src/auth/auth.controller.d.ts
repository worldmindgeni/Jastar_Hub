import { AuthService } from './auth.service';
import { RegisterDto, LoginDto } from './dto/auth.dto';
export declare class AuthController {
    private readonly authService;
    constructor(authService: AuthService);
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
    getMe(req: any): Promise<{
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
