## Context

La aplicación tiene un catálogo de launchers incorporado, preferencias locales y una pantalla principal concentrada en Flutter. Los datos meteorológicos usan condiciones y temperaturas neutrales, por lo que el tema debe actuar como una capa de presentación y no modificar el dominio.

## Goals / Non-Goals

**Goals:**

- Definir un paquete portable y versionado para temas completos.
- Mantener los recursos privados, locales y utilizables sin cuenta.
- Dar el mismo comportamiento funcional en Android e iOS.
- Hacer que la resolución de reglas sea determinista y segura.
- Permitir que un fallo de importación o de una regla no inutilice la aplicación.

**Non-Goals:**

- Crear una galería, marketplace, sincronización o compartición de temas.
- Descargar recursos desde URLs incluidas en un tema.
- Ejecutar código, scripts o plugins contenidos en un paquete.
- Distribuir recursos, nombres o marcas de terceros dentro de la aplicación.

## Decisions

- **Paquete ZIP con manifiesto:** cada tema será un ZIP con un `theme.json` en la raíz y directorios de recursos. Se elige ZIP frente a archivos sueltos porque permite transportar configuración, GIFs, imágenes y fuentes como una unidad portable.
- **Manifiesto versionado:** `theme.json` incluirá una versión de formato, identidad del tema, configuración global, recursos y reglas meteorológicas. Versionar el formato permite rechazar o migrar paquetes futuros sin romper los temas existentes.
- **Recursos referenciados localmente:** las rutas del manifiesto solo podrán apuntar a archivos dentro del ZIP, sin `..`, URLs ni rutas absolutas. La extracción se hará en un directorio privado de la aplicación.
- **Formatos multiplataforma acotados:** PNG/JPG/WebP cubrirán imágenes estáticas, GIF cubrirá animación y TTF/OTF cubrirán fuentes. La primera versión evitará formatos con soporte desigual o decodificación nativa específica.
- **Reglas explícitas por condición y Celsius:** las reglas se evaluarán sobre la temperatura Celsius del modelo meteorológico; la unidad elegida por el usuario solo cambia la presentación. Cada regla tendrá condición, límites opcionales, recurso y prioridad opcional. Sin coincidencia se conserva la presentación normal.
- **Separar catálogo y tema activo:** los launchers integrados y los temas importados se expondrán mediante un contrato común. La preferencia guardará un identificador estable del tema activo y el repositorio local conservará su metadato y ruta extraída.
- **Aplicación por composición:** el tema se inyectará desde el shell de la aplicación hacia navegación, opciones, pantalla meteorológica y estados. Los datos, repositorios meteorológicos y selección de ciudades no dependerán del tema.
- **Almacenamiento local de preferencias:** idioma, unidad, tema activo y datos de temas permanecerán en almacenamiento local. La eliminación del tema activo activará primero el launcher retro integrado y después eliminará sus archivos.
- **Importación atómica:** se copiará y validará el ZIP en un área temporal; solo tras completar todas las comprobaciones se moverá al almacenamiento definitivo y se registrará. Así, una importación fallida no altera el tema activo.
- **Validación defensiva:** se limitarán tamaño total, número de archivos, dimensiones de imagen, duración o peso razonable de GIFs y tamaño de fuentes. Se comprobarán extensiones, contenido decodificable, referencias existentes, rangos y solapamientos de reglas.
- **Seguridad de fuentes y animaciones:** no se permitirá cargar código ejecutable desde el paquete. Las fuentes serán opcionales y se registrarán con una familia interna del tema para evitar sustituir globalmente fuentes de otros temas.
- **Acceso a archivos detrás de una interfaz:** la selección de archivos y la extracción se ocultarán tras servicios sustituibles, de modo que Android e iOS puedan compartir dominio y validación, pero adaptar permisos y APIs de almacenamiento.

## Risks / Trade-offs

- [Los GIF pueden consumir memoria o batería] → Limitar dimensiones, tamaño y duración; liberar recursos al cambiar de tema y probar en dispositivos Android e iOS modestos.
- [Los formatos de fuente varían entre plataformas] → Validar TTF/OTF, usar una fuente de reserva y probar renderizado en ambos sistemas.
- [Un ZIP puede contener rutas maliciosas o archivos descomprimidos enormes] → Canonicalizar rutas, rechazar traversal y aplicar límites antes y durante la extracción.
- [Reglas incompletas generan resultados inesperados] → Rechazar referencias inválidas y solapamientos ambiguos; usar la interfaz normal cuando no haya coincidencia.
- [El almacenamiento local puede perderse al desinstalar] → Documentar que los temas son privados del dispositivo y no forman parte de una copia remota.
- [Cambiar toda la apariencia puede dejar texto ilegible] → Validar campos obligatorios de contraste y conservar límites de accesibilidad y layouts estables.
- [Un tema de usuario puede incluir contenido protegido] → No subir ni distribuir paquetes; no incluir assets de terceros en la plantilla; mostrar al usuario que es responsable de sus recursos importados.

## Migration Plan

1. Extender el contrato visual y mantener el launcher retro como fallback estable.
2. Añadir el modelo versionado del manifiesto, validador y repositorio local sin cambiar todavía la selección existente.
3. Implementar la importación de ZIP y la gestión de temas en Opciones.
4. Integrar la unidad Celsius/Fahrenheit y la resolución de reglas sin cambiar el modelo meteorológico.
5. Aplicar el tema a todas las superficies y añadir pruebas de widget, dominio, almacenamiento y recursos animados.
6. Verificar Android e iOS en dispositivos o emuladores y documentar límites del formato.
7. Para rollback, ignorar el tema activo importado y seleccionar el launcher retro; los datos meteorológicos y preferencias no relacionadas permanecen intactos.

## Open Questions

- Los límites numéricos exactos de ZIP, imágenes, GIFs y fuentes deben fijarse durante la implementación mediante pruebas de memoria y rendimiento en Android e iOS.
- La apariencia exacta del editor o previsualizador del tema puede definirse después de validar el formato de importación.