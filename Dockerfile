FROM ollama/ollama:latest

# Crear carpeta y definirla como directorio de trabajo
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Configurar entorno para que no pida input durante el build
ENV DEBIAN_FRONTEND=noninteractive

# Cambiar mirrors para evitar lentitud (opcional)
#RUN sed -i 's|http://.*.ubuntu.com|http://archive.ubuntu.com|g' /etc/apt/sources.list


# Instalar herramientas del sistema (incluye 'column' con util-linux)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget iputils-ping software-properties-common \
        jq jp2a bash ca-certificates build-essential \
        libgl1 libglib2.0-0 util-linux && \
    rm -rf /var/lib/apt/lists/*


# Instalar Python 3.9 desde PPA y configurarlo como predeterminado
# NOTA: Quité python3-pip de esta línea para manejarlo con get-pip.py
RUN add-apt-repository ppa:deadsnakes/ppa && apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.9 python3.9-dev python3.9-distutils && \
    rm -rf /var/lib/apt/lists/*

# Configurar alternativas para python3
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1

# *** NUEVA LINEA AQUI: Desinstalar cualquier pip residual de apt si existiera ***
# Esto es una medida de seguridad, ya que no lo instalamos arriba, pero por si acaso.
RUN apt-get remove -y python3-pip || true && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Instalar paquetes de Python
# Ahora instalamos pip con get-pip.py sin conflictos
RUN wget -q -O get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py && \
    python3 -m pip install --no-cache-dir \
        torch==2.1.2+cpu \
        torchvision==0.16.2+cpu \
        --index-url https://download.pytorch.org/whl/cpu && \
    python3 -m pip install --no-cache-dir \
        opencv-python-headless==4.9.0.80 \
        ultralytics==8.0.197 \
        urllib3==2.2.1 \
        certifi==2024.2.2 \
        idna==3.7

# Copiar el modelo YOLO y ajustar configuración
COPY ./models/yolov8l.pt /usr/src/app/models/
RUN sed -i "s,model:,model: /usr/src/app/models/yolov8l.pt," /usr/local/lib/python3*/dist-packages/ultralytics/cfg/default.yaml

# Descargar modelo Moondream usando Ollama
RUN ollama serve & \
    sleep 10 && \
    ollama pull moondream && \
    pkill ollama

# Copiar el código fuente desde src/
COPY ./src/ /usr/src/app/

# Dar permisos de ejecución a scripts
RUN find /usr/src/app -type f -name "*.sh" -exec chmod +x {} \;

# Variables de entorno (evita errores visuales)
ENV TERM xterm
ENV COLORTERM 24bit

# Crear ruta destino dentro del contenedor
RUN mkdir -p /imagenes
# Copiar el contenido local de imagenes/ al contenedor
COPY ./imagenes/ /imagenes/

# Punto de entrada
#ENTRYPOINT ["/usr/src/app/main.sh"]

# Copiar el script de arranque
COPY ./start.sh /usr/src/app/start.sh
RUN chmod +x /usr/src/app/start.sh

# Usar el nuevo script como punto de entrada
ENTRYPOINT ["/usr/src/app/start.sh"]