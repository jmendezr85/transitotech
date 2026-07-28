import { TrackingRepository, BusLocationUpdate } from './tracking.repository.js';

export class TrackingService {
  private trackingRepository: TrackingRepository;

  constructor() {
    this.trackingRepository = new TrackingRepository();
  }

  async processLocationUpdate(data: BusLocationUpdate) {
    if (!data.bus_id || data.latitude === undefined || data.longitude === undefined) {
      throw new Error('Datos de ubicación incompletos (bus_id, latitude, longitude requeridos).');
    }
    await this.trackingRepository.updateBusLocation(data);
  }

  async getActiveBuses() {
    return await this.trackingRepository.findActiveBuses();
  }
}