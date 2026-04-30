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
} from '@nestjs/common';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

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
