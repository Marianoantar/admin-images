#!/bin/bash

# Este script debe descargar una sola imagen desde internet en la carpeta actual.
# Puede recibir un argumento opcional indicando la clase de la imagen.
# El nombre del archivo deberá ser único, una opción para evitar repetición de imágenes
# y asegurar que sea único se puede usar su suma de verificación.
# Las imágenes descargadas tienen extensión .jpg.
# Asegúrese de devolver un valor de salida acorde a la situación.

# Recibe un argumento indicando la clase de la imagen
CLASE=$1
# URL facilitada por profesores ($CLASE se pasa como parámetro a través de la URL)
URL=https://tuia-edp.org/random-image?category=$CLASE



# Para descargar se necesita un nombre para guardar el archivo
ARCHIVO_IMG=imagen.jpg

# Recomendación profesor: usar wget para descargar imagen (descarga y guarda en ARCHIVO_IMG)
wget "$URL" -O "$ARCHIVO_IMG"

# Mensajes de salida donde se verifica si ARCHIVO_IMG tiene una imagen o no, con -s.
if [ $? -ne 0 ] || [ ! -s "$ARCHIVO_IMG" ]; then
	echo "Error al descargar imagen."
	rm -f "$ARCHIVO_IMG"
	exit 1
fi    

# Para crear un nombre unico se calcula un "HASH" con el comando sha256sum que genera una cadena de caracteres
HASH=$(sha256sum "$ARCHIVO_IMG")
HASH=${HASH%% *} # Expansion para que solo se quede con el hash

# Creamos un nombre final combinando con el hash
ARCHIVO_IMG_FIN="${CLASE}_${HASH}.jpg"

# Renombramos el archivo
mv "$ARCHIVO_IMG" "$ARCHIVO_IMG_FIN"

# Otra vez chequeamos el archivo renombrado, pero si mv falla.
if [ $? -ne 0 ]; then
	echo "Error al guardar imagen."
	rm -f "$ARCHIVO_IMG"
	exit 2
fi

# Mensaje de salida final

echo "Imagen guardada como $ARCHIVO_IMG_FIN"
exit 0

