FROM ubuntu:22.04
# Usamos Ubuntu 22.04 LTS como base limpia

# Configuración de entorno silencioso y variables de terminal
ENV DEBIAN_FRONTEND="noninteractive"
ENV TERM="xterm"
ENV COLORTERM="24bit"
# Para matplotlib en entorno sin GUI
ENV MPLBACKEND="Agg"

# Crear carpeta para la aplicación y definir directorio de trabajo
WORKDIR /usr/src/app

# *** Línea para invalidar caché en builds sucesivos ***
RUN echo "Forcing dependencies rebuild: $(date +%Y%m%d%H%M%S)"

# Instalar wget, software-properties-common y Python 3.9 desde PPA deadsnakes
# Aseguramos instalación de build-essential, libgl1, libglib2.0-0, tk-dev, libfreetype6-dev
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget curl gnupg software-properties-common \
        jq jp2a bash ca-certificates \
        build-essential libgl1 libglib2.0-0 \
        tk-dev libfreetype6-dev \
        # >>> AÑADE iputils-ping AQUÍ <<<
        iputils-ping && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.9 \
        python3.9-dev \
        python3.9-distutils \
        python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Configurar Python 3.9 como predeterminado
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1

# Instalar librerías Python clave.
# Estrategia: Instalar PyTorch y Ultralytics primero (para que jalen sus dependencias de NumPy).
# Luego, forzar la versión deseada de NumPy para asegurar la compatibilidad con OpenCV.
RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools && \
    python3 -m pip install --no-cache-dir \
        torch==2.1.2+cpu \
        torchvision==0.16.2+cpu \
        --index-url https://download.pytorch.org/whl/cpu && \
    python3 -m pip install --no-cache-dir ultralytics==8.0.197 && \
    # Ahora, forzamos NumPy a la versión compatible con OpenCV para la que fue compilado.
    # Esto sobrescribirá cualquier NumPy 2.x que haya podido instalarse.
    python3 -m pip install --no-cache-dir --force-reinstall numpy==1.26.3 && \
    python3 -m pip install --no-cache-dir \
        opencv-python-headless==4.9.0.80 \
        matplotlib \
        pyyaml \
        urllib3==2.2.1 \
        certifi==2024.2.2 \
        idna==3.7 \
        tqdm \
        psutil \
        scipy && \
    # Limpiamos la caché de pip al final
    python3 -m pip cache purge

# --- Instalación de Ollama ---
# Instalar Ollama: Descargar el script de instalación oficial y ejecutarlo
RUN curl -fsSL https://ollama.com/install.sh | sh

# --- Sección de Instalación y Configuración Específica ---

# Copiar el modelo YOLO a la carpeta de trabajo
COPY ./models/yolov8l.pt /usr/src/app/models/

# Ajustar configuración de Ultralytics directamente en el archivo default.yaml
# Usamos 'find' para la ruta y añadimos 'runs' para save_dir
RUN sed -i "s,model:,model: /usr/src/app/models/yolov8l.pt," $(find /usr/local/lib/ -type f -name "default.yaml" | grep "ultralytics/cfg/default.yaml") && \
    echo "save_dir: /usr/src/app/runs" >> $(find /usr/local/lib/ -type f -name "default.yaml" | grep "ultralytics/cfg/default.yaml") || \
    echo "Advertencia: Archivo default.yaml de Ultralytics no encontrado o modificado, revisión manual necesaria."

# Descargar modelo Moondream usando Ollama
# Asegurarse de que Ollama esté funcionando para la descarga
RUN ollama serve & \
    sleep 10 && \
    ollama pull moondream && \
    pkill ollama

# Copiar tu código fuente (src/) a la carpeta de trabajo del contenedor
# COPY ["src/", "/usr/src/app/src/"]
COPY ["src/", "/usr/src/app/"]

# Dar permisos de ejecución a los scripts
RUN find /usr/src/app -type f -name "*.sh" -exec chmod +x {} \;

# Crear y copiar la carpeta de imágenes (separada del código fuente)
RUN mkdir -p /imagenes
COPY ./imagenes/ /imagenes/

# Copiar el script de arranque y darle permisos de ejecución
COPY ./start.sh /usr/src/app/start.sh
RUN chmod +x /usr/src/app/start.sh

# El ENTRYPOINT apunta a un script que está dentro de /usr/src/app
ENTRYPOINT ["/usr/src/app/start.sh"]