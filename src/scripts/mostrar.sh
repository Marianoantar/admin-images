#!/bin/bash

# Cargar configuración
source "$(dirname "$0")/../menu/configuracion.sh"

if [[ ! -f "$ETIQUETAS_JSON" ]] || [[ ! -f "$IMAGENES_JSON" ]]; then
    echo "Faltan archivos 'etiquetas.json' o 'imagenes.json'."
    exit 1
fi

read -p "Ingrese la etiqueta a buscar: " ETIQUETA

RUTAS=($(jq -r --arg etiq "$ETIQUETA" '.[$etiq][]?' "$ETIQUETAS_JSON"))

if [[ ${#RUTAS[@]} -eq 0 ]]; then
    echo "No se encontraron imágenes con la etiqueta '$ETIQUETA'."
    exit 0
fi

echo "Se encontraron ${#RUTAS[@]} imágenes con la etiqueta '$ETIQUETA'"
echo

# PRIMERA OPCIÓN: uso de jp2a si está disponible
if command -v jp2a &>/dev/null; then
    for IMG in "${RUTAS[@]}"; do
        NOMBRE_IMG=$(basename "$IMG")
        DESCRIPCION=$(jq -r --arg nom "$NOMBRE_IMG" '.[$nom] // "(sin descripción)"' "$IMAGENES_JSON")
        RUTA_ABS="/imagenes/$NOMBRE_IMG"

        clear
        echo "Imagen: $NOMBRE_IMG"
        echo "Descripción: $DESCRIPCION"
        echo
        if [[ -f "$RUTA_ABS" ]]; then
            jp2a --width=80 "$RUTA_ABS"
        else
            echo "(La imagen no fue encontrada en disco)"
        fi
        echo
        read -p "Presioná Enter para continuar o Q para salir: " RESP
        [[ "$RESP" =~ ^[Qq]$ ]] && break
    done
    echo
    read -p "Fin del recorrido. Presioná Enter para volver al menú."
    exit 0
fi

# SEGUNDA OPCIÓN: uso de feh si está disponible
if command -v feh &>/dev/null; then
    for IMG in "${RUTAS[@]}"; do
        NOMBRE_IMG=$(basename "$IMG")
        DESCRIPCION=$(jq -r --arg nom "$NOMBRE_IMG" '.[$nom] // "(sin descripción)"' "$IMAGENES_JSON")
        RUTA_ABS="/imagenes/$NOMBRE_IMG"

        if [[ -f "$RUTA_ABS" ]]; then
            clear
            echo "Imagen: $NOMBRE_IMG"
            echo "Descripción: $DESCRIPCION"
            echo
            read -p "Presioná Enter para verla o Q para salir: " RESP
            [[ "$RESP" =~ ^[Qq]$ ]] && break
            feh --auto-zoom --scale-down "$RUTA_ABS"
        else
            echo "(La imagen '$NOMBRE_IMG' no fue encontrada en disco)"
            read -p "Presioná Enter para continuar..."
        fi
    done
    echo
    read -p "Fin del recorrido. Presioná Enter para volver al menú."
    exit 0
fi

# TERCERA OPCIÓN: solo texto si no hay visor disponible
echo
echo "Mostrando detalles en modo texto:"
for IMG in "${RUTAS[@]}"; do
    NOMBRE_IMG=$(basename "$IMG")
    DESCRIPCION=$(jq -r --arg nom "$NOMBRE_IMG" '.[$nom] // "(sin descripción)"' "$IMAGENES_JSON")
    echo "$NOMBRE_IMG - $DESCRIPCION"
done

echo
read -p "Fin del recorrido. Presioná Enter para volver al menú."
