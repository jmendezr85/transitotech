import { Response, NextFunction } from 'express';
import { AuthenticatedRequest } from '../../shared/middlewares/authenticate.js';
import { RatingsService } from './ratings.service.js';
import { ApiResponse } from '../../shared/utils/apiResponse.js';

export class RatingsController {
  private ratingsService: RatingsService;

  constructor() {
    this.ratingsService = new RatingsService();
  }

  create = async (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user?.id;
      const { bus_id, route_id, score, comment } = req.body;

      if (!userId) {
        return ApiResponse.error(res, 'Usuario no autenticado.', 401);
      }

      if (!bus_id || !route_id || !score) {
        return ApiResponse.error(res, 'bus_id, route_id y score son obligatorios.', 400);
      }

      const rating = await this.ratingsService.submitRating({
        user_id: userId,
        bus_id,
        route_id,
        score: Number(score),
        comment,
      });

      return ApiResponse.success(res, rating, 'Calificación registrada exitosamente.', 201);
    } catch (error) {
      next(error);
    }
  };

  getByBus = async (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    try {
      const { bus_id } = req.params;
      const busId = Array.isArray(bus_id) ? bus_id[0] : bus_id;

      if (!busId) {
        return ApiResponse.error(res, 'El parámetro bus_id es requerido.', 400);
      }

      const summary = await this.ratingsService.getBusRatingSummary(busId);
      return ApiResponse.success(res, summary, 'Resumen de calificaciones del bus obtenido.', 200);
    } catch (error) {
      next(error);
    }
  };
}