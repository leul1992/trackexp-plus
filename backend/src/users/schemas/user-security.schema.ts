import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';
import { User } from './user.schema';

@Schema({ timestamps: true })
export class UserSecurity {
  @Prop({ type: Types.ObjectId, ref: User.name, required: true })
  user: Types.ObjectId;

  @Prop({ default: false })
  isBiometricEnabled: boolean;

  @Prop()
  fallbackPin?: string;
}

export type UserSecurityDocument = UserSecurity & Document;
export const UserSecuritySchema = SchemaFactory.createForClass(UserSecurity);
