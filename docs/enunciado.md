# Trabajo Práctico Final

## Introducción

### Descripción

El objetivo del trabajo práctico es usar `git` y `docker` correctamente mientras
se completa un programa para descargar y etiquetar un lote de imágenes.

Este programa consta de cuatro partes principales:

1. Obtención de imágenes.
2. Generación de etiquetas.
3. Mostrar imágenes de determinada etiqueta.
4. Generación de un archivo comprimido con las imágenes y etiquetas.

Todo el trabajo debe ser realizado bajo control de versiones, con participación
de **todos** los integrantes y debe ejecutarse dentro del contenedor.

### Pautas generales

* El trabajo práctico deberá ser realizado en grupos de dos.
* Deberán crear un fork de este proyecto desde una de sus cuentas de gitlab y compartirlo con el otro integrante del grupo con permiso owner y con permiso reporter a anamurinigo@fceia.unr.edu.ar,  aleoncavallo@gmail.com y gbocchio@gmail.com. 
* Todos los integrantes deben conocer todos los aspectos del trabajo entregado.
* Se admite una única entrega final, es por ello que solicitamos revisen muy
bien las funcionalidades previamente a la entrega formal.

## Enunciado

Deberán modificar un contenedor que al ejecutarse presenta un menú de opciones.
Para ello será necesario editar el `Dockerfile` y construir la imagen.

Las imágenes a analizar deben ser descargadas desde internet y deben almacenarse
dentro del contenedor para su posterior análisis. Luego del análisis, deberá
generarse un archivo disponible fuera del contenedor.

Tanto los scripts, como el `Dockerfile`, deben estar en el repositorio gitlab
que creen para realizar el desarrollo en equipo.

Deberán trabajar en el repositorio manteniendo la prolijidad y las buenas
prácticas de `git`: por cada script se deberá crear una rama para luego ir
integrando a la rama principal a medida que los scripts estén listos. Todos los
integrantes deben realizar commits en el repositorio.

En ese mismo repositorio debe estar la documentación suficiente para comprender
cómo desplegar el contenedor y ejecutar la aplicación. Esta documentación debe
estar en un archivo `README.md` el cual estará presente cuando se accede al
repositorio en gitlab.

### Scripts

Se deberán programar los siguientes scripts:

* `internet.sh`: Chequea que haya conexión a internet.

* `descargar.sh`: Descarga una imagen de internet y la nombra convenientemente.

* `etiquetar.sh`: Genera un archivo con las etiquetas de una imagen.

* `mostrar.sh`: Muestra las imágenes que contienen objetos de una etiqueta dada.

* `comprimir.sh`: Comprime todas las imágenes.

* `extra.sh`: Funcionalidad adicional a elección de cada grupo.

### Estructura de directorios

El programa está estructurado en varias carpetas para que sea mas sencillo
trabajar. Dentro de cada una de ellas se encuentra la documentación específica
de dicha carpeta.

Los únicos archivos que debe modificar el estudiante son el archivo
`Dockerfile`, el archivo `README.md` y los scripts de la carpeta `src/scripts`.
No deben modificar los scripts de `src/menu` pero es necesario que los lean y
los puedan explicar.

La carpeta `./imagenes` debe poder accederse dentro del contenedor en la ruta
`/imagenes`.

### Herramientas útiles

#### Descarga de imágenes

Para descargar imágenes al azar, pueden utilizarse estos enlaces:
  * https://source.unsplash.com/random/
  * https://picsum.photos/512
  * https://loremflickr.com/512/512/
  * https://random-image-pepebigotes.vercel.app/api/random-image
  * https://image.pollinations.ai/prompt/a%20photo%20of%20a%20person?seed=1

#### Yolo

Yolo es un modelo de I.A. que puede utilizarse para clasificar imágenes. Dentro
del contenedor puede utilizarse con el siguiente comando:
```bash
yolo predict source=/ruta/archivo.jpg
```

#### jp2a
`jp2a` Es una herramienta para convertir imágenes en caracteres ASCII. Deberá
investigar la instalación y uso de la herramienta.

### Documentación adicional
Para mas información puede referirse al archivo de [aclaraciones](aclaraciones.md)
