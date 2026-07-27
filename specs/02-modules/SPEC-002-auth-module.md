# SPEC-002: Módulo de Autenticación y Control de Acceso (Auth)

## 1. Contexto y Objetivos

- **Descripción General:** Módulo encargado de la gestión de identidades, registro de usuarios, inicio de sesión seguro y generación de tokens de autenticación JWT.
- **Público Objetivo:** Pasajeros (App Móvil), Conductores (App Móvil/GPS) y Administradores (Dashboard Web).
- **Impacto en la Plataforma:** Proteger los endpoints del sistema y garantizar autorización basada en roles (RBAC).

## 2. Requerimientos Funcionales y No Funcionales

### Requerimientos Funcionales (RF)

- [ ] **RF-01:** Permite el registro de nuevos usuarios con rol de `passenger`.
- [ ] **RF-02:** Permite el inicio de sesión con correo y contraseña.
- [ ] **RF-03:** Retorna un Token JWT firmado con duración de 24 horas tras un login exitoso.
- [ ] **RF-04:** Restringe accesos según el rol del usuario en la plataforma.

### Requerimientos No Funcionales (RNF)

- [ ] **RNF-01 (Seguridad):** Contraseñas hasheadas obligatoriamente con `bcrypt` (Salt Factor >= 10).
- [ ] **RNF-02 (Rendimiento):** Tiempo de respuesta para autenticación < 200 ms.

## 3. Especificación de Base de Datos (DBA)

Utiliza la tabla `users` definida en `SPEC-001`:

- `id` (UUID, PK)
- `email` (VARCHAR 255, UNIQUE)
- `password_hash` (VARCHAR 255)
- `full_name` (VARCHAR 150)
- `role` (ENUM: 'admin', 'driver', 'passenger')

## 4. Contrato de API (Backend)

### POST `/api/v1/auth/register`

- **Request Body:**

```json
{
  "email": "pasajero@transitotech.com",
  "password": "Password123!",
  "full_name": "Juan Pérez"
}
```
