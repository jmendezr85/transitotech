import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { pool } from './config/database.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Endpoint de verificación de salud y conectividad con PostGIS
app.get('/health', async (req, res) => {
  try {
    const dbResult = await pool.query('SELECT PostGIS_Full_Version() as version;');
    res.status(200).json({
      status: 'ok',
      service: 'TransitoTech API',
      database: 'Connected',
      postgis_version: dbResult.rows[0].version,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      service: 'TransitoTech API',
      database: 'Disconnected',
      error: error instanceof Error ? error.message : 'Unknown error'
    });
  }
});

app.listen(PORT, () => {
  console.log(`🚀 Servidor TransitoTech corriendo en http://localhost:${PORT}`);
});