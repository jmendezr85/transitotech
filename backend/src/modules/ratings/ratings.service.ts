import { RatingsRepository, RatingData } from './ratings.repository.js';

export class RatingsService {
  private ratingsRepository: RatingsRepository;

  constructor() {
    this.ratingsRepository = new RatingsRepository();
  }

  async submitRating(data: RatingData) {
    if (data.score < 1 || data.score > 5) {
      throw { statusCode: 400, message: 'La puntuación debe estar entre 1 y 5 estrellas.' };
    }
    return await this.ratingsRepository.createRating(data);
  }

  async getBusRatingSummary(busId: string) {
    return await this.ratingsRepository.getBusAverageRating(busId);
  }
}