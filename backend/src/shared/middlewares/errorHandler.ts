import { Request, Response, NextFunction } from 'express';
import { ApiResponse } from '../utils/apiResponse.js';

export const errorHandler = (err: any, req: Request, res: Response, next: NextFunction) => {
  console.error(`❌ [Error Global]: ${err.stack || err.message || err}`);

  const statusCode = err.statusCode || 500;
  const message = err.message || 'Error interno del servidor';

  return ApiResponse.error(res, message, statusCode);
};