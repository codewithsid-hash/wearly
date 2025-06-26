import os
# --- CPU Execution Configuration ---
# This line MUST be at the top, before importing any ML libraries.
os.environ["CUDA_VISIBLE_DEVICES"] = "-1"

import json
import uuid
import shutil
import logging
import random
import time
import base64
from pathlib import Path
from io import BytesIO

from fastapi import FastAPI, UploadFile, Form, HTTPException
from fastapi.responses import JSONResponse, FileResponse
from PIL import Image
from rembg import remove
import numpy as np
import python_weather
import asyncio
import cv2
from ultralytics import YOLO

from tensorflow.keras.models import Model
from tensorflow.keras.applications import VGG16
from tensorflow.keras.applications.vgg16 import preprocess_input
from sklearn.metrics.pairwise import cosine_similarity
from pydantic import BaseModel

from fastapi.staticfiles import StaticFiles

# --- Basic Setup & Configuration ---

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] - %(message)s")

BASE_DIR = Path(__file__).parent
UPLOAD_DIR = BASE_DIR / "temp_uploads"
WARDROBE_DIR = BASE_DIR / "wardrobe"
METADATA_FILE = BASE_DIR / "wardrobe_metadata.json"
YOLO_MODEL_PATH = BASE_DIR / "models" / "best.pt" 



ALLOWED_CLOTHING_TYPES = ['shirt', 'pants', 't-shirt', 'shoe'] # Added 'shoe' for new extractor
# Define clothing type relationships
CLOTHING_RELATIONSHIPS = {
    "pants": ["shirt", "t-shirt", "shoe"],
    "shirt": ["pants"],
    "t-shirt": ["pants"],
    "shoe": ["pants"]
}


UPLOAD_DIR.mkdir(exist_ok=True)
WARDROBE_DIR.mkdir(exist_ok=True)
(BASE_DIR / "model").mkdir(exist_ok=True) # Ensure model directory exists

# --- Model Loading (Cached Globally) ---

def load_vgg_model():
    """Loads VGG16 with 'avg' pooling for consistent 512-feature vectors."""
    try:
        base_model = VGG16(weights='imagenet', include_top=False, pooling='avg', input_shape=(224, 224, 3))
        vgg_model = Model(inputs=base_model.input, outputs=base_model.output)
        logging.info("VGG16 model with 'avg' pooling (512 features) loaded successfully.")
        return vgg_model
    except Exception as e:
        logging.error(f"Fatal Error: Could not load VGG16 model. {e}")
        raise RuntimeError(f"Could not load VGG16 model: {e}") from e

def load_yolo_model(model_path: Path):
    """Loads the YOLOv8 segmentation model."""
    if not model_path.exists():
        logging.error(f"YOLO model not found at {model_path}.")
        logging.error("Please download a trained YOLOv8 segmentation model and place it as 'model/best.pt'")
        raise FileNotFoundError(f"YOLO model not found at {model_path}")
    try:
        model = YOLO(model_path)
        logging.info(f"YOLOv8 model loaded successfully from {model_path}.")
        return model
    except Exception as e:
        logging.error(f"Fatal Error: Could not load YOLO model. {e}")
        raise RuntimeError(f"Could not load YOLO model: {e}") from e

vgg = load_vgg_model()
yolo_model = load_yolo_model(YOLO_MODEL_PATH)


# --- Image Processing & Metadata Helper Functions ---

def precise_extract(source_path: Path, model: YOLO):
    """
    Enhanced clothing extraction with:
    - YOLOv8 segmentation for precise masks
    - Class-specific processing
    - Sole preservation for shoes
    """
    # Run inference on the source image
    results = model(source_path)
    source_img = Image.open(source_path).convert("RGB") # Ensure it's RGB
    source_array = np.array(source_img)
    items_list = []

    if not results or not results[0].masks:
        logging.warning("YOLO model did not detect any items with masks.")
        return []

    for r in results:
        for i, cls in enumerate(r.boxes.cls):
            class_id = int(cls)
            class_name = r.names[class_id].lower()

            # Skip non-clothing items for wardrobe purposes
            if class_name in ['sunglass', 'hat', 'bag', 'person']:
                continue

            # Get segmentation mask, resize to match original image
            mask = cv2.resize(r.masks.data[i].cpu().numpy(), (source_array.shape[1], source_array.shape[0])).astype(np.uint8)

            # Apply morphological operations to refine the mask
            kernel = np.ones((3,3), np.uint8)
            mask = cv2.dilate(mask, kernel, iterations=1)
            mask = cv2.erode(mask, kernel, iterations=1)

            # Special handling for shoes to preserve soles
            if class_name == 'shoe':
                hsv = cv2.cvtColor(source_array, cv2.COLOR_RGB2HSV)
                # Define a broad range for white/light grey soles
                lower_white = np.array([0,0,180])
                upper_white = np.array([180,40,255])
                sole_mask = cv2.inRange(hsv, lower_white, upper_white)
                # Combine the YOLO mask with the color-based sole mask
                mask = cv2.bitwise_or(mask, sole_mask)

            # Create an RGBA image with a transparent background
            result_rgba = np.zeros((source_array.shape[0], source_array.shape[1], 4), dtype=np.uint8)
            result_rgba[:, :, :3] = source_array
            result_rgba[:, :, 3] = mask * 255 # Apply mask to alpha channel

            items_list.append({
                "class": class_name,
                "image": Image.fromarray(result_rgba)
            })

    return items_list

