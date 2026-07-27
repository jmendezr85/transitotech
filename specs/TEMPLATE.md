cat << 'EOF' > specs/TEMPLATE.md

# SPEC-[NÚMERO]: [NOMBRE DE LA FUNCIONALIDAD/MÓDULO]

## 1. Contexto y Objetivos

- **Descripción General:** Brief conciso del problema que resuelve esta especificación.
- **Público Objetivo:** (Administrador Web / Pasajero Móvil / Conductor / Sistema Interno)
- **Impacto en el Negocio/Plataforma:** Beneficio o necesidad técnica que cubre.

## 2. Requerimientos Funcionales y No Funcionales

### Requerimientos Funcionales (RF)

- [ ] **RF-01:** El sistema debe...
- [ ] **RF-02:** El usuario podrá...

### Requerimientos No Funcionales (RNF)

- [ ] **RNF-01 (Rendimiento):** Tiempo de respuesta < X ms.
- [ ] **RNF-02 (Seguridad):** Cifrado / Validación de datos.
- [ ] **RNF-03 (Costo $0):** Ejecución 100% soportalbe en capa gratuita o entorno Docker local.

## 3. Especificación de Base de Datos y Geoespacial (DBA)

- **Tablas afectas / creadas:**
- **Atributos y Tipos de Datos (PostgreSQL + PostGIS):**
- **Índices sugeridos:** (ej: GiST para columnas de tipo `GEOMETRY/GEOGRAPHY`)

## 4. Contrato de API y Comunicación (Backend / WebSockets)

- **Endpoints REST / Canales Realtime:**
  - `METHOD /api/v1/resource`
- **Request Payload (JSON):**
- **Response Payload (JSON):**
- **Códigos de Estado HTTP esperados:**

## 5. Especificación de UI/UX y Flujos (UI/UX Expert)

- **Pantalla(s) involucrada(s):**
- **Estados de Interfaz:** (Cargando, Vacío, Éxito, Error)
- **Componentes clave:** (Listas, Mapas, Botones de acción, Modales)

## 6. Criterios de Aceptación y Definición de Hecho (Definition of Done)

- [ ] La migración de base de datos corre sin errores localmente.
- [ ] Las pruebas unitarias/integración pasan al 100%.
- [ ] La UI respeta el diseño responsivo en Flutter.
- [ ] El código está separado según Clean Architecture en el módulo correspondiente.
      EOF
