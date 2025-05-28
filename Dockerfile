FROM ollama/ollama:latest

RUN mkdir -p /usr/src/app

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    python3.9 \
    python3.9-dev \
    python3.9-distutils \
    python3-pip \
    build-essential \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1 \
    # Install PyTorch for CPU only
    && python3 -m pip install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cpu \
    # Install OpenCV via pip instead of apt
    && python3 -m pip install --no-cache-dir opencv-python-headless \
    # Install ultralytics (YOLO)
    && python3 -m pip install --no-cache-dir ultralytics \
    # Create YOLO config directory and configure model path
    && mkdir -p /usr/src/app/yolo_config \
    && echo "model: /usr/src/app/yolov8l.pt" > /usr/src/app/yolo_config/default.yaml \
    && echo "save_dir: /usr/src/app" >> /usr/src/app/yolo_config/default.yaml \
    # Clean up build dependencies and caches
    && apt-get purge -y --auto-remove \
        build-essential \
        python3.9-dev \
        software-properties-common \
    && rm -rf /root/.cache /tmp/* /var/lib/apt/lists/*

# Instalación del modelo YOLO
COPY ./models/yolov8l.pt /usr/src/app/

# Configuración de YOLO
# fija el modelo yolov8l
RUN sed -i "s,model:,model: /usr/src/app/yolov8l.pt," /usr/local/lib/python3*/dist-packages/ultralytics/cfg/default.yaml
# cambia el directorio donde se guardan las imagenes, por ahora no vamos a usar las imagenes generadas
RUN echo save_dir: /usr/src/app >> /usr/local/lib/python3.9/dist-packages/ultralytics/cfg/default.yaml
# Instalar los programas necesarios


# Configuracion de la aplicación
ENV TERM=xterm
ENV COLORTERM=24bit
COPY ["src/", "/app/"]
WORKDIR /app
ENTRYPOINT ["/app/main.sh"]
