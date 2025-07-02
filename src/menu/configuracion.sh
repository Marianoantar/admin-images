#!/bin/bash
# NO EDITE ESTE ARCHIVO

# Directorio base desde donde se ejecutan los scripts
SOURCEDIR=$(readlink -f $(dirname $0))

# Ruta absoluta a la carpeta de imágenes en la raíz del contenedor
IMAGESDIR="/imagenes"

# Ruta donde se guardarán los JSON (etiquetas e info de imágenes)
JSONDIR="/usr/src/app"
ETIQUETAS_JSON="$JSONDIR/etiquetas.json"
IMAGENES_JSON="$JSONDIR/imagenes.json"

# Intervalo de espera entre descargas (en segundos)
COOLDOWN=5

# Exportar variables para que estén disponibles en todos los scripts
export SOURCEDIR IMAGESDIR JSONDIR ETIQUETAS_JSON IMAGENES_JSON COOLDOWN

# Ejecutar ollama serve en segundo plano (si aplica)
ollama serve &> /dev/null &