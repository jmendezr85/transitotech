import { Request, Response, NextFunction } from 'express';
import { AuthService } from './auth.service.js';
import { ApiResponse } from '../../shared/utils/apiResponse.js';

export class AuthController {
  private authService: AuthService;

  constructor() {
    this.authService = new AuthService();
  }

  register = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { email, password, full_name } = req.body;
      if (!email || !password || !full_name) {
        return ApiResponse.error(res, 'Todos los campos son obligatorios.', 400);
      }

      const user = await this.authService.register({ email, password, full_name });
      return ApiResponse.success(res, user, 'Usuario registrado exitosamente.', 201);
    } catch (error) {
      next(error);
    }
  };

  login = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { email, password } = req.body;
      if (!email || !password) {
        return ApiResponse.error(res, 'Correo y contraseña requeridos.', 400);
      }

      const result = await this.authService.login({ email, password });
      return ApiResponse.success(res, result, 'Inicio de sesión exitoso.', 200);
    } catch (error) {
      next(error);
    }
  };
}