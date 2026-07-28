import { pool } from '../../config/database.js';

export interface Route {
  id: string;
  code: string;
  name: string;
  color_hex: string;
  is_active: boolean;
  path?: any;
}

export interface Stop {
  stop_id: string;
  name: string;
  stop_order: number;
  location: any;
}

export class RoutesRepository {
  // Listar todas las rutas activas (Resumen liviano)
  async findAllActive(): Promise<Route[]> {
    const query = `
      SELECT id, code, name, color_hex, is_active 
      FROM routes 
      WHERE is_active = TRUE 
      ORDER BY code ASC;
    `;
    const result = await pool.query(query);
    return result.rows;
  }

  // Obtener detalle de ruta con su trazado LineString convertido a GeoJSON
  async findByIdWithGeoJSON(id: string): Promise<Route | null> {
    const query = `
      SELECT 
        id, 
        code, 
        name, 
        color_hex, 
        is_active,
        ST_AsGeoJSON(path)::json AS path
      FROM routes 
      WHERE id = $1 LIMIT 1;
    `;
    const result = await pool.query(query, [id]);
    return result.rows[0] || null;
  }

  // Obtener paraderos ordenados pertenecientes a la ruta con su Point en GeoJSON
  async findStopsByRouteId(routeId: string): Promise<Stop[]> {
    const query = `
      SELECT 
        s.id AS stop_id,
        s.name,
        rs.stop_order,
        ST_AsGeoJSON(s.location)::json AS location
      FROM route_stops rs
      JOIN stops s ON rs.stop_id = s.id
      WHERE rs.route_id = $1
      ORDER BY rs.stop_order ASC;
    `;
    const result = await pool.query(query, [routeId]);
    return result.rows;
  }
}