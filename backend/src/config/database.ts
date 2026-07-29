import pg from 'pg';
import dotenv from 'dotenv';
import path from 'path';

// Carga .env desde la raíz del proceso (backend/)
dotenv.config();

const { Pool } = pg;

const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  console.error('❌ ERROR CRÍTICO: DATABASE_URL no está definida en el archivo .env');
} else {
  console.log('✅ DATABASE_URL cargada correctamente.');
}

export const pool = new Pool({
  connectionString,
  ssl: {
    rejectUnauthorized: false, // Requerido para Supabase Cloud
  },
});

pool.on('connect', () => {
  console.log('⚡ Conexión exitosa a la base de datos PostgreSQL/PostGIS');
});

pool.on('error', (err) => {
  console.error('💥 Error inesperado en el pool de PostgreSQL:', err);
});