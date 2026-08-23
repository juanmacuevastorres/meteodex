## 1. Base modular y contratos

- [x] 1.1 Crear la estructura de modulos de `lib/` para app, core, weather, cities, launchers, settings y widgets, y verificar que `flutter analyze` no reporte errores
- [x] 1.2 Extraer entidades y estados de dominio para ciudad, tiempo actual, previsiones, favoritos, idioma y launcher, y verificar sus pruebas unitarias
- [x] 1.3 Definir la interfaz sustituible de la fuente meteorologica y los estados de carga, exito, datos obsoletos y error, y verificar escenarios con un fake en pruebas
- [x] 1.4 Ejecutar pruebas de widget sobre la pantalla actual y confirmar que el launcher retro conserva su comportamiento visible

## 2. Preferencias y localizacion

- [x] 2.1 Crear el catalogo de claves traducibles para japones, chino, italiano, portugues, castellano, español neutro e ingles, y verificar que no falte ninguna clave
- [x] 2.2 Implementar la seleccion de idioma con fallback a castellano y verificar el cambio sin reiniciar la aplicacion
- [ ] 2.3 Persistir idioma, launcher, ciudad actual y favoritos mediante una interfaz de almacenamiento local, y verificar restauracion tras reinicio

## 3. Launchers visuales

- [ ] 3.1 Extraer el launcher retro actual detras del contrato visual comun, y verificar estados de carga, vacio, exito y error
- [ ] 3.2 Implementar el selector de launchers y conservar ciudad, datos y preferencias al cambiar de estilo, y verificarlo con una prueba de widget
- [ ] 3.3 Definir un catalogo de estilos originales o licenciados y verificar que no se distribuyan assets protegidos sin autorizacion

## 4. Ciudades y tiempo real

- [ ] 4.1 Implementar busqueda y seleccion de ciudades con resultados vacios y errores recuperables, y verificar cada escenario con pruebas
- [ ] 4.2 Añadir deteccion opcional de ubicacion con manejo de permisos denegados y fallback a busqueda manual, y verificarlo con mocks de plataforma
- [ ] 4.3 Evaluar proveedores meteorologicos por cobertura, pueblos, limites, licencia y coste, y entregar una decision documentada antes del adaptador de produccion
- [ ] 4.4 Implementar cache del ultimo resultado valido con timestamp y verificar el comportamiento sin red y con datos obsoletos

## 5. Favoritos

- [ ] 5.1 Implementar guardar, eliminar y seleccionar rapidamente ciudades favoritas, y verificar persistencia entre reinicios
- [ ] 5.2 Integrar favoritos con la pantalla meteorologica y verificar que cambiar de ciudad actualice la consulta y la identificacion visible

## 6. Widgets multiplataforma

- [x] 6.1 Definir el modelo compartido de resumen para widgets y verificar ciudad, temperatura, condicion, timestamp y estado no disponible
- [ ] 6.2 Investigar las restricciones de actualizacion, almacenamiento compartido y localizacion de Android App Widgets y iOS WidgetKit, y entregar una matriz de decisiones
- [ ] 6.3 Implementar el widget Android con datos cacheados y verificar instalacion, actualizacion y estado sin red en un emulador
- [ ] 6.4 Implementar el widget iOS con datos cacheados y verificarlo en un entorno macOS/Xcode compatible

## 7. Integracion y calidad

- [ ] 7.1 Verificar que la app Flutter compile y arranque en Android y que todos los tests pasen
- [ ] 7.2 Verificar la compilacion iOS en macOS/Xcode y documentar cualquier requisito de plataforma
- [ ] 7.3 Ejecutar pruebas de regresion para idioma, launcher, ciudad, favoritos, cache y errores de red, y confirmar que el prototipo retro sigue disponible
