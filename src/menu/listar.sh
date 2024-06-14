#!/bin/bash
# NO EDITE ESTE ARCHIVO

clear
$SOURCEDIR/menu/checks.sh

echo Imágenes:
ls --color=auto -I "*.tag" -I "*.tar" -I "*.gz" -I "*.md" -I "*.zip" 2> /dev/null
echo

echo Comprimidos:
ls --color=auto *.tar *.gz *.zip *.rar *.7z 2> /dev/null
echo

echo Etiquetas:
tail -n +1 *.tag 2> /dev/null
echo
