# Trabajo Práctico de Entorno de Programación (2025)

El trabajo práctico consiste en desarrollar un sistema automatizado que descargue, clasifique y etiquete imágenes usando scripts en Bash, procesamiento con **YOLO** para detección de objetos, y **Moondream** para generación de las descripciones. Integrando todo en un entorno Dockerizado con control de versiones mediante Git.

Aquí puede leerse el [enunciado](docs/enunciado.md) del trabajo.

## Instrucciones

Clone el repositorio

```bash
   git clone https://gitlab.com/agarciawilliner/tpentorno2025.git
   cd tpentorno2025
```
### Dependencias

Es necesario tener instalados `docker` y `docker buildx` para poder ejecutar
este programa. En distribuciones basadas en Ubuntu esto puede conseguirse así:
```bash
sudo apt update
sudo apt install docker.io docker-buildx
```

Luego será necesario habilitar el servicio de contenedores de docker:
```bash
sudo systemctl enable docker
sudo systemctl start docker
```

También puede ser de utilidad agregar al usuario actual al grupo `docker`:
```bash
sudo usermod -aG docker $USER
```
Para que este cambio surja efecto, es necesario reiniciar la sesión.

### Ejecución

Para poder utilizar el programa primero debe construir el contendor:
```bash
docker buildx build -t entorno .
```
o
```bash
docker build -t entorno .
```

Luego puede ejecutarse el contenedor con el siguiente comando:
```bash
docker run -it entorno
```

Tambien puede correrse el programa fuera del contenedor:
```bash
./src/main.sh
```

## Integrantes
+ Tardugno, Mariano
+ Garcia Williner, Ayax
+ Prone, Leonardo
