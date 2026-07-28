# SPEC-006: Módulo de Calificaciones y Feedback de Servicio (Ratings)

## 1. Contexto y Objetivos

- **Descripción General:** Módulo encargado de recibir, almacenar y procesar las valoraciones y comentarios enviados por los pasajeros sobre las rutas, buses y conductores.
- **Público Objetivo:** Pasajeros (App Móvil) y Administradores/Operadores (Dashboard Web).
- **Impacto en la Plataforma:** Medir la calidad del servicio, detectar rutas/unidades con incidencias y proveer métricas para la toma de decisiones.

## 2. Requerimientos Funcionales y No Funcionales

### Requerimientos Funcionales (RF)

- [ ] **RF-01:** Permite a los usuarios autenticados enviar una calificación (1 a 5 estrellas) con un comentario opcional para un bus/ruta específica.
- [ ] **RF-02:** Calcula el promedio de calificación actualizado de un bus y de una ruta.
- [ ] **RF-03:** Permite a los usuarios consultar su historial de calificaciones enviadas.
- [ ] **RF-04:** Permite a los administradores listar las valoraciones con filtros por bus, ruta o rango de fechas.

### Requerimientos No Funcionales (RNF)

- [ ] **RNF-01 (Seguridad):** Endpoints protegidos por Middleware JWT (`authenticate.ts`). Solo pasajeros autenticados pueden calificar.
- [ ] **RNF-02 (Integridad):** Restricción de base de datos (`CHECK rating BETWEEN 1 AND 5`).

## 3. Especificación de Base de Datos y Tabla SQL (DBA)

### Tabla `ratings`

```sql
CREATE TABLE IF NOT EXISTS ratings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    bus_id UUID NOT NULL REFERENCES buses(id) ON DELETE CASCADE,
    route_id UUID NOT NULL REFERENCES routes(id) ON DELETE CASCADE,
    score INT NOT NULL CHECK (score >= 1 AND score <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_ratings_bus ON ratings(bus_id);
CREATE INDEX IF NOT EXISTS idx_ratings_route ON ratings(route_id);
```
