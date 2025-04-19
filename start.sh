#!/bin/bash
set -e

echo ">>> Starting Ollama server..."
OLLAMA_HOST=0.0.0.0 ollama serve &

echo ">>> Waiting for Ollama server to initialize..."
sleep 10

echo ">>> Pulling required models..."
ollama pull llama3
ollama pull gemma3:1b

echo ">>> Running your conversation script..."
python3 file1.py

# Keep the container alive if script exits
tail -f /dev/null
