import { pool } from '../../config/database.js';

export interface BusLocationUpdate {
  bus_id: string;
  latitude: number;
  longitude: number;
}

export class TrackingRepository {
  // Actualizar la última ubicación conocida del bus usando PostGIS (ST_SetSRID + ST_MakePoint)
  async updateBusLocation(data: BusLocationUpdate): Promise<void> {
    const query = `
      UPDATE buses 
      SET 
        last_location = ST_SetSRID(ST_MakePoint($1, $2), 4326),
        last_ping_at = NOW(),
        is_online = TRUE
      WHERE id = $3;
    `;
    // $1 = Longitud, $2 = Latitud (Formato estándar PostGIS ST_MakePoint(X, Y))
    await pool.query(query, [data.longitude, data.latitude, data.bus_id]);
  }

  // Consultar todos los buses actualmente activos en línea con su punto GeoJSON
  async findActiveBuses(): Promise<any[]> {
    const query = `
      SELECT 
        id AS bus_id,
        plate,
        assigned_route_id AS route_id,
        is_online,
        ST_AsGeoJSON(last_location)::json AS last_location,
        last_ping_at
      FROM buses
      WHERE is_online = TRUE AND last_location IS NOT NULL;
    `;
    const result = await pool.query(query);
    return result.rows;
  }
}