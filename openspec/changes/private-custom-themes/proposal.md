## Why

MeteoDex ya permite elegir launchers, pero los estilos disponibles son parte fija de la aplicación. Queremos que cada usuario pueda importar un tema visual completo y privado, incluyendo sus propios recursos e identidad visual, sin que MeteoDex distribuya personajes, logos o assets de terceros.

## What Changes

- Añadir una sección de `Opciones` para gestionar idioma, unidad de temperatura y temas personalizados.
- Permitir importar paquetes de tema locales en formato `.zip` para Android e iOS.
- Definir un formato de tema que incluya configuración visual, reglas meteorológicas, imágenes estáticas o GIF animados y tipografías opcionales.
- Permitir reglas por condición meteorológica y rango de temperatura, con una regla personalizada opcional para cada combinación.
- Aplicar el tema a toda la experiencia: navegación, fondos, tipografía, iconos, estados, animaciones y pantalla meteorológica.
- Permitir importar cualquier cantidad de temas, activarlos y eliminarlos; conservar el tema anterior si una importación falla.
- Mantener los temas exclusivamente en el dispositivo, sin cuentas, servidor, galería pública ni sincronización.
- Usar la presentación meteorológica normal cuando no exista una regla personalizada compatible.
- Incluir una plantilla genérica descargable o reutilizable sin nombres, personajes ni recursos protegidos de terceros.

## Capabilities

### New Capabilities

- `private-custom-themes`: Importación, validación, almacenamiento local, selección y aplicación de paquetes de temas privados.
- `theme-weather-rules`: Resolución de recursos visuales por condición meteorológica y rango de temperatura, incluyendo estados sin coincidencia.

### Modified Capabilities

- `launcher-themes`: Extender el contrato visual para que un tema importado pueda controlar toda la experiencia sin acoplarse a los datos meteorológicos.
- `localization-preferences`: Añadir la unidad de temperatura y reorganizar el acceso desde la sección de opciones.

## Impact

- Afectará a `lib/launchers`, `lib/settings`, `lib/core/preferences`, `lib/core/localization` y al shell principal de la aplicación.
- Requerirá almacenamiento local de paquetes importados y de la selección activa.
- Requerirá acceso multiplataforma a archivos y extracción segura de ZIP en Android e iOS.
- Requerirá un formato de configuración versionado y validación de rutas, tamaños, formatos y reglas solapadas.
- Añadirá soporte para GIF, PNG/JPG y fuentes TTF/OTF proporcionados por el usuario.
- No añadirá backend, autenticación, publicación de temas, descarga de temas de otros usuarios ni recursos de franquicias.