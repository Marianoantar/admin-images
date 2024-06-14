#!/bin/bash
# NO EDITE ESTE ARCHIVO

$SOURCEDIR/scripts/internet.sh || exit 1
read -p "Cantidad de imágenes a descargar: " CANTIDAD
read -p "Clase de la imagen a descargar: " CLASE
cd $IMAGESDIR

for I in $(seq $CANTIDAD)
do
    $SOURCEDIR/scripts/descargar.sh $CLASE || exit 1
    sleep $COOLDOWN
done
