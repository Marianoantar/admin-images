#!/bin/bash
# NO EDITE ESTE ARCHIVO

SOURCEDIR=$(readlink -f $(dirname $0))
IMAGESDIR=$(readlink -f $SOURCEDIR/../imagenes)
COOLDOWN=5
export SOURCEDIR IMAGESDIR COOLDOWN

# Run ollama serve in the background
ollama serve &> /dev/null &
