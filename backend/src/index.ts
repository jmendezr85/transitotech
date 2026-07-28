import express from 'express';
import { createServer } from 'http';
import { Server } from 'socket.io';
import cors from 'cors';
import dotenv from 'dotenv';

import { pool } from './config/database.js';
import { ApiResponse } from './shared/utils/apiResponse.js';
import { errorHandler } from './shared/middlewares/errorHandler.js';

import authRoutes from './modules/auth/auth.routes.js';
import routesRoutes from './modules/routes/routes.routes.js';
import trackingRoutes from './modules/tracking/tracking.routes.js';
import ratingsRoutes from './modules/ratings/ratings.routes.js';
import { TrackingGateway } from './modules/tracking/tracking.gateway.js';

dotenv.config();

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  },
});

const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Endpoint de Salud de la API y Base de Datos PostGIS
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

// Registrar Módulos de la API REST
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/routes', routesRoutes);
app.use('/api/v1/tracking', trackingRoutes);
app.use('/api/v1/ratings', ratingsRoutes);

// Inicializar Gateway de WebSockets
new TrackingGateway(io);

// Middleware Global para captura de errores
app.use(errorHandler);

httpServer.listen(PORT, () => {
  console.log(`🚀 Servidor HTTP y WebSockets TransitoTech corriendo en el puerto ${PORT}`);
});