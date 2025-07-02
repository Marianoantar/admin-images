#!/bin/bash

# Cargar configuración del sistema
source "$(dirname "$0")/../menu/configuracion.sh"

# Directorio de imágenes a procesar (puede venir como argumento o usar valor por defecto)
DIRECTORIO="${1:-$IMAGESDIR}"

# Asegura que los JSON existan
[ ! -f "$ETIQUETAS_JSON" ] && echo '{}' > "$ETIQUETAS_JSON"
[ ! -f "$IMAGENES_JSON" ] && echo '{}' > "$IMAGENES_JSON"

shopt -s nullglob
IMAGENES=("$DIRECTORIO"/*.jpg)
shopt -u nullglob

if [[ ${#IMAGENES[@]} -eq 0 ]]; then
    echo " No se encontraron imágenes JPG en $DIRECTORIO"
    exit 1
fi

CLASES=(person bicycle car motorcycle airplane bus train truck boat traffic_light fire_hydrant stop_sign parking_meter bench bird cat dog horse sheep cow elephant bear zebra giraffe backpack umbrella handbag tie suitcase frisbee skis snowboard sports_ball kite baseball_bat baseball_glove skateboard surfboard tennis_racket bottle wine_glass cup fork knife spoon bowl banana apple sandwich orange broccoli carrot hot_dog pizza donut cake chair couch potted_plant bed dining_table toilet tv laptop mouse remote keyboard cell_phone microwave oven toaster sink refrigerator book clock vase scissors teddy_bear hair_drier toothbrush)

echo "🔧 SOURCEDIR: $SOURCEDIR"
mkdir -p "$SOURCEDIR/tmp_results/test_creacion" || echo " No se pudo crear tmp_results"

for IMG in "${IMAGENES[@]}"; do
    echo
    echo "Analizando $IMG"

    if ! command -v yolo &>/dev/null; then
        echo "Error: comando 'yolo' no encontrado."
        continue
    fi

    yolo detect predict model=/usr/src/app/models/yolov8l.pt \
        source="$IMG" save_txt=True \
        project="$SOURCEDIR/tmp_results" \
        name=etiquetas exist_ok=True \
        imgsz=640 conf=0.1

    NOMBRE_IMG=$(basename "$IMG")
    RUTA_RELATIVA="imagenes/$NOMBRE_IMG"
    LABEL_PATH="$SOURCEDIR/tmp_results/etiquetas/labels/${NOMBRE_IMG%.*}.txt"

    if [[ -f "$LABEL_PATH" ]]; then
        ID=$(head -n 1 "$LABEL_PATH" | cut -d' ' -f1)
        ETIQ="${CLASES[$ID]}"
    else
        ETIQ="no_detections"
    fi

    # Actualizar etiquetas.json
    jq -n --arg e "$ETIQ" --arg img "$RUTA_RELATIVA" '{($e): [$img]}' > "$SOURCEDIR/tmp_uno.json"

    jq -s 'reduce .[] as $item ({}; 
        reduce ($item | to_entries[]) as $kv (.;
            .[$kv.key] = ((.[$kv.key] + $kv.value) // $kv.value | unique)))' \
        "$ETIQUETAS_JSON" "$SOURCEDIR/tmp_uno.json" > "${ETIQUETAS_JSON}.tmp" \
        && mv "${ETIQUETAS_JSON}.tmp" "$ETIQUETAS_JSON" \
        && rm "$SOURCEDIR/tmp_uno.json"

    # Obtener descripción con Moondream (si está disponible)
    if command -v ollama &>/dev/null; then
        echo "Ejecutando Moondream para: $NOMBRE_IMG"
        DESCRIPCION=$(ollama run moondream "$IMG describe this image" 2>/dev/null)

        echo "Descripción generada:"
        echo "$DESCRIPCION"

        if [[ -n "$DESCRIPCION" && "$DESCRIPCION" != "null" ]]; then
            jq --arg nombre "$NOMBRE_IMG" --arg texto "$DESCRIPCION" \
                '.[$nombre] = $texto' "$IMAGENES_JSON" > "${IMAGENES_JSON}.tmp" \
                && mv "${IMAGENES_JSON}.tmp" "$IMAGENES_JSON"
            echo "Descripción guardada en $IMAGENES_JSON"
        else
            echo "No se generó descripción para $NOMBRE_IMG"
        fi
    else
        echo "Moondream (ollama) no está disponible. Saltando descripción."
    fi

done

echo
echo "Resumen de etiquetas principales:"
jq -r 'to_entries[] | "\(.key): \(.value | length) imagen(es)"' "$ETIQUETAS_JSON" | sort

echo
echo "Proceso completado. JSONs generados correctamente."
