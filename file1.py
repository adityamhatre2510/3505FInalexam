import requests
import json
import time
from datetime import datetime

url = "http://localhost:11434/api/generate"
headers = {"Content-Type": "application/json"}

model1 = "llama3"
model2 = "gemma3:1b"

message = "Hello, who are you?"
num_turns = 6

log_path = "conversation_log.txt"

with open(log_path, "w") as log:
    log.write(f"Conversation started at {datetime.now()}\n")
    log.write(f"Initial Prompt: {message}\n")

    for turn in range(num_turns):
        current_model = model1 if turn % 2 == 0 else model2
        print(f"\n--- Turn {turn + 1} ({current_model}) ---")

        data = {
            "model": current_model,
            "prompt": message,
            "stream": False
        }

        try:
            response = requests.post(url, headers=headers, data=json.dumps(data))
            response.raise_for_status()
            message = response.json().get("response", "").strip()
            print(f"{current_model}: {message}")

            log.write(f"\n[{current_model}]: {message}\n")
            time.sleep(1)

        except requests.exceptions.RequestException as e:
            error_message = f"Error during turn {turn + 1}: {e}"
            print(error_message)
            log.write(f"\n{error_message}\n")
            break
