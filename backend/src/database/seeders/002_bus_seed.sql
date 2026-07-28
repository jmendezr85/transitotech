-- Insertar un Bus de Prueba asignado a la Ruta 'RUTA-101'
INSERT INTO buses (id, plate, assigned_route_id, is_online, last_location, last_ping_at)
VALUES (
    'f47ac10b-58cc-4372-a567-0e02b2c3d479',
    'BUS-001',
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
    TRUE,
    ST_SetSRID(ST_MakePoint(-72.508, 7.890), 4326),
    NOW()
) ON CONFLICT (plate) DO UPDATE SET 
    is_online = TRUE,
    last_location = ST_SetSRID(ST_MakePoint(-72.508, 7.890), 4326),
    last_ping_at = NOW();