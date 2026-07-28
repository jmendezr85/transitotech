# SPEC-003: Módulo de Gestión de Rutas y Paraderos (Routes & Stops)

## 1. Contexto y Objetivos

- **Descripción General:** Módulo responsable de administrar la información geográfica de las rutas de transporte público, sus paraderos asociados en orden secuencial y los datos geoespaciales para renderizado en mapa.
- **Público Objetivo:** Pasajeros (visualización de rutas/paraderos en mapa) y Administradores (creación y edición de trazados).
- **Impacto en la Plataforma:** Proveer los datos de geolocalización procesados con PostGIS para que la App Móvil en Flutter dibuje las líneas de ruta y marcadores sin degradar el rendimiento.

## 2. Requerimientos Funcionales y No Funcionales

### Requerimientos Funcionales (RF)

- [ ] **RF-01:** Permite listar todas las rutas activas de la ciudad.
- [ ] **RF-02:** Permite consultar los detalles de una ruta específica, incluyendo su trazado en formato GeoJSON.
- [ ] **RF-03:** Permite consultar la lista de paraderos ordenados pertenecientes a una ruta (`stop_order`).
- [ ] **RF-04:** Permite a administradores registrar nuevas rutas y paraderos.

### Requerimientos No Funcionales (RNF)

- [ ] **RNF-01 (Rendimiento):** Consultas de rutas y paraderos con respuesta < 100 ms usando índices GiST.
- [ ] **RNF-02 (Estándar Geoespacial):** Representación de trazados en formato estándar GeoJSON (`EPSG:4326`).

## 3. Especificación de Base de Datos y Consultas PostGIS (DBA)

Utiliza las tablas `routes`, `stops` y `route_stops` definidas en `SPEC-001`.

### Consulta SQL Clave: Obtener Ruta con Trazado en GeoJSON

```sql
SELECT
    id,
    code,
    name,
    color_hex,
    ST_AsGeoJSON(path)::json AS path_geojson
FROM routes
WHERE is_active = TRUE AND id = $1;
```
