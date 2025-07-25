import { Request } from 'express';

export interface RequestWithUser extends Request {
  user: {
    uid: string;
    email: string;
    name?: string;
    [key: string]: any; // optional to support extra Firebase fields
  };
}
