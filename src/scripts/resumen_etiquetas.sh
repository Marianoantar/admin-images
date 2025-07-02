#!/bin/bash

# Cargar configuración
source "$(dirname "$0")/../menu/configuracion.sh"

# Verificar existencia del archivo de etiquetas
if [[ ! -f "$ETIQUETAS_JSON" ]]; then
    echo "No se encontró el archivo etiquetas.json"
    exit 1
fi

# Calcular total de imágenes sumando todas las etiquetas
TOTAL=$(jq '[.[] | length] | add' "$ETIQUETAS_JSON")

if [[ -z "$TOTAL" || "$TOTAL" -eq 0 ]]; then
    echo "No hay imágenes registradas en etiquetas.json"
    exit 0
fi

echo
echo "Resumen de imágenes por etiqueta:"
echo

# Encabezado de tabla
printf "%-20s %-10s %-10s\n" "Etiqueta" "Cantidad" "Porcentaje"
echo "-----------------------------------------------"

# Filas ordenadas
jq -r --argjson total "$TOTAL" '
    to_entries[]
    | [.key, (.value | length), ((.value | length / $total * 100) | floor | tostring) + "%"]
    | @tsv
' "$ETIQUETAS_JSON" | sort -k2 -nr | while IFS=$'\t' read -r etiqueta cantidad porcentaje; do
    printf "%-20s %-10s %-10s\n" "$etiqueta" "$cantidad" "$porcentaje"
done

echo
echo "Total general de imágenes: $TOTAL"
echo
read -p "Presioná Enter para volver al menú."
