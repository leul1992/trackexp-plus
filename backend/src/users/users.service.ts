import { Injectable, ConflictException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { User, UserDocument } from './schemas/user.schema';
import {
  UserSecurity,
  UserSecurityDocument,
} from './schemas/user-security.schema';

@Injectable()
export class UsersService {
  constructor(
    @InjectModel(User.name) private userModel: Model<UserDocument>,
    @InjectModel(UserSecurity.name)
    private userSecurityModel: Model<UserSecurityDocument>,
  ) {}

  async create(createUserDto: CreateUserDto): Promise<User> {
    const { email, handle } = createUserDto;

    // Normalize email and handle
    createUserDto.email = email.toLowerCase();
    createUserDto.handle = handle.toLowerCase();

    // Check for existing email or handle
    const existingUser = await this.userModel.findOne({
      $or: [{ email: createUserDto.email }, { handle: createUserDto.handle }],
    });
    if (existingUser) {
      if (existingUser.email === createUserDto.email) {
        throw new ConflictException('Email is already registered');
      }
      if (existingUser.handle === createUserDto.handle) {
        throw new ConflictException('Handle is already taken');
      }
    }

    const user = new this.userModel(createUserDto);
    const savedUser = await user.save();

    const userSecurity = new this.userSecurityModel({ user: savedUser._id });
    await userSecurity.save();

    return savedUser;
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.userModel.findOne({ email: email.toLowerCase() }).exec();
  }

  async update(id: string, updateUserDto: UpdateUserDto): Promise<User> {
    if (updateUserDto.email) {
      updateUserDto.email = updateUserDto.email.toLowerCase();
    }
    if (updateUserDto.handle) {
      updateUserDto.handle = updateUserDto.handle.toLowerCase();
      const existingHandle = await this.userModel.findOne({
        handle: updateUserDto.handle,
        _id: { $ne: id },
      });
      if (existingHandle) {
        throw new ConflictException('Handle is already taken');
      }
    }

    const updatedUser = await this.userModel
      .findByIdAndUpdate(id, updateUserDto, { new: true })
      .exec();

    if (!updatedUser) {
      throw new ConflictException('User not found');
    }

    return updatedUser;
  }
}
