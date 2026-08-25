## 1. Modelo y contrato de temas

- [x] 1.1 Definir el manifiesto versionado `theme.json`, modelos de tema, recursos, estados visuales y reglas meteorológicas, y verificar con pruebas unitarias los campos obligatorios y valores por defecto.
- [ ] 1.2 Extender el contrato visual común para representar navegación, opciones, clima, carga, error, datos no disponibles y recursos animados, y verificar que el launcher retro actual conserva su comportamiento.
- [x] 1.3 Implementar la resolución determinista por condición, temperatura Celsius, límites y prioridad, y verificar coincidencias, límites abiertos, reglas solapadas y ausencia de coincidencia.

## 2. Importación y seguridad local

- [ ] 2.1 Añadir la abstracción multiplataforma de selección de archivos y extracción local para Android e iOS, y verificar que ambas plataformas pueden entregar un ZIP al dominio sin depender de una URL.
- [ ] 2.2 Implementar validación y extracción atómica del ZIP, incluyendo rutas, tamaño total, número de archivos, formatos, dimensiones, GIFs y fuentes, y verificar rechazo de paquetes dañados, peligrosos o sobredimensionados.
- [ ] 2.3 Implementar el repositorio local de paquetes y recursos importados, y verificar persistencia, restauración, eliminación y recuperación tras una importación fallida.
- [ ] 2.4 Añadir soporte de carga para PNG/JPG/WebP, GIF, TTF y OTF con fuentes de reserva, y verificar renderizado estático y animado en pruebas de recursos.

## 3. Opciones y preferencias

- [ ] 3.1 Reorganizar la pestaña existente como `Opciones` con idioma, unidad de temperatura, launchers integrados y temas importados, y verificar navegación y textos traducidos en todos los idiomas soportados.
- [ ] 3.2 Añadir selección persistente Celsius/Fahrenheit manteniendo Celsius como valor inicial, y verificar conversión visible sin alterar la temperatura Celsius usada por las reglas.
- [ ] 3.3 Añadir importar, activar y eliminar temas con confirmación y fallback al launcher retro si se elimina el tema activo, y verificar que ciudades, favoritos, idioma y clima no se pierden.

## 4. Aplicación visual completa

- [ ] 4.1 Integrar el tema activo con AppBar, pestañas, fondos, tarjetas, textos, iconos, tipografías, animaciones y estados de la aplicación, y verificar que una selección cambia toda la experiencia sin modificar datos meteorológicos.
- [ ] 4.2 Integrar las reglas meteorológicas en la pantalla de tiempo para condiciones soleado, nublado, lluvia, nieve, trueno y desconocida, y verificar el fallback visual normal cuando no hay coincidencia.
- [ ] 4.3 Crear y documentar una plantilla genérica ZIP con ejemplos neutrales, y verificar que no contiene nombres, personajes, logos o recursos de terceros.

## 5. Verificación multiplataforma

- [ ] 5.1 Añadir pruebas de widget y de integración para importar, seleccionar, restaurar y eliminar varios temas, y verificar que una importación inválida conserva el tema activo.
- [ ] 5.2 Ejecutar `flutter analyze` y toda la suite de pruebas, y verificar que no aparecen errores nuevos.
- [ ] 5.3 Validar en Android e iOS la selección de archivos, permisos, extracción, GIF animado, fuentes, memoria y cambio de tema, y entregar una matriz de compatibilidad con los límites medidos.