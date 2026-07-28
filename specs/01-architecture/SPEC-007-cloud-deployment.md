# SPEC-007: Arquitectura de Despliegue Cloud y CI/CD ($0 Presupuesto)

## 1. Contexto y Objetivos

- **Descripción General:** Definición de la infraestructura de producción cloud, variables de entorno y pipeline de despliegue continuo (CI/CD) para TransitoTech utilizando exclusivamente herramientas de capa gratuita.
- **Impacto en la Plataforma:** Garantizar un entorno de producción accesible públicamente vía HTTPS y WSS (WebSockets Seguros) con soporte para PostGIS sin costos operativos iniciales.

## 2. Mapa de Infraestructura Cloud ($0/mes)

```text
               +----------------------------------+
               |  App Flutter (Web / Android)     |
               +----------------------------------+
                                |
                   HTTPS / WSS  |  (CORS Habilitado)
                                v
               +----------------------------------+
               | Render / Railway (Web Service)   |
               | - Node.js Express API            |
               | - Socket.io Gateway              |
               +----------------------------------+
                                |
               PostgreSQL Connection Pooler (SSL)
                                v
               +----------------------------------+
               | Supabase (Free Tier Database)    |
               | - PostgreSQL 15+ con PostGIS     |
               | - SSL Activado / Pooling PgBouncer|
               +----------------------------------+
```
