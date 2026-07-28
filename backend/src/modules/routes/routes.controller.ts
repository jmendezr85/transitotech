import { Request, Response, NextFunction } from 'express';
import { RoutesService } from './routes.service.js';
import { ApiResponse } from '../../shared/utils/apiResponse.js';

export class RoutesController {
  private routesService: RoutesService;

  constructor() {
    this.routesService = new RoutesService();
  }

  getAllRoutes = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const routes = await this.routesService.getAllActiveRoutes();
      return ApiResponse.success(res, routes, 'Lista de rutas activas obtenida exitosamente.', 200);
    } catch (error) {
      next(error);
    }
  };

  getRouteById = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { id } = req.params;
      const routeId = Array.isArray(id) ? id[0] : id; // Garantiza que siempre sea un string

      if (!routeId) {
        return ApiResponse.error(res, 'El parámetro ID de la ruta es requerido.', 400);
      }

      const routeDetails = await this.routesService.getRouteDetails(routeId);
      return ApiResponse.success(res, routeDetails, 'Detalles de la ruta obtenidos exitosamente.', 200);
    } catch (error) {
      next(error);
    }
  };
}