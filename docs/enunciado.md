# Trabajo Práctico Final

## Introducción

### Descripción

El objetivo del trabajo práctico es usar `git` y `docker` correctamente mientras
se completa un programa para descargar, etiquetar y clasificar un lote de imágenes.

Este programa consta de cuatro partes principales:

1. Obtención de imágenes.
2. Generación de etiquetas.
3. Mostrar imágenes y su descripción para una determinada etiqueta.

Todo el trabajo debe ser realizado bajo control de versiones, con participación
de **todos** los integrantes y debe ejecutarse dentro del contenedor.

### Pautas generales

* El trabajo práctico deberá ser realizado en grupos de dos o tres integrantes.
* Deberán crear un fork de este proyecto desde una de sus cuentas de gitlab y
compartirlo con el otro integrante del grupo con permiso owner y con permiso
reporter a @fceiatuia.
* Todos los integrantes deben conocer todos los aspectos del trabajo entregado.
* Se admite una única entrega final, es por ello que solicitamos revisen muy
bien las funcionalidades previamente a la entrega formal.

## Enunciado

Deberán modificar un contenedor que al ejecutarse presenta un menú de opciones.
Para ello será necesario editar el [`Dockerfile`](../Dockerfile) y construir la imagen.

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

* `etiquetar.sh`: Genera un archivo de etiquetas donde cada etiqueta tenga las
rutas a la imagen y su descripción.

* `mostrar.sh`: Muestra las imágenes que contienen objetos de una etiqueta dada.

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

Más detalles de la estructura de archivos y directorios y los archivos
generados en el paso `etiquetar.sh` puede leerse en las [aclaraciones.md](./aclaraciones.md)

### Herramientas útiles

#### Descarga de imágenes

Para descargar imágenes al azar, pueden utilicen este enlace:
  * https://tuia-edp.org/random-image

#### Yolo

Yolo es un modelo de I.A. que puede utilizarse para clasificar imágenes. Dentro
del contenedor puede utilizarse con el siguiente comando:
```bash
yolo predict source=/ruta/archivo.jpg
```

#### Moondream

Moondream es un modelo de I.A. Que puede utilizarse para describir imágenes. Dentro
del contendedor puede utilizarse con el siguiente comando:
```bash
ollama run moondream "Describe me this image." /ruta/archivo.jpg
```


#### jp2a
`jp2a` Es una herramienta para convertir imágenes en caracteres ASCII. Deberá
investigar la instalación y uso de la herramienta.

### Documentación adicional
Para mas información puede referirse al archivo de [aclaraciones](aclaraciones.md)
