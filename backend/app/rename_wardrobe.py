import json
from pathlib import Path

BASE_DIR = Path(__file__).parent
WARDROBE_DIR = BASE_DIR / "wardrobe"
METADATA_FILE = BASE_DIR / "wardrobe_metadata.json"

with open(METADATA_FILE, "r", encoding="utf-8") as f:
    metadata = json.load(f)

filtered = [
    item for item in metadata
    if (WARDROBE_DIR / item.get("filename", "")).exists()
]

print(f"Original entries: {len(metadata)}")
print(f"Entries after removing missing files: {len(filtered)}")

with open(METADATA_FILE, "w", encoding="utf-8") as f:
    json.dump(filtered, f, indent=2)

print("Updated wardrobe_metadata.json with only existing files.")