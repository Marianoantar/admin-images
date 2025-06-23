# Trabajo Práctico de Entorno de Programación (2025)

Este repositorio es un trabajo práctico para la materia "Entorno de
Programación" de la carrera T.U.I.A. en F.C.E.I.A. (U.N.R.).

Aquí puede leerse el [enunciado](docs/enunciado.md) del trabajo.

## Instrucciones

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

* Ayax Garcia Williner
* Leonardo Prone
* Mariano Tardugno
