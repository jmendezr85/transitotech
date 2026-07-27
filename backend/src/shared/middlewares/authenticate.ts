import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { ApiResponse } from '../utils/apiResponse.js';

export interface AuthenticatedRequest extends Request {
  user?: {
    id: string;
    email: string;
    role: string;
  };
}

export const authenticate = (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return ApiResponse.error(res, 'Acceso denegado. No se proporcionó un Token válido.', 401);
  }

  const token = authHeader.split(' ')[1];

  try {
    const secret = process.env.JWT_SECRET || 'transitotech_secret_key_dev';
    const decoded = jwt.verify(token, secret) as { id: string; email: string; role: string };
    
    req.user = decoded;
    next();
  } catch (error) {
    return ApiResponse.error(res, 'Token inválido o expirado.', 401);
  }
};