# SPEC-004: Módulo de Rastreo en Tiempo Real (Live Tracking & WebSockets)

## 1. Contexto y Objetivos

- **Descripción General:** Módulo responsable del procesamiento, emisión y consumo en tiempo real de la ubicación GPS de los buses en ruta hacia la app móvil de pasajeros y el dashboard admin.
- **Público Objetivo:** Pasajeros (visualización de buses moviéndose en el mapa), Conductores/GPS (emisión de coordenadas) y Administradores (monitoreo de flotas).
- **Impacto en la Plataforma:** Lograr latencias de actualización < 500 ms en mapas usando WebSockets/PubSub evitando sobrecarga de escrituras en disco en PostgreSQL.

## 2. Requerimientos Funcionales y No Funcionales

### Requerimientos Funcionales (RF)

- [ ] **RF-01:** Permite a los conductores/unidades GPS emitir su ubicación en tiempo real (`latitude`, `longitude`, `speed`, `heading`, `bus_id`).
- [ ] **RF-02:** Permite a los pasajeros suscribirse al canal de WebSockets de una ruta específica para recibir únicamente los buses de esa ruta.
- [ ] **RF-03:** Actualiza la columna `last_location` y `last_ping_at` en la tabla `buses` de la base de datos de manera asíncrona / diferida.
- [ ] **RF-04:** Permite consultar la última ubicación conocida de todos los buses activos mediante un endpoint REST.

### Requerimientos No Funcionales (RNF)

- [ ] **RNF-01 (Rendimiento):** Emisión de evento WebSocket con latencia < 300 ms.
- [ ] **RNF-02 (Eficiencia $0):** Uso de WebSockets en memoria local (Socket.io / ws) en entorno dev, compatible con Supabase Realtime para producción en capa gratuita.

## 3. Contrato de Comunicación en Tiempo Real (WebSockets / Events)

### Evento de Emisión (Driver/GPS -> Server): `bus:location:update`

- **Payload (JSON):**

```json
{
  "bus_id": "uuid-v4",
  "route_id": "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
  "latitude": 7.8901,
  "longitude": -72.5082,
  "speed": 35.5,
  "heading": 180.0
}
```
