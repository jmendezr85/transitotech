import { Response } from 'express';

export class ApiResponse {
  static success<T>(res: Response, data: T, message: string = 'Operación exitosa', statusCode: number = 200): Response {
    return res.status(statusCode).json({
      success: true,
      message,
      data,
    });
  }

  static error(res: Response, error: string, statusCode: number = 400): Response {
    return res.status(statusCode).json({
      success: false,
      error,
      statusCode,
    });
  }
}