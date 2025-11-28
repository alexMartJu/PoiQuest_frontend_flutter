# 🎯 PoiQuest - Frontend Flutter

**PoiQuest** es una aplicación móvil desarrollada en Flutter que permite a los usuarios explorar, descubrir y gestionar eventos culturales y de interés. La aplicación ofrece funcionalidades de autenticación, navegación por categorías de eventos, gestión de perfil de usuario y un panel de administración para usuarios con permisos especiales.

---

## 📋 Tabla de Contenidos

- [Objetivo](#-objetivo)
- [Características Principales](#-características-principales)
- [Requisitos Previos](#-requisitos-previos)
- [Instalación y Configuración](#-instalación-y-configuración)
- [Cómo Ejecutar la Aplicación](#-cómo-ejecutar-la-aplicación)
- [Endpoints del Backend](#-endpoints-del-backend)
- [Persistencia Local](#-persistencia-local)
- [Arquitectura del Proyecto](#-arquitectura-del-proyecto)
- [Tecnologías Utilizadas](#-tecnologías-utilizadas)
- [Contribuciones](#-contribuciones)
- [Licencia](#-licencia)

---

## 🎯 Objetivo

El objetivo de **PoiQuest** es proporcionar una plataforma móvil intuitiva y moderna para:

- **Usuarios estándar**: Explorar eventos culturales, buscar por categorías, gestionar su perfil y participar en eventos de su interés.
- **Administradores**: Crear, editar y eliminar eventos, así como gestionar categorías y contenido de la plataforma.
- **Experiencia de usuario**: Ofrecer una interfaz fluida con soporte multiidioma (español/inglés), tema claro/oscuro y navegación intuitiva.

---

## ✨ Características Principales

### 🔐 Autenticación y Autorización
- Registro de usuarios con información de perfil (nombre, apellidos, email, avatar, biografía)
- Login con email y contraseña
- Gestión de tokens JWT (access token y refresh token)
- Logout individual o en todos los dispositivos
- Protección de rutas según permisos de usuario

### 🎭 Exploración de Eventos
- Navegación por categorías de eventos
- Visualización de eventos con paginación infinita
- Vista detallada de cada evento con imágenes, descripción, ubicación y fechas
- Sistema de búsqueda y filtrado

### 👤 Gestión de Perfil
- Visualización y edición de información personal
- Cambio de avatar
- Actualización de biografía
- Cambio de contraseña seguro

### 🛠️ Panel de Administración
- Gestión completa de eventos (crear, editar, eliminar)
- Asignación de categorías a eventos
- Gestión de imágenes de eventos
- Vista de eventos activos con paginación

### 🌐 Funcionalidades Adicionales
- **Internacionalización (i18n)**: Soporte para español e inglés
- **Temas**: Modo claro y modo oscuro
- **Persistencia**: Preferencias del usuario guardadas localmente
- **Caché de imágenes**: Optimización de carga de imágenes con `cached_network_image`
- **Navegación declarativa**: Implementada con `go_router`
- **Gestión de estado**: Utilizando `Riverpod`

---

## 📦 Requisitos Previos

Antes de ejecutar la aplicación, asegúrate de tener instalado:

- **Flutter SDK**: versión 3.9.2 o superior
  - Descargar desde: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- **Dart SDK**: versión 3.9.2 o superior (incluido con Flutter)
- **Android Studio** o **VS Code** con extensiones de Flutter/Dart
- **Emulador Android** o **dispositivo físico** (Android/iOS)
- **Backend de PoiQuest**: El backend debe estar ejecutándose (por defecto en `http://localhost:8000`)

### Verificar instalación de Flutter:

```bash
flutter doctor
```

Este comando verificará que todas las dependencias necesarias estén correctamente instaladas.

---

## 🔧 Instalación y Configuración

### 1. Clonar el repositorio

```bash
git clone https://github.com/alexMartJu/PoiQuest_frontend_flutter.git
cd PoiQuest_frontend_flutter
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar la URL del backend

La aplicación utiliza variables de entorno para configurar la URL del backend. Por defecto:

- **Web**: `http://localhost:8000`
- **Android Emulator**: `http://10.0.2.2:8000`
- **iOS Simulator**: `http://localhost:8000`

Para personalizar la URL del backend, usa el parámetro `--dart-define`:

```bash
# Ejemplo para desarrollo local
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000

# Ejemplo para Android Emulator
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:8000

# Ejemplo para producción
flutter build apk --dart-define=API_BASE_URL=https://tu-dominio.com
```

---

## 🚀 Cómo Ejecutar la Aplicación

### Modo Debug (Desarrollo)

#### Opción 1: Ejecución por defecto

```bash
flutter run
```

Esto ejecutará la app con las URLs por defecto según la plataforma.

#### Opción 2: Con URL personalizada del backend

```bash
# Para web o iOS (localhost)
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000

# Para Android Emulator (necesita 10.0.2.2)
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:8000

# Para Android Genymotion
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.3.2:8000
```

#### Opción 3: Seleccionar dispositivo específico

```bash
# Listar dispositivos disponibles
flutter devices

# Ejecutar en un dispositivo específico
flutter run -d <device-id>
```

### Hot Reload durante el desarrollo

Durante el desarrollo puedes usar Hot Reload para aplicar cambios en la UI sin reiniciar completamente la aplicación:

- En la terminal donde ejecutaste `flutter run`, presiona `r` para Hot Reload (presiona `R` para Hot Restart).
- En Android Studio o VS Code, guarda el archivo (`Ctrl+S` / `Cmd+S`) para que el IDE aplique Hot Reload automáticamente.
- Hot Reload suele preservar el estado de la app; si necesitas reiniciar el estado, usa Hot Restart.

## 🌐 Endpoints del Backend

La aplicación consume los siguientes endpoints del backend:

### Autenticación (`/auth/`)

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/auth/register-standard-user` | Registrar nuevo usuario estándar |
| POST | `/auth/login` | Iniciar sesión (devuelve access y refresh token) |
| POST | `/auth/logout` | Cerrar sesión (invalida refresh token) |
| POST | `/auth/logout-all` | Cerrar sesión en todos los dispositivos |
| POST | `/auth/refresh` | Refrescar access token usando refresh token |
| GET | `/auth/me` | Obtener información del usuario autenticado |
| POST | `/auth/change-password` | Cambiar contraseña del usuario |

### Categorías de Eventos

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/event-categories` | Obtener todas las categorías de eventos |

### Eventos (`/events/`)

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/events` | Obtener listado de eventos |
| GET | `/events/category/{categoryUuid}` | Obtener eventos por categoría específica |
| POST | `/events` | Crear nuevo evento (admin) |
| GET | `/events/{uuid}` | Obtener detalle de un evento específico |
| PATCH | `/events/{uuid}` | Actualizar evento existente (admin) |
| DELETE | `/events/{uuid}` | Eliminar evento (admin) |

### Perfil (`/profile/`)

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/profile/me` | Obtener perfil del usuario autenticado |
| PATCH | `/profile/me` | Actualizar información del perfil |
| PUT | `/profile/me/avatar` | Actualizar avatar del usuario |

**Headers requeridos:**
- `Authorization: Bearer <access_token>` (para endpoints autenticados)
- `Content-Type: application/json`

**Configuración de timeouts:**
- Connection timeout: 10 segundos
- Receive timeout: 10 segundos
## 💾 Persistencia Local

La aplicación utiliza varios mecanismos de persistencia local:

### 1. **Flutter Secure Storage** (`flutter_secure_storage`)

**Qué se persiste:**
- ✅ **Access Token**: Token JWT para autenticación en el backend
- ✅ **Refresh Token**: Token para renovar el access token cuando expire

**Ubicación:**
- Android: EncryptedSharedPreferences (almacenamiento encriptado)
- iOS: Keychain (almacenamiento seguro del sistema)

**Características:**
- Almacenamiento seguro y encriptado
- Los tokens persisten incluso después de cerrar la app
- Se borran solo al hacer logout

### 2. **Shared Preferences** (`shared_preferences`)

**Qué se persiste:**
- ✅ **Modo oscuro/claro** (`darkmode`): `bool`
- ✅ **Idioma preferido** (`language`): `String` ('es' o 'en')
- ✅ **Notificaciones activas** (`notifications`): `bool`

**Ubicación:**
- Android: SharedPreferences (archivo XML en `/data/data/<package>/shared_prefs/`)
- iOS: NSUserDefaults (plist en Library/Preferences/)

**Características:**
- Almacenamiento simple de pares clave-valor
- Persiste las preferencias del usuario
- Se mantiene entre sesiones de la app

### 3. **Caché de Imágenes** (`cached_network_image`)

**Qué se persiste:**
- ✅ **Imágenes de eventos**: URLs de imágenes descargadas
- ✅ **Avatares de usuario**: Fotos de perfil

**Ubicación:**
- Android: `/data/data/<package>/cache/`
- iOS: `Library/Caches/`

**Características:**
- Caché automático de imágenes de red
- Reduce consumo de datos y mejora rendimiento
- Se puede limpiar manualmente desde configuración del dispositivo

### Ejemplo de uso:

```dart
// Guardar token de acceso
await FlutterSecureStorage().write(key: 'access_token', value: token);

// Leer preferencias
final prefs = await SharedPreferences.getInstance();
final isDarkMode = prefs.getBool('darkmode') ?? false;

// Cargar imagen con caché
CachedNetworkImage(imageUrl: event.imageUrls.first)
```

---

## 🏗️ Arquitectura del Proyecto

El proyecto sigue una arquitectura **Clean Architecture** con separación de responsabilidades:

```
lib/
├── app/                          # Configuración de la aplicación
│   ├── router.dart              # Configuración de rutas con go_router
│   └── theme/                   # Temas (claro/oscuro)
│
├── core/                        # Código compartido
│   ├── l10n/                    # Internacionalización (es/en)
│   ├── utils/                   # Utilidades (env, constants, services)
│   └── widgets/                 # Widgets reutilizables
│
├── features/                    # Características por módulo
│   ├── auth/                    # Autenticación
│   │   ├── data/               # Data sources, repositories, models
│   │   ├── domain/             # Entities, repositories (interfaces)
│   │   └── presentation/       # UI, providers, pages
│   │
│   ├── events/                  # Eventos
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── profile/                 # Perfil de usuario
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── admin/                   # Panel de administración
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── preferences/             # Preferencias de usuario
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── tickets/                 # Gestión de tickets (futuro)
│   └── scan/                    # Escaneo QR (futuro)
│
└── main.dart                    # Punto de entrada de la aplicación
```

### Capas de la arquitectura:

- **Presentation**: UI, widgets, providers (Riverpod)
- **Domain**: Entidades de negocio, interfaces de repositorios
- **Data**: Implementación de repositorios, data sources, modelos

---

## 🛠️ Tecnologías Utilizadas

### Framework y Lenguaje
- **Flutter**: ^3.9.2
- **Dart**: ^3.9.2

### Gestión de Estado
- **flutter_riverpod**: ^3.0.3 - Gestión de estado reactiva

### Navegación
- **go_router**: ^16.2.4 - Navegación declarativa

### Networking
- **dio**: ^5.7.0 - Cliente HTTP

### Almacenamiento Local
- **shared_preferences**: ^2.5.3 - Persistencia de preferencias
- **flutter_secure_storage**: ^9.2.2 - Almacenamiento seguro de tokens

### UI y UX
- **cached_network_image**: ^3.2.3 - Caché de imágenes
- **cupertino_icons**: ^1.0.8 - Iconos de iOS

### Internacionalización
- **intl**: ^0.20.2 - Formateo de fechas y números
- **flutter_localizations**: SDK - Localizaciones de Flutter

### Utilidades
- **equatable**: ^2.0.7 - Comparación de objetos

### Desarrollo
- **flutter_lints**: ^5.0.0 - Reglas de linting
- **custom_lint**: ^0.8.0 - Linting personalizado
- **riverpod_lint**: ^3.0.3 - Linting específico para Riverpod

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Para contribuir:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

---

## 📄 Licencia

Este proyecto está bajo una licencia personalizada. Consulta el archivo [LICENSE](LICENSE) para más detalles.

---

## 👨‍💻 Autor

**Alex Martínez**
- GitHub: [@alexMartJu](https://github.com/alexMartJu)
- Repositorio: [PoiQuest_frontend_flutter](https://github.com/alexMartJu/PoiQuest_frontend_flutter)

---

## 📞 Soporte

Si encuentras algún problema o tienes preguntas:

1. Revisa la sección de [Issues](https://github.com/alexMartJu/PoiQuest_frontend_flutter/issues)
2. Crea un nuevo issue si tu problema no está documentado
3. Proporciona detalles sobre tu entorno (versión de Flutter, dispositivo, etc.)

---

**¡Gracias por usar PoiQuest! 🎉**