def read_metadata():
    if not METADATA_FILE.exists(): return []
    try:
        with open(METADATA_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    except (json.JSONDecodeError, FileNotFoundError):
        return []

def write_metadata(data):
    """Atomically writes data to the metadata file with retries."""
    temp_path = METADATA_FILE.with_suffix('.json.tmp')
    for i in range(3):
        try:
            with open(temp_path, 'w', encoding="utf-8") as f:
                json.dump(data, f, indent=4)
            shutil.move(temp_path, METADATA_FILE)
            return
        except (IOError, PermissionError) as e:
            logging.warning(f"Metadata write attempt {i+1} failed: {e}. Retrying...")
            time.sleep(0.1)
    logging.error("Failed to write metadata after multiple retries.")

def safe_remove(image: Image.Image) -> Image.Image:
    """Fallback background removal for items not detected by YOLO."""
    try:
        return remove(image)
    except Exception as e:
        logging.warning(f"Background removal with rembg failed: {e}. Using original image.")
        return image

def compress_features(features: list) -> list:
    """Compresses feature vectors to reduce storage size."""
    return [float(f"{x:.4f}") for x in features]

def extract_color_histogram(img: Image.Image) -> list:
    if img.mode != 'RGB':
        img = img.convert('RGB')
    small_img = img.resize((64, 64))
    hist = np.array(small_img.histogram())
    if np.sum(hist) == 0: return [0.0] * 768 # Handle pure black/transparent images
    normalized_hist = hist / np.sum(hist)
    return compress_features(normalized_hist.tolist())

def extract_features(img: Image.Image, model) -> tuple[list, list]:
    """Extracts both VGG16 features and color features."""
    if img.mode != 'RGB':
        img = img.convert('RGB')
    
    vgg_img = img.resize((224, 224))
    img_array = np.array(vgg_img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array = preprocess_input(img_array)
    vgg_features = model.predict(img_array, verbose=False)
    if vgg_features.size == 0:
        raise ValueError("VGG feature extraction returned an empty array.")

    color_features = extract_color_histogram(img)
    
    return compress_features(vgg_features.flatten().tolist()), color_features
    
def format_item_for_response(item: dict) -> dict:
    if not item: return None
    return {k: v for k, v in item.items() if k not in ['features', 'color_features']}
    
def get_next_item_name(clothing_type: str, metadata: list) -> str:
    count = 1
    for item in metadata:
        if item.get('name', '').startswith(clothing_type):
            count += 1
    return f"{clothing_type}{count}"

# --- Startup and Shutdown Events ---

def validate_metadata():
    logging.info("Validating wardrobe metadata...")
    metadata = read_metadata()
    if not metadata: return
    requires_write = False
    for item in metadata:
        if 'popularity' not in item:
            item['popularity'] = 0
            requires_write = True
        if 'color_features' not in item:
            try:
                img_path = WARDROBE_DIR / item['filename']
                if img_path.exists():
                    img = Image.open(img_path)
                    item['color_features'] = extract_color_histogram(img)
                    requires_write = True
                else:
                    item['color_features'] = []
            except Exception as e:
                logging.error(f"Could not generate color features for {item.get('id')}: {e}")
                item['color_features'] = []
        if item.get('clothing_type') not in ALLOWED_CLOTHING_TYPES:
            logging.warning(f"Invalid clothing type found in metadata: '{item.get('clothing_type')}' for item ID {item.get('id')}.")
    if requires_write:
        logging.info("Updating metadata with new fields.")
        write_metadata(metadata)
    else:
        logging.info("Metadata validation complete.")

def warm_up_all_models():
    logging.info("Warming up VGG16 model...")
    try:
        test_img_vgg = Image.new('RGB', (224, 224), color='blue')
        extract_features(test_img_vgg, vgg)
        logging.info("VGG16 model is warmed up.")
    except Exception as e:
        logging.error(f"An error occurred during VGG16 warm-up: {e}")

    logging.info("Warming up YOLOv8 model...")
    try:
        # Create a dummy image file for YOLO warmup
        dummy_path = UPLOAD_DIR / "warmup.png"
        Image.new('RGB', (640, 640), color='green').save(dummy_path)
        precise_extract(dummy_path, yolo_model)
        dummy_path.unlink() # Clean up the dummy file
        logging.info("YOLOv8 model is warmed up and ready.")
    except Exception as e:
        logging.error(f"An error occurred during YOLO model warm-up: {e}")

app = FastAPI(
    title="Fashion AI Assistant",
    description="API for managing a virtual wardrobe, getting outfit recommendations, and precise clothing extraction.",
    version="6.0.0-segmentation"
)


app.mount("/wardrobe", StaticFiles(directory="wardrobe"), name="wardrobe")

@app.on_event("startup")
def startup_event():
    validate_metadata()
    warm_up_all_models()

@app.on_event("shutdown")
def cleanup():
    logging.info("Shutting down...")
    if UPLOAD_DIR.exists(): shutil.rmtree(UPLOAD_DIR)

# Remaining helper functions and endpoints from the original file go here...
# (Pydantic Models, Core Recommendation Logic, Weather Logic, API Endpoints)
# --- Pydantic Models ---
class UpdateStatus(BaseModel):
    is_washed: bool = None
    is_favorite: bool = None

# --- Core Recommendation Logic ---
def color_similarity(hist1, hist2):
    if not isinstance(hist1, np.ndarray): hist1 = np.array(hist1)
    if not isinstance(hist2, np.ndarray): hist2 = np.array(hist2)
    if hist1.size == 0 or hist2.size == 0 or np.all(hist1 == hist1[0]) or np.all(hist2 == hist2[0]): return 0.0
    return np.corrcoef(hist1, hist2)[0, 1]

def combined_similarity(item1, item2):
    vgg_sim = weighted_similarity(item1['features'], item2['features'])
    color_sim = color_similarity(item1['color_features'], item2['color_features'])
    if np.isnan(color_sim): color_sim = 0.0
    return 0.7 * vgg_sim + 0.3 * color_sim

def weighted_similarity(vec1, vec2):
    vec1, vec2 = np.array(vec1), np.array(vec2)
    norm1, norm2 = np.linalg.norm(vec1), np.linalg.norm(vec2)
    if norm1 == 0 or norm2 == 0: return 0.0
    cosine = cosine_similarity([vec1], [vec2])[0][0]
    magnitude_ratio = min(norm1, norm2) / max(norm1, norm2)
    return 0.7 * cosine + 0.3 * magnitude_ratio

def get_single_outfit_recommendation(input_item, wardrobe):
    input_type = input_item['clothing_type']
    compatible_types = CLOTHING_RELATIONSHIPS.get(input_type, [])
    if not compatible_types:
        compatible_types = [t for t in ALLOWED_CLOTHING_TYPES if t != input_type]
    candidates = [item for item in wardrobe if item['is_washed']]
    if not candidates:
        logging.warning("No clean items found. Falling back to all items.")
        candidates = list(wardrobe)
    # Tiered filtering logic...
    filtered = [item for item in candidates if item['gender'] == input_item['gender'] and item['occasion'] == input_item['occasion'] and item['season'] == input_item['season'] and item['clothing_type'] != input_item.get('clothing_type') and item['id'] != input_item.get('id')]
    if not filtered:
        filtered = [item for item in candidates if item['gender'] == input_item['gender'] and item['season'] == input_item['season'] and item['clothing_type'] != input_item.get('clothing_type') and item['id'] != input_item.get('id')]
    if not filtered:
        filtered = [item for item in candidates if item['gender'] == input_item['gender'] and item['clothing_type'] != input_item.get('clothing_type') and item['id'] != input_item.get('id')]
    if not filtered:
        filtered = sorted([item for item in wardrobe if item['season'] == input_item['season']], key=lambda x: x.get('popularity', 0), reverse=True)[:5]
    
    filtered = [item for item in filtered if item['clothing_type'] in compatible_types]
    recommendations = {}
    for item in filtered:
        similarity = combined_similarity(input_item, item)
        ctype = item['clothing_type']
        if ctype not in recommendations or similarity > recommendations[ctype]['similarity']:
            recommendations[ctype] = {"item": item, "similarity": similarity}
    return [format_item_for_response(rec['item']) for rec in recommendations.values()]

# --- Weather Logic ---
def determine_season(temp_celsius: float, humidity: float) -> str:
    if temp_celsius < 10: return "winter"
    if temp_celsius > 25: return "summer"
    if 15 <= temp_celsius <= 25 and humidity > 70: return "monsoon"
    return "autumn/spring"

# --- API Endpoints ---

@app.get("/")
def read_root(): return {"status": "Fashion AI Assistant is running."}

@app.get("/wardrobe/total")
def get_wardrobe_count():
    metadata = read_metadata()
    return {"total_items": len(metadata)}

# Total count of outfits in the wardrobe
@app.get("/outfits/count")
def count_selected_outfits():
    metadata = read_metadata()
    selected_categories = {"pants", "shirt", "t-shirt"}  # Use set for faster lookup
    count = sum(1 for item in metadata if item.get("clothing_type", "").lower() in selected_categories)
    return {"total_outfits": count}

@app.post("/extract/")
async def extract_items_from_upload(file: UploadFile):
    """
    Upload an image and get a list of precisely extracted clothing items.
    Returns a list of items with their class and Base64-encoded transparent image.
    """
    temp_path = UPLOAD_DIR / f"{uuid.uuid4()}_{file.filename}"
    try:
        with temp_path.open("wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        
        # Use the enhanced YOLOv8 extraction
        extracted_items = precise_extract(temp_path, yolo_model)
        
        if not extracted_items:
            raise HTTPException(status_code=404, detail="No clothing items could be detected in the image.")
            
        response_list = []
        for item in extracted_items:
            buffered = BytesIO()
            item["image"].save(buffered, format="PNG")
            img_str = base64.b64encode(buffered.getvalue()).decode("utf-8")
            response_list.append({
                "class_name": item["class"],
                "image_base64": img_str
            })
            
        return JSONResponse(content={"message": "Extraction successful", "items": response_list})
        
    except Exception as e:
        logging.exception("Operation failed during extraction.")
        raise HTTPException(status_code=500, detail=f"An internal server error occurred: {e}") from e
    finally:
        if temp_path.exists(): temp_path.unlink()

@app.get("/wardrobe/")
def get_wardrobe(): return [format_item_for_response(item) for item in read_metadata()]

@app.post("/upload-clothing/")
async def upload_clothing(file: UploadFile, clothing_type: str = Form(...), gender: str = Form(...), occasion: str = Form(...), season: str = Form(...)):
    if clothing_type.lower() not in ALLOWED_CLOTHING_TYPES:
        raise HTTPException(status_code=400, detail=f"Upload failed. Only {', '.join(ALLOWED_CLOTHING_TYPES)} are allowed.")

    temp_path = UPLOAD_DIR / f"{uuid.uuid4()}_{file.filename}"
    try:
        with open(temp_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        original_image = Image.open(temp_path)
        # Using the fallback remover for this endpoint. For precise extraction, use /extract/
        processed_image = safe_remove(original_image)
        
        vgg_features, color_features = extract_features(processed_image, vgg)
        item_id = str(uuid.uuid4())
        metadata = read_metadata()
        item_name = get_next_item_name(clothing_type.lower(), metadata)
        
        image_filename = f"{item_id}.png"
        wardrobe_path = WARDROBE_DIR / image_filename
        processed_image.save(wardrobe_path, "PNG")

        new_item_metadata = {
            "id": item_id, "name": item_name, "filename": image_filename, 
            "clothing_type": clothing_type.lower(), "gender": gender.lower(), 
            "occasion": occasion.lower(), "season": season.lower(),
            "features": vgg_features, "color_features": color_features,
            "is_washed": True, "is_favorite": False, "popularity": 0
        }
        metadata.append(new_item_metadata)
        write_metadata(metadata)
        
        return JSONResponse(content={"message": "Clothing item added successfully!", "item_details": format_item_for_response(new_item_metadata)})
    except Exception as e:
        logging.exception("Operation failed during clothing upload.")
        raise HTTPException(status_code=500, detail="An internal server error occurred.") from e
    finally:
        if temp_path.exists(): temp_path.unlink()

@app.patch("/wardrobe/item/{item_id}")
def update_item_status(item_id: str, status: UpdateStatus):
    metadata = read_metadata()
    item_to_update = next((item for item in metadata if item['id'] == item_id), None)
    if not item_to_update:
        raise HTTPException(status_code=404, detail="Item not found")
    
    if status.is_washed is not None: item_to_update['is_washed'] = status.is_washed
    if status.is_favorite is not None: item_to_update['is_favorite'] = status.is_favorite
        
    write_metadata(metadata)
    return {"message": f"Item {item_id} status updated.", "updated_item": format_item_for_response(item_to_update)}

@app.post("/recommend-from-upload/")
async def recommend_from_upload(file: UploadFile, input_clothing_type: str = Form(...), gender: str = Form(...), occasion: str = Form(...), season: str = Form(...)):
    temp_path = UPLOAD_DIR / f"{uuid.uuid4()}_{file.filename}"
    try:
        with open(temp_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        
        original_image = Image.open(temp_path)
        processed_image = safe_remove(original_image)
        vgg_features, color_features = extract_features(processed_image, vgg)
        
        input_item_profile = {
            "clothing_type": input_clothing_type.lower(), "gender": gender.lower(),
            "occasion": occasion.lower(), "season": season.lower(),
            "features": vgg_features, "color_features": color_features
        }
        
        wardrobe = read_metadata()
        recommended_outfit = get_single_outfit_recommendation(input_item_profile, wardrobe)
        
        if not recommended_outfit:
            return JSONResponse(content={"message": "No suitable items found to complete the outfit."})

        return JSONResponse(content={"input_item": format_item_for_response(input_item_profile), "recommended_outfit": recommended_outfit})
    except Exception as e:
        logging.exception("Operation failed during outfit recommendation from upload.")
        raise HTTPException(status_code=500, detail="An internal server error occurred.") from e
    finally:
        if temp_path.exists(): temp_path.unlink()

@app.post("/recommend-from-wardrobe/")
def recommend_from_wardrobe(item_id: str = Form(...)):
    wardrobe = read_metadata()
    input_item = next((item for item in wardrobe if item['id'] == item_id), None)
    if not input_item: raise HTTPException(status_code=404, detail="Input item not found.")
    
    input_item['popularity'] = input_item.get('popularity', 0) + 1
    write_metadata(wardrobe)

    recommended_outfit = get_single_outfit_recommendation(input_item, wardrobe)
    if not recommended_outfit: return JSONResponse(content={"message": "No suitable items found."})
    return JSONResponse(content={"input_item": format_item_for_response(input_item), "recommended_outfit": recommended_outfit})

@app.get("/recommend-by-weather/")
async def recommend_by_weather(city: str, gender: str, occasion: str):
    try:
        async with python_weather.Client(unit=python_weather.METRIC) as client:
            weather = await client.get(city)
            season = determine_season(weather.current.temperature, weather.current.humidity)
            logging.info(f"Weather for {city}: {weather.current.temperature}°C, {weather.current.humidity}%. Detected season: '{season}'.")
            
            wardrobe = read_metadata()
            available_mains = [item for item in wardrobe if item['is_washed'] and item['clothing_type'] in ALLOWED_CLOTHING_TYPES and item['gender'] == gender.lower() and item['season'] == season]
            
            if not available_mains:
                raise HTTPException(status_code=400, detail=f"No main items for current weather ({season}) in wardrobe.")

            num_to_select = min(5, len(available_mains))
            selected_mains = random.sample(available_mains, k=num_to_select)
            
            weekly_plan = []
            
            for i, main_item in enumerate(selected_mains):
                main_item_copy = main_item.copy()
                main_item_copy['occasion'] = occasion.lower()
                outfit_complements = get_single_outfit_recommendation(main_item_copy, wardrobe)
                full_outfit = [format_item_for_response(main_item)] + outfit_complements
                weekly_plan.append({f"day_{i+1}_outfit": full_outfit})
                
            return JSONResponse(content={"city": city, "detected_season": season, "weekly_recommendations": weekly_plan})
    except Exception as e:
        logging.exception("Operation failed during weather recommendation.")
        raise HTTPException(status_code=500, detail=f"Could not get weather or generate recommendation: {e}") from e

@app.get("/wardrobe/{filename}")
async def get_wardrobe_image(filename: str):
    image_path = WARDROBE_DIR / filename
    if not image_path.is_file(): raise HTTPException(status_code=404, detail="File not found")
    return FileResponse(str(image_path))
