import { Request, Response, NextFunction } from 'express';
import { TrackingService } from './tracking.service.js';
import { ApiResponse } from '../../shared/utils/apiResponse.js';

export class TrackingController {
  private trackingService: TrackingService;

  constructor() {
    this.trackingService = new TrackingService();
  }

  getActiveBuses = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const buses = await this.trackingService.getActiveBuses();
      return ApiResponse.success(res, buses, 'Lista de buses activos obtenida exitosamente.', 200);
    } catch (error) {
      next(error);
    }
  };
}