import { RoutesRepository } from './routes.repository.js';

export class RoutesService {
  private routesRepository: RoutesRepository;

  constructor() {
    this.routesRepository = new RoutesRepository();
  }

  async getAllActiveRoutes() {
    return await this.routesRepository.findAllActive();
  }

  async getRouteDetails(id: string) {
    const route = await this.routesRepository.findByIdWithGeoJSON(id);
    if (!route) {
      throw { statusCode: 404, message: 'La ruta solicitada no existe o no está activa.' };
    }

    const stops = await this.routesRepository.findStopsByRouteId(id);

    return {
      ...route,
      stops,
    };
  }
}