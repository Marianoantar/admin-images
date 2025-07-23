#!/bin/bash

echo "Iniciando servidor de Ollama..."
ollama serve &

# Esperar a que el backend de Ollama levante
sleep 5

echo "Iniciando la aplicación principal..."
/usr/src/app/main.sh
