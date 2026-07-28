-- 1. Insertar una Ruta de Prueba con trazado LineString (SRID 4326)
INSERT INTO routes (id, code, name, color_hex, path, is_active)
VALUES (
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
    'RUTA-101',
    'Ruta Express - Centro a Terminal Norte',
    '#1E88E5',
    ST_GeomFromText('LINESTRING(-72.507 7.889, -72.508 7.890, -72.509 7.892, -72.510 7.895)', 4326),
    TRUE
) ON CONFLICT (code) DO NOTHING;

-- 2. Insertar 3 Paraderos de Prueba con geometría Point (SRID 4326)
INSERT INTO stops (id, name, location)
VALUES 
    ('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'Paradero 1 - Parque Central', ST_SetSRID(ST_MakePoint(-72.507, 7.889), 4326)),
    ('c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 'Paradero 2 - Hospital General', ST_SetSRID(ST_MakePoint(-72.508, 7.890), 4326)),
    ('d3eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', 'Paradero 3 - Terminal Norte', ST_SetSRID(ST_MakePoint(-72.510, 7.895), 4326))
ON CONFLICT DO NOTHING;

-- 3. Vincular los Paraderos a la Ruta con su Orden Secuencial
INSERT INTO route_stops (route_id, stop_id, stop_order)
VALUES 
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 1),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 2),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', 3)
ON CONFLICT DO NOTHING;