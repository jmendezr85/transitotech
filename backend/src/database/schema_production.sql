-- 1. Habilitar la extensión geoespacial PostGIS
CREATE EXTENSION IF NOT EXISTS postgis;

-- 2. Tabla de Usuarios (Auth)
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'passenger' CHECK (role IN ('passenger', 'driver', 'admin')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Tabla de Rutas de Transporte (LineString GeoJSON)
CREATE TABLE IF NOT EXISTS routes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    color_hex VARCHAR(7) DEFAULT '#1E88E5',
    path GEOMETRY(LineString, 4326),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Tabla de Paraderos (Point GeoJSON)
CREATE TABLE IF NOT EXISTS stops (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    location GEOMETRY(Point, 4326),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. Tabla Intermedia: Paraderos por Ruta en Orden Secuencial
CREATE TABLE IF NOT EXISTS route_stops (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    route_id UUID NOT NULL REFERENCES routes(id) ON DELETE CASCADE,
    stop_id UUID NOT NULL REFERENCES stops(id) ON DELETE CASCADE,
    stop_order INT NOT NULL,
    CONSTRAINT unique_route_stop_order UNIQUE (route_id, stop_order)
);

-- 6. Tabla de Autobuses (Unidades de Transporte)
CREATE TABLE IF NOT EXISTS buses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    plate VARCHAR(20) UNIQUE NOT NULL,
    assigned_route_id UUID REFERENCES routes(id) ON DELETE SET NULL,
    is_online BOOLEAN DEFAULT FALSE,
    last_location GEOMETRY(Point, 4326),
    last_ping_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 7. Tabla de Calificaciones y Feedback (SPEC-006)
CREATE TABLE IF NOT EXISTS ratings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    bus_id UUID NOT NULL REFERENCES buses(id) ON DELETE CASCADE,
    route_id UUID NOT NULL REFERENCES routes(id) ON DELETE CASCADE,
    score INT NOT NULL CHECK (score >= 1 AND score <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 8. Creación de Índices Geoespaciales GiST e Índices Relacionales
CREATE INDEX IF NOT EXISTS idx_routes_path ON routes USING GIST(path);
CREATE INDEX IF NOT EXISTS idx_stops_location ON stops USING GIST(location);
CREATE INDEX IF NOT EXISTS idx_buses_location ON buses USING GIST(last_location);
CREATE INDEX IF NOT EXISTS idx_ratings_bus ON ratings(bus_id);
CREATE INDEX IF NOT EXISTS idx_ratings_route ON ratings(route_id);