cat << 'EOF' > specs/00-architecture/SPEC-000-global-architecture.md

# SPEC-000: Arquitectura Global y Estrategia de Infraestructura $0

## 1. Contexto y Objetivos

- **Descripción General:** Especificación maestra de la arquitectura de la plataforma TransitoTech (Dashboard Web Admin + App Móvil de Pasajeros).
- **Público Objetivo:** Equipo de Ingeniería, Sistemas Externos (GPS de buses/drivers), Usuarios Móviles y Administradores de Flotas.
- **Impacto en la Plataforma:** Definir un Monolito Modular con Clean Architecture preparado para escalar a microservicios sin reescritura.

## 2. Visión General de Arquitectura (C4 Model - Nivel 2: Contenedores)

```text
[ App Móvil Pasajeros ]     [ Dashboard Web Admin ]
        (Flutter)                  (Flutter Web)
            │                            │
            │ HTTPS / WSS                │ HTTPS
            ▼                            ▼
┌─────────────────────────────────────────────────────────┐
│                      API GATEWAY                        │
│                 (Express / Fastify Proxy)               │
└───────────────────────────┬─────────────────────────────┘
                            │ Routing Interno
                            ▼
┌─────────────────────────────────────────────────────────┐
│              BACKEND MONOLITO MODULAR                   │
│                    (Node.js / TS)                       │
│                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────┐  │
│  │ Module: Auth │  │ Module: Routes│  │Module:Tracking│  │
│  └──────────────┘  └──────────────┘  └───────────────┘  │
│  ┌──────────────┐  ┌──────────────┐                     │
│  │Module: Buses │  │Module: Rating│                     │
│  └──────────────┘  └──────────────┘                     │
└──────────────┬────────────────────────────┬─────────────┘
               │                            │
               │ SQL Queries                │ Events / PubSub
               ▼                            ▼
┌─────────────────────────────┐   ┌───────────────────────┐
│    PostgreSQL + PostGIS     │   │   Supabase Realtime   │
│   (Persistencia y Geos)     │   │ (WebSockets Tracking) │
└─────────────────────────────┘   └───────────────────────┘
```
