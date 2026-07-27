import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { pool } from './config/database.js';
import { ApiResponse } from './shared/utils/apiResponse.js';
import { errorHandler } from './shared/middlewares/errorHandler.js';
import authRoutes from './modules/auth/auth.routes.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Endpoints
app.get('/health', async (req, res, next) => {
  try {
    const dbResult = await pool.query('SELECT PostGIS_Full_Version() as version;');
    return ApiResponse.success(res, {
      service: 'TransitoTech API',
      database: 'Connected',
      postgis_version: dbResult.rows[0].version,
      timestamp: new Date().toISOString()
    }, 'Servidor y Base de Datos funcionando correctamente');
  } catch (error) {
    next(error);
  }
});

// Rutas de Módulos
app.use('/api/v1/auth', authRoutes);

// Middleware Global para captura de errores
app.use(errorHandler);

app.listen(PORT, () => {
  console.log(`🚀 Servidor TransitoTech corriendo en http://localhost:${PORT}`);
});