import {
  Controller,
  Get,
  Body,
  UseGuards,
  Request,
  Patch,
  Post,
  Delete,
  Param,
  UseInterceptors,
  UploadedFile,
} from '@nestjs/common';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname } from 'path';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @UseGuards(JwtAuthGuard)
  @Get('profile')
  getProfile(@Request() req: { user: { id: string } }) {
    return this.usersService.findOne({ id: req.user.id });
  }

  @UseGuards(JwtAuthGuard)
  @Patch('profile')
  async updateProfile(@Request() req: { user: { id: string } }, @Body() updateData: any) {
    return this.usersService.updateUser(req.user.id, updateData);
  }

  @UseGuards(JwtAuthGuard)
  @Post('avatar')
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: './public/uploads',
        filename: (req, file, callback) => {
          const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
          const ext = extname(file.originalname);
          callback(null, `${uniqueSuffix}${ext}`);
        },
      }),
    }),
  )
  async uploadAvatar(@Request() req: { user: { id: string } }, @UploadedFile() file: Express.Multer.File) {
    const avatarUrl = `/public/uploads/${file.filename}`;
    return this.usersService.updateUser(req.user.id, { avatarUrl });
  }

  @Get(':id')
  async getUserById(@Param('id') id: string) {
    return this.usersService.findOne({ id });
  }

  @Get()
  async findAll() {
    return this.usersService.findAll();
  }

  @Get('leaderboard')
  async getLeaderboard() {
    return this.usersService.getLeaderboard();
  }

  @UseGuards(JwtAuthGuard)
  @Post(':id/follow')
  async followUser(@Param('id') id: string, @Request() req: { user: { id: string } }) {
    return this.usersService.followUser(req.user.id, id);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id/follow')
  async unfollowUser(@Param('id') id: string, @Request() req: { user: { id: string } }) {
    return this.usersService.unfollowUser(req.user.id, id);
  }

  @Get(':id/followers')
  async getFollowers(@Param('id') id: string) {
    return this.usersService.getFollowers(id);
  }

  @Get(':id/following')
  async getFollowing(@Param('id') id: string) {
    return this.usersService.getFollowing(id);
  }
}
