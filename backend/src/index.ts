import express from 'express';
import { createServer } from 'http';
import { Server } from 'socket.io';
import cors from 'cors';
import dotenv from 'dotenv';
import path from 'path';

import { pool } from './config/database.js';
import { setupTrackingGateway } from './shared/websocket/tracking.gateway.js';
import { errorHandler } from './shared/middlewares/errorHandler.js';

// Importaciones con las rutas exactas de tu árbol de proyecto
import { authRouter } from './modules/auth/auth.routes.js';
import { routesRouter } from './modules/routes/routes.routes.js';

dotenv.config({ path: path.resolve(process.cwd(), '.env') });

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Endpoints REST
app.use('/api/v1/auth', authRouter);
app.use('/api/v1/routes', routesRouter);

const httpServer = createServer(app);
const io = new Server(httpServer, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  },
});

setupTrackingGateway(io);
app.use(errorHandler);

httpServer.listen(PORT, async () => {
  console.log(`🚀 Servidor HTTP y WebSockets TransitoTech corriendo en el puerto ${PORT}`);
  try {
    const client = await pool.connect();
    console.log('⚡ Conexión exitosa a la base de datos PostgreSQL/PostGIS');
    client.release();
  } catch (err) {
    console.error('💥 Error conectando a PostgreSQL/PostGIS:', err);
  }
});