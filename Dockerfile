FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHON_VERSION=3.8 

# Install base tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    wget \
    gnupg \
    curl \
    software-properties-common \
    python${PYTHON_VERSION} \
    python3-pip \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

# Install Python packages
RUN pip3 install --upgrade pip && pip3 install requests

# Install Ollama
ARG DOWNLOAD_URL="https://ollama.com/install.sh"
RUN wget $DOWNLOAD_URL -O install1.sh && \
    chmod +x install1.sh && \
    ./install1.sh

# Start Ollama server and preload models before running the script
CMD OLLAMA_HOST=0.0.0.0 ollama serve & \
    sleep 10 && \
    ollama pull llama3 && \
    ollama pull gemma3:1b && \
    python3 file1.py
