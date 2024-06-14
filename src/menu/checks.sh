#!/usr/bin/bash
# NO EDITE ESTE ARCHIVO

tput setaf 1 && tput blink && tput bold
[ -f /.dockerenv ] || echo ATENCIÓN: Corriendo fuera de un contenedor.
[ -d $IMAGESDIR ] || echo ATENCIÓN: No se puede acceder a la carpeta de imágenes.
tput sgr0
