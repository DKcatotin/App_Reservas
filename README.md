# 📅 Agenda App (Owner) – Flutter

Aplicación móvil de **reservas** enfocada en el rol **Owner / Propietario**.  
Permite **autenticación** y **gestión completa de citas**: crear, listar, filtrar y editar citas, incluyendo la **selección de servicios**.

El proyecto está organizado con **Clean Architecture pragmática**, separando responsabilidades en **domain**, **data** y **presentation**, usando:

- **BLoC** → solo para **Auth**
- **Riverpod** → para el resto de features

Este README describe la **estructura real del repositorio** y cómo ejecutarlo **sin romper el comportamiento actual**.

---

## 🚀 Funcionalidades principales (Owner)

- Login / Autenticación
- Crear citas (con selección de servicios)
- Listar y filtrar citas
- Editar citas (incluyendo servicios)
- Logout

---

## 🛠️ Tecnologías

- Flutter
- Riverpod (features)
- BLoC (auth)
- Backend: NestJS (API REST)

> El backend se configura mediante el `baseUrl` en  
> `lib/core/config/env.dart`

---

## 📁 Estructura del proyecto (`/lib`)


lib/
 ├── app.dart
 ├── main.dart
 ├── core/
 │   ├── api/                 # ApiClient
 │   ├── config/              # Env (baseUrl, timeouts)
 │   ├── di/                  # Inyección de dependencias
 │   ├── errors/              # Exceptions y Failures
 │   ├── logger/              # AppLogger
 │   ├── networking/          # Dio, interceptores, endpoints
 │   ├── routing/             # GoRouter
 │   ├── storage/             # TokenStorage (SharedPreferences)
 │   ├── theme/               # AppTheme
 │
 ├── features/
 │   ├── auth/
 │   │   ├── data/
 │   │   ├── domain/
 │   │   └── presentation/
 │   │       └── bloc/
 │   │
 │   └── owner/
 │       ├── appointments/
 │       │   ├── data/
 │       │   ├── domain/
 │       │   └── presentation/
 │       │
 │       ├── catalogues/
 │       │   ├── data/
 │       │   ├── domain/
 │       │   └── presentation/
 │       │
 │       ├── branches/
 │       │   ├── data/
 │       │   └── domain/
 │       │
 │       └── presentation/
 │
 └── deprecated/


## 🧱 Arquitectura (Capas)

### Domain
- `entities`
- `repositories`
- `use_cases`
- ❌ No importa Flutter, Dio ni JSON

### Data
- `models`
- `mappers`
- `datasources`
- `repository implementations`
- ❌ No contiene lógica de UI

### Presentation
- `pages`
- `widgets`
- `providers`
- `bloc`
- ❌ No crea infraestructura (Dio, ApiClient, etc.)

---

## 🔁 Flujo de datos

UI (pages / widgets)
↓
Providers (Riverpod) / BLoC (Auth)
↓
Use Cases
↓
Repositories
↓
Datasources
↓
DioClient / ApiClient
↓
API (NestJS)


---

## 🔌 Conectividad e Inyección de Dependencias

- **Dio + TokenStorage**
  - Se inicializan una sola vez en `main.dart`
  - Acceso mediante `DioClient.instance`

- **AuthInterceptor**
  - Agrega el token automáticamente
  - Maneja refresh y reintento
  - Archivo: `lib/core/networking/auth_interceptor.dart`

- **Inyección de dependencias**
  - `lib/core/di/app_dependencies.dart`
  - `lib/core/di/core_di.dart`

- **Providers centralizados (Riverpod)**
  - `lib/core/di/riverpod_providers.dart`

---

## ⚙️ Configuración y ejecución

### Requisitos
- Flutter SDK
- Emulador o dispositivo físico

### Instalación
```bash
flutter pub get
Ejecutar la app
flutter run
Análisis estático
flutter analyze
🌐 Configurar API (baseUrl)
Archivo:

lib/core/config/env.dart
Ejemplo:

class Env {static const baseUrl = 'http://localhost:3000'; }

🧾 Variables importantes
baseUrl → lib/core/config/env.dart

Tokens → lib/core/storage/token_storage.dart

Interceptor auth → lib/core/networking/auth_interceptor.dart

📦 Ejemplos de JSON (modelos reales)
Service (Catálogo)
Archivo: lib/features/owner/catalogues/data/models/service.dart

{
  "id": "uuid",
  "branchId": "uuid",
  "categoryId": "uuid",
  "name": "Manicure",
  "description": "Servicio básico",
  "durationMin": 60,
  "basePrice": "18.00",
  "enabled": true
}
AppointmentService (Servicio dentro de una cita)
Archivo: lib/features/owner/appointments/data/models/appointment_service.dart

{
  "id": "uuid",
  "appointmentId": "uuid",
  "serviceId": "uuid",
  "durationMin": 60,
  "price": "18.00",
  "service": {
    "id": "uuid",
    "name": "Pedicure",
    "branchId": "uuid",
    "categoryId": "uuid",
    "description": "...",
    "durationMin": 60,
    "basePrice": "18.00",
    "enabled": true
  }
}
📐 Convenciones del código
Textos de UI en español

Comentarios en español

Clases y métodos en inglés

Nuevos features:

Replicar domain / data / presentation

Registrar providers en lib/core/di/riverpod_providers.dart

✅ Reglas para cambios seguros
❌ No cambiar endpoints, payloads ni navegación

✅ Cambios pequeños e incrementales

✅ Ejecutar flutter analyze

Checklist mínimo
Login

Listar citas

Crear cita

Editar cita

Logout

🐞 Debug y troubleshooting
Logs: lib/core/logger/app_logger.dart

Problemas comunes
Listas vacías → revisar page / limit

Token expirado → manejado por AuthInterceptor

Fecha pasada → validar en UI


