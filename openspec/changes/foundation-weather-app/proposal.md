## Why

MeteoDex necesita pasar de un prototipo visual con datos simulados a una base de producto capaz de ofrecer tiempo real, personalización visual y una experiencia coherente en Android e iOS. Definir ahora una arquitectura modular evita que la integración futura de ciudades, proveedores meteorológicos, idiomas, favoritos y widgets quede acoplada a una sola pantalla.

## What Changes

- Separar la aplicación actual en módulos de aplicación, localización, preferencias, temas y funcionalidades meteorológicas.
- Definir un sistema de launchers visuales intercambiables, empezando por el launcher retro actual y dejando preparada la incorporación de nuevos estilos.
- Ampliar la localización a japonés, chino, italiano, portugués, castellano, español neutro e inglés.
- Preparar un flujo de selección de ciudad actual y búsqueda manual de otras ciudades.
- Definir el contrato de datos para tiempo actual y previsión, inicialmente desacoplado de cualquier proveedor concreto.
- Persistir idioma, launcher y ciudades favoritas localmente.
- Mantener una base compatible con Android e iOS y reservar una integración específica para widgets de cada plataforma.
- Documentar los límites legales de launchers inspirados en marcas y permitir una estrategia basada en estilos originales o contenido con licencia.

## Capabilities

### New Capabilities

- `weather-foundation`: Modelo y flujo base para ubicación, ciudades, tiempo actual y previsión.
- `launcher-themes`: Sistema de launchers visuales seleccionables y extensibles.
- `localization-preferences`: Idiomas disponibles y persistencia de preferencias del usuario.
- `favorite-cities`: Selección, guardado y acceso rápido a ciudades favoritas.
- `platform-widgets`: Contrato y preparación de widgets Android/iOS.

### Modified Capabilities

Ninguna. El proyecto no tiene especificaciones funcionales existentes.

## Impact

- Afecta principalmente a `lib/` y a la organización de la aplicación Flutter.
- Añadirá contratos internos para fuentes meteorológicas, localización, temas y almacenamiento local.
- Podrá añadir dependencias Flutter para red, geolocalización, preferencias y pruebas.
- Requerirá integración nativa Android/iOS para widgets en una fase posterior.
- La publicación de estilos basados en Pokémon, Dragon Ball, Naruto o Casio requerirá licencias; la primera implementación debe usar estilos originales o recursos autorizados.
