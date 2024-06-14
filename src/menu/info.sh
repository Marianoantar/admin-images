#!/bin/bash
# NO EDITE ESTE ARCHIVO

clear
$SOURCEDIR/menu/checks.sh
echo Directorio de trabajo actual: $(pwd)
echo Directorio de scripts: $SOURCEDIR
echo Directorio de las imágenes: $IMAGESDIR
echo Espera entre descargas: $COOLDOWN segundos
echo Usuario actual: $(whoami)
echo Equipo actual: $(hostname)
