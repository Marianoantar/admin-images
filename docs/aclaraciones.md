# Respecto a etiquetar con Yolo:

Yolo etiqueta los objetos que se encuentran en una imagen y nos devuelve líneas
con la siguiente apariencia:
```
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
```
Ultralytics YOLOv8.1.47 🚀 Python-3.8.10 torch-2.0.1+cu117 CPU (Intel Core(TM) i5-5300U 2.30GHz)
YOLOv8n summary (fused): 168 layers, 3151904 parameters, 0 gradients, 8.7 GFLOPs

image 1/1 /home/andrea/entorno/tp/1bdcbfeea2c5345f0fe9c781da9684cf9fe8ec19091cb0f21e80e5a9aaeb4173.jpg: 640x480 (no detections), 437.6ms
Speed: 35.0ms preprocess, 437.6ms inference, 264.7ms postprocess per image at shape (1, 3, 640, 480)
```

En este caso consideraremos que tiene una única etiqueta (es decir la etiqueta
principal) que llamaremos: `no_detections`.

# Respecto a la separación de etiquetas:

Se pide que los archivos terminados en `.tag` tengan una estructura del estilo
`etiqueta1`, `etiqueta2`, `...`.

Para quitar el último campo puede ser útil usar el comando `rev`.
