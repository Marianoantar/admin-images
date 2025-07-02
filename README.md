# TP Entorno 2025 — Sistema de Análisis de Imágenes con IA

## Integrantes:
+ Tardugno, Mariano
+ Garcia Williner, Ayax
+ Prone, Leonardo

Este proyecto es una aplicación en Bash que permite analizar imágenes utilizando un modelo de detección de objetos (YOLOv8) y generar descripciones usando un modelo multimodal (Moondream vía Ollama). Se construye como contenedor Docker y no requiere instalaciones adicionales en el host.
 
 
## Ejecución del proyecto:

1. Clonar el repositorio:

```bash
git clone https://gitlab.com/agarciawilliner/tpentorno2025
cd tpentorno2025


2. Construir la imagen localmente:

docker build -t entorno .

3. Ejecutar la aplicación:

docker run -it entorno

### Esto inicia el menú principal desde main.sh, donde podrá:

+ Descargar imágenes

+ Analizar las imágenes, generar etiquetas con YOLOv8 y describir las imágenes con Moondream

+ Ver las imágenes y descripciones en consola

+ Generar un resumen con estadísticas de las imágenes descargadas por etiqueta



## Requisitos técnicos:

+ Tener Docker instalado en el sistema (necesario tanto para construir como para ejecutar el proyecto)

+ Contar con conexión a internet la primera vez que se construye la imagen, ya que se descargará el modelo Moondream mediante Ollama. Nota: el modelo YOLOv8 ya está incluido dentro del repositorio y no requiere descarga adicional.

