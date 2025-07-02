#!/bin/bash
# EDITAR ESTE ARCHIVO SOLAMENTE PARA AÑADIR UNA FUNCIONALIDAD EXTRA

# Activar venv solo si existe (modo local)
if [[ -f "venv/bin/activate" ]]; then
    source venv/bin/activate
fi

# Verificar que yolo esté disponible
if ! command -v yolo &>/dev/null; then
    echo "Error: el comando 'yolo' no está disponible en este entorno."
    exit 1
fi

clear

source "$(dirname "$0")/menu/configuracion.sh"



# Asegurar permisos de ejecución para todos los scripts del proyecto
find "$SOURCEDIR"/{menu,scripts} 2>/dev/null -type f -name "*.sh" -exec chmod +x {} \;

"$SOURCEDIR/menu/checks.sh"

COLUMNS=1
PS3="Elija una opción: "
select OPCION in "Descargar imágenes."      \
                 "Etiquetar imágenes."      \
                 "Mostrar imágenes."        \
                 "Informacion del sistema." \
                 "Resumen por etiqueta."    \
                 "Salir."
do
    case $REPLY in
        1) (cd "$IMAGESDIR" && "$SOURCEDIR/menu/descargar.sh") ;;
        2) "$SOURCEDIR/scripts/etiquetar.sh" "$IMAGESDIR" ;;
        3) (cd "$IMAGESDIR" && "$SOURCEDIR/scripts/mostrar.sh") ;;
        4) "$SOURCEDIR/menu/info.sh" ;;
        5) "$SOURCEDIR/scripts/resumen_etiquetas.sh" ;;
        6) exit 0 ;;
        *) echo "Opción incorrecta." ;;
    esac

    read -p "Presione enter para continuar..."
    clear
    "$SOURCEDIR/menu/checks.sh"
    COLUMNS=1
done


