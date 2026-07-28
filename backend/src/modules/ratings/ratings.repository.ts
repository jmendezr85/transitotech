import { pool } from '../../config/database.js';

export interface RatingData {
  user_id: string;
  bus_id: string;
  route_id: string;
  score: number;
  comment?: string;
}

export class RatingsRepository {
  async createRating(data: RatingData) {
    const query = `
      INSERT INTO ratings (user_id, bus_id, route_id, score, comment)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING id, score, comment, created_at;
    `;
    const values = [data.user_id, data.bus_id, data.route_id, data.score, data.comment || null];
    const result = await pool.query(query, values);
    return result.rows[0];
  }

  async getBusAverageRating(busId: string) {
    const query = `
      SELECT 
        bus_id,
        ROUND(AVG(score)::numeric, 1) AS average_score,
        COUNT(id)::int AS total_ratings
      FROM ratings
      WHERE bus_id = $1
      GROUP BY bus_id;
    `;
    const result = await pool.query(query, [busId]);
    return result.rows[0] || { bus_id: busId, average_score: 0, total_ratings: 0 };
  }
}