import { Controller, Get, Body, UseGuards, Request, Patch } from '@nestjs/common';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @UseGuards(JwtAuthGuard)
  @Get('profile')
  getProfile(@Request() req: any) {
    return this.usersService.findOne({ id: req.user.id });
  }

  @UseGuards(JwtAuthGuard)
  @Patch('profile')
  async updateProfile(@Request() req: any, @Body() updateData: any) {
    return this.usersService.updateUser(req.user.id, updateData);
  }

  // Admin route - we should add an AdminGuard later
  @Get()
  async findAll() {
    return this.usersService.findAll();
  }
}
