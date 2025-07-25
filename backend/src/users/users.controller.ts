import {
  Controller,
  Get,
  Post,
  Patch,
  Body,
  Req,
  UseGuards,
  UnauthorizedException,
} from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { FirebaseAuthGuard } from '../auth/firebase-auth.guard';
import { RequestWithUser } from '../common/interfaces/request-with-user';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @UseGuards(FirebaseAuthGuard)
  @Post('create')
  async create(@Body() dto: CreateUserDto, @Req() req: RequestWithUser) {
    const decoded = req.user;
    if (decoded.email.toLowerCase() !== dto.email.toLowerCase()) {
      throw new UnauthorizedException('Token email mismatch');
    }
    return this.usersService.create(dto);
  }

  @UseGuards(FirebaseAuthGuard)
  @Get('profile')
  async getProfile(@Req() req: RequestWithUser) {
    const email = req.user.email;
    const user = await this.usersService.findByEmail(email);
    if (!user) throw new UnauthorizedException('User not found');
    return user;
  }

  @UseGuards(FirebaseAuthGuard)
  @Patch('profile')
  async updateProfile(@Body() dto: UpdateUserDto, @Req() req: RequestWithUser) {
    const email = req.user.email;
    const user = await this.usersService.findByEmail(email);
    if (!user) throw new UnauthorizedException('User not found');
    return this.usersService.update(user._id.toString(), dto);
  }
}
