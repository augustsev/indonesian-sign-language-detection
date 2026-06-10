import os
from pathlib import Path

BASE_URL = os.getenv("BASE_URL", "http://127.0.0.1:8000/static")
STATIC_DIR = Path(__file__).parent.parent / "app" / "static"

for root, _, files in os.walk(STATIC_DIR):
    for file in files:
        rel_path = Path(root).relative_to(STATIC_DIR) / file
        print(f"{BASE_URL}/{rel_path.as_posix()}")
