-- 1. Habilitar extensiones requeridas (Geoespacial y UUIDs)
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Tabla de Usuarios y Autenticación
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'driver', 'passenger')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Tabla de Rutas de Transporte (Trazados Lineal Geográficos)
CREATE TABLE IF NOT EXISTS routes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    color_hex VARCHAR(7) DEFAULT '#1E88E5',
    path GEOMETRY(LineString, 4326),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Tabla de Paraderos / Estaciones (Puntos Geográficos Exactos)
CREATE TABLE IF NOT EXISTS stops (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    location GEOMETRY(Point, 4326) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Tabla Intermedia: Orden de Paraderos en cada Ruta
CREATE TABLE IF NOT EXISTS route_stops (
    route_id UUID REFERENCES routes(id) ON DELETE CASCADE,
    stop_id UUID REFERENCES stops(id) ON DELETE CASCADE,
    stop_order INT NOT NULL,
    PRIMARY KEY (route_id, stop_id)
);

-- 6. Tabla de Vehículos / Flota de Buses
CREATE TABLE IF NOT EXISTS buses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    plate VARCHAR(20) NOT NULL UNIQUE,
    driver_id UUID REFERENCES users(id) ON DELETE SET NULL,
    assigned_route_id UUID REFERENCES routes(id) ON DELETE SET NULL,
    is_online BOOLEAN DEFAULT FALSE,
    last_location GEOMETRY(Point, 4326),
    last_ping_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. Índices Espaciales GiST para Maximizar la Velocidad de Búsqueda
CREATE INDEX IF NOT EXISTS idx_routes_path ON routes USING GIST (path);
CREATE INDEX IF NOT EXISTS idx_stops_location ON stops USING GIST (location);
CREATE INDEX IF NOT EXISTS idx_buses_last_location ON buses USING GIST (last_location);