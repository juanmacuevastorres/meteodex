## Context

La aplicacion actual es un prototipo Flutter concentrado en `lib/main.dart`, con estados meteorologicos simulados, un launcher retro y preferencias locales para idioma. El producto debe crecer hacia Android e iOS, consultar una fuente meteorologica externa, conservar ciudades y ofrecer temas visuales intercambiables.

## Goals / Non-Goals

**Goals:**

- Separar presentacion, dominio y acceso a datos para que proveedores y launchers puedan cambiarse sin reescribir la aplicacion.
- Definir modelos estables para ciudades, tiempo, previsiones, favoritos, idiomas y launchers.
- Mantener las preferencias locales disponibles sin cuenta durante la primera fase.
- Preparar una frontera clara para integraciones nativas de widgets.
- Permitir pruebas de dominio sin depender de red, GPS o plataforma.

**Non-Goals:**

- Implementar en este cambio un backend propio, autenticacion o sincronizacion entre dispositivos.
- Elegir definitivamente un proveedor meteorologico antes de evaluar cobertura, limites, licencia y coste.
- Distribuir assets, logos o personajes de marcas de terceros sin licencia.
- Implementar los widgets nativos completos en la primera iteracion.

## Decisions

- **Arquitectura por funcionalidades:** organizar `lib/` por `weather`, `cities`, `launchers`, `settings` y `widgets`, con `core` para localizacion, almacenamiento y contratos compartidos. Esto reduce el acoplamiento del prototipo actual.
- **Contratos de dominio primero:** definir entidades y estados de carga, exito, datos obsoletos y error antes de integrar una API. Alternativas descartadas: acoplar widgets y pantallas directamente a respuestas JSON del proveedor.
- **Repositorio de datos sustituible:** usar una interfaz de fuente meteorologica y adaptadores concretos. La primera implementacion podra usar una API publica, pero una futura API propia no cambiara la UI.
- **Preferencias locales inicialmente:** guardar idioma, launcher, ciudad actual y favoritos en almacenamiento local. Una base de datos completa queda pospuesta porque el volumen inicial es pequeño y no hay cuentas.
- **Localizacion basada en claves:** todos los textos visibles tendran claves traducibles; castellano sera el fallback. Castellano y español neutro seran variantes distintas para permitir vocabulario especifico.
- **Launcher como configuracion visual:** un launcher describira colores, tipografias, iconografia y composicion, mientras los datos meteorologicos permanecen neutrales. Los estilos de marcas se sustituiran por estilos originales o licenciados.
- **Widgets como frontera de plataforma:** la app compartira modelos y datos, pero Android e iOS tendran adaptadores nativos separados por sus APIs de widgets y restricciones de refresco.

## Risks / Trade-offs

- [API publica limitada o con coste] -> Mantener el proveedor detras de un adaptador y evaluar limites, licencia, cobertura y cache antes de publicar.
- [Permisos de ubicacion rechazados] -> Ofrecer busqueda manual siempre y no bloquear el uso principal.
- [Datos meteorologicos obsoletos] -> Mostrar timestamp, estado de frescura y ultimo dato valido cuando exista.
- [Multiples launchers aumentan la superficie de pruebas] -> Exigir un contrato comun y pruebas visuales por estados antes de añadir cada launcher.
- [Widgets tienen ciclos de actualizacion diferentes] -> Diseñar el resumen para tolerar datos stale y validar Android e iOS por separado.
- [Contenido de terceros protegido] -> Usar nombres y recursos originales o disponer de licencia antes de publicar estilos inspirados en marcas.
- [Cambiar de prototipo monolitico a modulos puede romper el flujo actual] -> Migrar por etapas conservando primero el launcher retro y las pruebas existentes.

## Migration Plan

1. Congelar el comportamiento actual con pruebas de widget y de dominio.
2. Extraer modelos, contratos y preferencias sin cambiar la apariencia inicial.
3. Mover la pantalla actual al modulo de launcher retro.
4. Añadir busqueda, fuente meteorologica y cache mediante adaptadores.
5. Añadir idiomas y launchers adicionales con pruebas por estado.
6. Integrar widgets nativos despues de estabilizar el contrato compartido.
7. Para rollback, conservar el launcher retro y el adaptador de datos anterior como implementacion por defecto hasta completar cada etapa.

## Open Questions

- Que proveedor meteorologico ofrece mejor cobertura para pueblos, limites de uso y licencia comercial?
- Se necesitara cuenta para sincronizar favoritos entre Android e iOS o bastara el almacenamiento local en el MVP?
- Que datos y frecuencia de actualizacion seran aceptables para los widgets sin disparar consumo de bateria?
