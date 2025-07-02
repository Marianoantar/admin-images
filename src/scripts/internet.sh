#!/bin/bash

# Este script simplemente debe chequear que haya conexión a internet.
# Asegúrese de retornar un valor de salida acorde a la situación.
# Puede que necesite modificar el archivo Dockerfile.


#echo Chequeo de Internet no implementado. && exit 1
if ping -c 1 8.8.8.8 > /dev/null; then
    echo "Conexión a Internet: OK"
    exit 0
else
    echo "Conexión a Internet: FALLIDA"
    exit 1
fi

