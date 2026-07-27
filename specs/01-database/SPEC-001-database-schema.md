# SPEC-001: Esquema de Base de Datos y Consultas Geoespaciales (PostGIS)

## 1. Contexto y Objetivos

- **Descripción General:** Definición formal de las tablas relacionales, columnas geoespaciales y funciones relativas a la gestión de rutas, paraderos, flotas y coordenadas en tiempo real.
- **Público Objetivo:** Especialista en BD, Desarrolladores Backend, Sistema de Integración GPS.
- **Impacto en la Plataforma:** Garantizar consultas espaciales con latencias menores a 50 ms sobre miles de puntos GPS.

## 2. Diagrama Entidad-Relación Simplificado (ERD)

```text
  ┌──────────────┐         ┌──────────────┐         ┌────────────────┐
  │   users      │ 1────N  │    buses     │ N────1  │     routes     │
  │ (Drivers/Adm)│         │ (Vehículos)  │         │ (Rutas urbanas)│
  └──────────────┘         └──────────────┘         └───────┬────────┘
                                                            │ 1
                                                            │
                                                            │ N
                                                    ┌───────┴────────┐
                                                    │  route_stops   │
                                                    │  (Paraderos)   │
                                                    └────────────────┘
```
