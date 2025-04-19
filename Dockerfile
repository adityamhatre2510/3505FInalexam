FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHON_VERSION=3.8

# Install system dependencies and Python
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        wget \
        gnupg \
        curl \
        software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-distutils && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python${PYTHON_VERSION} && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1 && \
    ln -s /usr/local/bin/pip3 /usr/bin/pip3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app
COPY . /app

# Install Python packages
RUN pip3 install --upgrade pip && pip3 install requests

# Install Ollama
ARG DOWNLOAD_URL="https://ollama.com/install.sh"
RUN wget $DOWNLOAD_URL -O install1.sh && \
    chmod +x install1.sh && \
    ./install1.sh

# Add startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

CMD ["/app/start.sh"]
