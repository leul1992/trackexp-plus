import {
  IsEmail,
  IsNotEmpty,
  Matches,
  IsBoolean,
  IsOptional,
} from 'class-validator';

export class CreateUserDto {
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @IsNotEmpty()
  @Matches(/^[a-zA-Z0-9_]{3,20}$/, {
    message:
      'Handle must be 3-20 characters, alphanumeric or underscores only.',
  })
  handle: string;

  @IsOptional()
  @IsBoolean()
  isPremium?: boolean;

  @IsOptional()
  avatar?: string;
}
