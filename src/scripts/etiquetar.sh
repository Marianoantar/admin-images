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

echo "🔧 SOURCEDIR: $SOURCEDIR"
# Crear la carpeta donde YOLO guardará las imágenes procesadas (si save=True está activo)
mkdir -p "$SOURCEDIR/runs" || echo " No se pudo crear $SOURCEDIR/runs"

if ! command -v yolo &>/dev/null; then
    echo "Error: comando 'yolo' no encontrado."
    exit 1
fi

# Exportar ULTRALYTICS_PRINTER para asegurar la salida de YOLO
export ULTRALYTICS_PRINTER=True

for IMG in "${IMAGENES[@]}"; do
    NOMBRE_IMG=$(basename "$IMG")
    RUTA_RELATIVA="imagenes/$NOMBRE_IMG" # Ejemplo: imagenes/foto.jpg

    # --- NUEVA LÓGICA: SALTAR IMÁGENES YA ETIQUETADAS USANDO GREP ---
    echo
    echo "Verificando $NOMBRE_IMG..."
    
    # Buscamos la ruta relativa de la imagen en etiquetas.json
    # Y el nombre del archivo en imagenes.json (clave del JSON)
    if grep -q "$RUTA_RELATIVA" "$ETIQUETAS_JSON" || grep -q "\"$NOMBRE_IMG\":" "$IMAGENES_JSON"; then
        echo "✅ Imagen $NOMBRE_IMG ya procesada. Saltando..."
        continue # Pasa a la siguiente imagen en el bucle
    else
        echo "⏳ Imagen $NOMBRE_IMG aún no procesada. Procesando..."
    fi
    # --- FIN DE NUEVA LÓGICA ---

    ETIQ_PRINCIPAL="no_detections" # Valor por defecto si no se detecta nada

    echo "Analizando $IMG"

    # Ejecutar YOLO y capturar la salida.
    YOLO_OUTPUT=$(yolo predict model=/usr/src/app/models/yolov8l.pt \
        source="$IMG" save=True \
        imgsz=640 conf=0.1 2>&1) # Capturamos stdout y stderr

    # Depuración: Mostrar la salida completa de YOLO
    echo "Salida COMPLETA de YOLO para $NOMBRE_IMG (¡revisar esta sección cuidadosamente!):"
    echo "$YOLO_OUTPUT"
    echo "--- FIN de Salida COMPLETA de YOLO ---"

    # Extraer la línea que contiene las detecciones o "(no detections)"
    DETECTION_LINE=$(echo "$YOLO_OUTPUT" | grep -E "^image 1/1 " | head -n 1)


    echo "Línea de detección capturada (después de grep): '$DETECTION_LINE'" # Depuración

    if [[ "$DETECTION_LINE" == *"(no detections)"* ]]; then
        ETIQ_PRINCIPAL="no_detections"
    elif [[ -n "$DETECTION_LINE" ]]; then
        # Paso 1: Limpiar la línea de detección para quedarnos solo con las etiquetas.
        CLEAN_DETECTIONS=$(echo "$DETECTION_LINE" | sed -E 's/.*: [0-9]+x[0-9]+ ([^,]+(,[^,]+)*), [0-9.]+ms/\1/')
        
        # Fallback si sed no extrae correctamente o la línea es diferente
        if [[ -z "$CLEAN_DETECTIONS" || "$CLEAN_DETECTIONS" == *":"* ]]; then
             CLEAN_DETECTIONS=$(echo "$DETECTION_LINE" | sed -E 's/.*: [0-9]+x[0-9]+ (.*), [0-9.]+ms/\1/' | sed 's/ (no detections)//g' | sed 's/^\s*//')
        fi

        echo "Detecciones limpias: '$CLEAN_DETECTIONS'" # Depuración

        # Paso 2: Extraer la primera etiqueta del texto limpio
        FIRST_DETECTION_COUNTED=$(echo "$CLEAN_DETECTIONS" | grep -oE '[0-9]+ ([a-zA-Z ]+)' | head -n 1)

        if [[ -n "$FIRST_DETECTION_COUNTED" ]]; then
            # Quitar el número y el espacio iniciales
            ETIQ_PRINCIPAL=$(echo "$FIRST_DETECTION_COUNTED" | sed -E 's/^[0-9]+\s+//' | sed 's/\s+$//')
        fi
    fi

    echo "Etiqueta principal detectada: $ETIQ_PRINCIPAL"

    # Actualizar etiquetas.json
    jq --arg e "$ETIQ_PRINCIPAL" --arg img "$RUTA_RELATIVA" '
    if .[$e] then
        .[$e] += [$img] | unique
    else
        .[$e] = [$img]
    end
    ' "$ETIQUETAS_JSON" > "${ETIQUETAS_JSON}.tmp" \
    && mv "${ETIQUETAS_JSON}.tmp" "$ETIQUETAS_JSON"

    # Obtener descripción con Moondream (si está disponible)
    if command -v ollama &>/dev/null; then
        echo "Ejecutando Moondream para: $NOMBRE_IMG"
        DESCRIPCION=$(ollama run moondream "Describe me this image." "$(realpath "$IMG")" 2>/dev/null)

        echo "Descripción generada:"
        echo "$DESCRIPCION"

        if [[ -n "$DESCRIPCION" && "$DESCRIPCION" != "null" && "$DESCRIPCION" != *"error"* && "$DESCRIPCION" != *"failed to get image from"* ]]; then
            CLEAN_DESCRIPCION=$(echo "$DESCRIPCION" | tr '\n' ' ' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            jq --arg nombre "$NOMBRE_IMG" --arg texto "$CLEAN_DESCRIPCION" \
                '.[$nombre] = $texto' "$IMAGENES_JSON" > "${IMAGENES_JSON}.tmp" \
                && mv "${IMAGENES_JSON}.tmp" "$IMAGENES_JSON"
            echo "Descripción guardada en $IMAGENES_JSON"
        else
            echo "No se generó descripción para $NOMBRE_IMG o hubo un error con Moondream."
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