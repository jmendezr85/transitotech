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
      const { full_name, email, password, role } = req.body;

      if (!full_name || !email || !password) {
        return ApiResponse.error(res, 'Todos los campos son obligatorios.', 400);
      }

      // Se usa register(...) tal como se declaró en AuthService
      const user = await this.authService.register({
        full_name,
        email,
        password,
        role: role || 'passenger',
      });

      return ApiResponse.success(res, user, 'Usuario registrado exitosamente.', 201);
    } catch (error) {
      next(error);
    }
  };

  login = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { email, password } = req.body;

      if (!email || !password) {
        return ApiResponse.error(res, 'Email y contraseña son requeridos.', 400);
      }

      // Se usa login(...) tal como se declaró en AuthService
      const result = await this.authService.login(email, password);
      return ApiResponse.success(res, result, 'Inicio de sesión exitoso.', 200);
    } catch (error) {
      next(error);
    }
  };
}