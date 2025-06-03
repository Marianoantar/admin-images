# Respecto a etiquetar con Yolo:

Yolo etiqueta los objetos que se encuentran en una imagen y nos devuelve líneas
con la siguiente apariencia:
```bash
Downloading https://github.com/ultralytics/assets/releases/download/v8.1.0/yolov8n.pt to 'yolov8n.pt'...
100%|████████████████████████████████████████████| 6.23M/6.23M [00:04<00:00, 1.37MB/s]
Ultralytics YOLOv8.1.47 🚀 Python-3.8.10 torch-2.0.1+cu117 CPU (Intel Core(TM) i5-5300U 2.30GHz)
YOLOv8n summary (fused): 168 layers, 3151904 parameters, 0 gradients, 8.7 GFLOPs

image 1/1 /home/andrea/entorno/tp/ff417926378038bb08cd3dc92bcae2fa5cfd30919f6b5e4af242b9436ae4b29a.jpg: 448x640 2 persons, 1 potted plant, 1 laptop, 2 books, 1008.0ms
Speed: 43.4ms preprocess, 1008.0ms inference, 2292.1ms postprocess per image at shape (1, 3, 448, 640)
```

Consideraremos etiquetas en este ejemplo a: `persons`, `potted plant`, `laptop`
y `books`.
Definimos por etiqueta principal a la primera que aparece, en este caso sería:
`persons`.

En algunos casos, Yolo no nos devuelve ninguna etiqueta, un ejemplo de salida de
esto es el siguiente:
```bash
Ultralytics YOLOv8.1.47 🚀 Python-3.8.10 torch-2.0.1+cu117 CPU (Intel Core(TM) i5-5300U 2.30GHz)
YOLOv8n summary (fused): 168 layers, 3151904 parameters, 0 gradients, 8.7 GFLOPs

image 1/1 /home/andrea/entorno/tp/1bdcbfeea2c5345f0fe9c781da9684cf9fe8ec19091cb0f21e80e5a9aaeb4173.jpg: 640x480 (no detections), 437.6ms
Speed: 35.0ms preprocess, 437.6ms inference, 264.7ms postprocess per image at shape (1, 3, 640, 480)
```

En este caso consideraremos que tiene una única etiqueta (es decir la etiqueta
principal) que llamaremos: `no_detections`.

>Pista: Para quitar el último campo puede ser útil usar el comando `rev`.

# Respecto a obtener la descripción de la imagen con Moondream

Moondream recibe un pequeño prompt de entrada ("Describeme esta imagen", "Qué estilo tiene esta imagen?") y
realiza una breve descripción de lo que ve, por ejemplo:

```bash
/ # ollama run moondream "Describe me this image." dog.jpg
[GIN] 2025/05/05 - 17:41:09 | 200 |      25.118µs |       127.0.0.1 | HEAD     "/"
[GIN] 2025/05/05 - 17:41:09 | 200 |     7.17952ms |       127.0.0.1 | POST     "/api/show"
time=2025-05-05T17:41:09.046Z level=WARN source=sched.go:137 msg="multimodal models don't support parallel requests yet"

A black and white dog is sitting on a couch, facing the camera with its head tilted to one side as
if looking at something off-camera. The background of the photo is blurred, drawing attention to
the dog in focus.
```

# Respecto de la salida esperada de etiquetar.sh:
El script `etiquetar.sh` recibirá el directorio donde están descargadas todas las imágenes y creará una "base de datos" de
las mismas ordenadas según las etiquetas encontradas y las rutas a las archivos. Para ello, deberán crear dos archivos [`json`](https://en.wikipedia.org/wiki/JSON) que tengan las siguientes estructuras:

```bash
$ cat etiquetas.json
{
    "person": [
        "imagenes/imagen1.jpg",
        "imagenes/imagen4.jpg"
    ],
    "dog": [
        "imagenes/imagen1.jpg",
        "imagenes/imagen3.jpg"
    ]
}
```

```bash
$ cat imagenes.json
{
    "imagen1.jpg": "Descripcion de la imagen 1",
    "imagen2.jpg": "Descripcion de la imagen 2",
    ...
}
```

### Ayuda
Para manipular archivos `.json` existe una herramienta estándar (un filtro) llamado `jq`.
Por ejemplo:
```bash
$ cat etiquetas.json | jq
{
  "person": [
    "imagenes/imagen1.jpg",
    "imagenes/imagen4.jpg"
  ],
  "dog": [
    "imagenes/imagen1.jpg",
    "imagenes/imagen3.jpg"
  ]
}
```

En este primer ejemplo trivial, recibe un archivo de entrada `etiqutas.json`, verifica si es válido
y nos lo muestra bien formateado por la terminal.

Si queremos agregar una nueva etiqueta, podríamos hacer:
```
$ cat etiquetas.json | jq '.duck += ["imagenes/ejemplo"]'
{
  "person": [
    "imagenes/imagen1.jpg",
    "imagenes/imagen4.jpg"
  ],
  "dog": [
    "imagenes/imagen1.jpg",
    "imagenes/imagen3.jpg"
  ],
  "duck": [
    "imagenes/ejemplo"
  ]
}
```

En este caso, se crea una nueva etiqueta `duck` y una lista de rutas de imágenes que contienen gatos. Prestar
especial atención a los corchetes `[]` que se encuentran en `["imagenes/ejemplo"]`, ya que estos determinan
que es una lista de rutas lo que corresponde a la etiqueta `cat`.

Si queremos agregar una nueva ruta a una etiqueta ya existente, podemos hacer:
```bash
$ cat etiquetas.json | jq '.person += ["imagenes/ejemplo"]'
{
  "person": [
    "imagenes/imagen1.jpg",
    "imagenes/imagen4.jpg",
    "imagenes/ejemplo"
  ],
  "dog": [
    "imagenes/imagen1.jpg",
    "imagenes/imagen3.jpg"
  ]
}
```

Y vemos como se agregó la imagen `ejemplo` en la etiqueta de `person`.

Del mismo modo, si queremos obtener todas las rutas de una determinada etiqueta, podemos hacer:
```bash
$ cat etiquetas.json | jq '.person[]'
"imagenes/imagen1.jpg"
"imagenes/imagen4.jpg"
```
