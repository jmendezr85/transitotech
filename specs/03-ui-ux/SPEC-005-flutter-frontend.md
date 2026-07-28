# SPEC-005: Especificación de UI/UX y Arquitectura Frontend (Flutter)

## 1. Contexto y Objetivos

- **Descripción General:** Definición de la experiencia de usuario (UI/UX), diseño de pantallas, componentes del mapa interactivo y arquitectura del cliente cliente en Flutter.
- **Público Objetivo:** Pasajeros en movilidad urbana (App Móvil Android/iOS) y Operadores/Administradores de flota (Dashboard Web).
- **Impacto en la Plataforma:** Ofrecer una interfaz fluida a 60 fps con renderizado vectorial de mapas, bajo consumo de batería y experiencia sin latencia percibida al seguir buses en movimiento.

## 2. Guía de Estilos y Tokens de Diseño (UI/UX)

- **Paleta de Colores:**
  - `Primary (Azul Tránsito)`: `#1E88E5` (Alta visibilidad en pantalla bajo sol directo).
  - `Secondary (Verde Bus Online)`: `#4CAF50` (Indicador de unidades activas).
  - `Background Light`: `#F8F9FA`
  - `Surface / Cards`: `#FFFFFF`
  - `Text Primary`: `#212121`
- **Tipografía:** Roboto / Inter (Sans-serif limpia de alta legibilidad en pantallas pequeñas).
- **Iconografía:** Material Symbols (Iconos de buses, paraderos, GPS y marcadores).

## 3. Arquitectura Frontend en Flutter

Utilizaremos una arquitectura por capas desacopladas con gestión de estado mediante **Flutter Bloc** o **Provider/Riverpod**:

```text
lib/
├── config/              # Temas, constantes globales, rutas GoRouter
├── core/                # Cliente HTTP (Dio), Cliente WebSockets, Storage
├── features/
│   ├── auth/            # Login, Registro, Guardado de Token
│   ├── map/             # Renderizado de MapLibre / Flutter Map, GPS
│   └── routes/          # Lista de rutas, detalles de paraderos
└── main.dart
```
