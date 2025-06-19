# # app/main.py

# from schema.item import ClothingItem, Season, ClothingTag
# from fastapi import FastAPI, File, UploadFile
# from fastapi.middleware.cors import CORSMiddleware
# import cv2
# import numpy as np
# from ultralytics import YOLO
# from utils import get_dominant_color
# from typing import Optional
# from fastapi import Query
# import pandas as pd
# import os
# from datetime import datetime


# app = FastAPI()

# # Enable CORS for Flutter app access
# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=["*"],
#     allow_credentials=True,
#     allow_methods=["*"],
#     allow_headers=["*"],
# )



# # Load YOLOv8 model
# model = YOLO("yolov8n.pt")  # You can replace with a fine-tuned one

# seasons_db = []
# tagged_items = []

# #################### HOME ROUTES ####################
# @app.get("/")
# async def root():
#     return {"message": "Wearly backend running"}

# @app.post("/analyze/")
# async def analyze_clothing(file: UploadFile = File(...)):
#     # Read image from upload
#     contents = await file.read()
#     np_img = np.frombuffer(contents, np.uint8)
#     img = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

#     # Run YOLOv8 detection
#     results = model(img)[0]
#     detections = []

#     for box in results.boxes:
#         cls_id = int(box.cls[0])
#         conf = float(box.conf[0])
#         label = model.names[cls_id]
#         x1, y1, x2, y2 = map(int, box.xyxy[0])
#         cropped = img[y1:y2, x1:x2]

#         color = get_dominant_color(cropped)
#         detections.append({
#             "label": label,
#             "confidence": round(conf, 2),
#             "bounding_box": [x1, y1, x2, y2],
#             "dominant_color": color
#         })

#     return {"detections": detections}

# ##################### SEASON ROUTES ####################\

# @app.post("/add_season/")
# def add_season(season: Season):
#     if any(s['name'].lower() == season.name.lower() for s in seasons_db):
#         return {"message": f"Season '{season.name}' already exists."}

#     seasons_db.append(season.dict())
#     return {"message": "Season added successfully", "season": season}


# @app.get("/seasons/")
# def get_seasons():
#     return {"seasons": seasons_db}

# ###################### TAG ROUTES ####################

# @app.post("/tag/")
# async def tag_clothing(item: ClothingTag):
#     tagged_items.append(item.dict())
#     return {
#         "message": "Clothing item tagged successfully",
#         "data": item
#     }

# @app.get("/tags/")
# async def get_all_tags():
#     return {"items": tagged_items}


############################ Version 2 ############################
# app/main.py

# from schema.item import ClothingItem, Season, ClothingTag
# from fastapi import FastAPI, File, UploadFile, Query
# from fastapi.middleware.cors import CORSMiddleware
# import cv2
# import numpy as np
# from ultralytics import YOLO
# from utils import get_dominant_color
# from typing import Optional
# import pandas as pd
# import os
# import json
# from datetime import datetime

# app = FastAPI()

# # Enable CORS
# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=["*"],
#     allow_credentials=True,
#     allow_methods=["*"],
#     allow_headers=["*"],
# )

# # Load YOLOv8 model
# model = YOLO("yolov8n.pt")  # Replace with fine-tuned version if needed

# # Directories
# UPLOAD_DIR = "uploads"
# DATA_DIR = "data"
# TAGS_FILE = os.path.join(DATA_DIR, "tags.json")
# SEASONS_FILE = os.path.join(DATA_DIR, "seasons.json")

# # Ensure required directories exist
# os.makedirs(UPLOAD_DIR, exist_ok=True)
# os.makedirs(DATA_DIR, exist_ok=True)

# # Load existing data or initialize
# def load_json(path):
#     if os.path.exists(path):
#         with open(path, "r") as f:
#             return json.load(f)
#     return []

# def save_json(path, data):
#     with open(path, "w") as f:
#         json.dump(data, f, indent=4)

# # In-memory data
# tagged_items = load_json(TAGS_FILE)
# seasons_db = load_json(SEASONS_FILE)

# #################### HOME ROUTE ####################
# @app.get("/")
# async def root():
#     return {"message": "Wearly backend running"}

# #################### ANALYZE ####################
# @app.post("/analyze/")
# async def analyze_clothing(file: UploadFile = File(...)):
#     contents = await file.read()
#     np_img = np.frombuffer(contents, np.uint8)
#     img = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

#     # Save image with timestamp
#     timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
#     filename = f"{timestamp}_{file.filename}"
#     filepath = os.path.join(UPLOAD_DIR, filename)
#     cv2.imwrite(filepath, img)

#     # Run YOLO detection
#     results = model(img)[0]
#     detections = []

#     for box in results.boxes:
#         cls_id = int(box.cls[0])
#         conf = float(box.conf[0])
#         label = model.names[cls_id]
#         x1, y1, x2, y2 = map(int, box.xyxy[0])
#         cropped = img[y1:y2, x1:x2]
#         color = get_dominant_color(cropped)

#         detections.append({
#             "label": label,
#             "confidence": round(conf, 2),
#             "bounding_box": [x1, y1, x2, y2],
#             "dominant_color": color,
#             "image_path": filepath
#         })

#     return {"detections": detections}

# #################### SEASONS ####################
# @app.post("/add_season/")
# def add_season(season: Season):
#     if any(s['name'].lower() == season.name.lower() for s in seasons_db):
#         return {"message": f"Season '{season.name}' already exists."}
    
#     season_data = season.dict()
#     seasons_db.append(season_data)
#     save_json(SEASONS_FILE, seasons_db)

#     return {"message": "Season added successfully", "season": season_data}

# @app.get("/seasons/")
# def get_seasons():
#     return {"seasons": seasons_db}

# #################### TAGS ####################
# @app.post("/tag/")
# async def tag_clothing(item: ClothingTag):
#     item_data = item.dict()
#     tagged_items.append(item_data)
#     save_json(TAGS_FILE, tagged_items)

#     return {"message": "Clothing item tagged successfully", "data": item_data}

# @app.get("/tags/")
# async def get_all_tags():
#     return {"items": tagged_items}

############################ Version 3 ############################

from io import BytesIO
import os
import tempfile
from removebg import *
from fastapi import FastAPI, UploadFile
from ultralytics import YOLO
from PIL import Image
from fastapi import FastAPI, UploadFile
from fastapi.responses import JSONResponse
import shutil
from pathlib import Path
import logging
import python_weather
from recom_screenshot import RecOutfit
from fastapi.responses import FileResponse


# Configure the logger
logging.basicConfig(filename="app.log", level=logging.INFO, format="%(asctime)s [%(levelname)s] - %(message)s")


# Create a FastAPI application
app = FastAPI(debug=True,title='Fashion AI',summary='This API Provides Access to all Endpoints of Fashion AI Server')

def extract(source_path):
    model = YOLO("model//best.pt")
    results=model.predict(source=source_path, conf=0.4, save=False, line_width=2)
    class_names=['sunglass','hat','jacket','shirt','pants','shorts','skirt','dress','bag','shoe']

    source = Image.open(source_path)
    items_list=[]
    # Iterate through the detected items and save each one as a separate image
    for item in results:
        # Extract the bounding box coordinates
        x_min, y_min, x_max, y_max = item.boxes.xyxy[0]
        # Crop and save the detected item as a separate image
        detected_item = source.crop((float(x_min), float(y_min), float(x_max), float(y_max)))
        if class_names[int(item.boxes.cls.tolist()[0])].lower() not in ['sunglass','hat','bag']:
            items_list.append({class_names[int(item.boxes.cls.tolist()[0])]:detected_item})  
    return items_list

# Define a route to process images and remove the background
def remove_bg(img):
    print('inside')
    # Remove the image background using the "rembg" library
    removedBGimage = remove(img, True)
    print('removing')

    # Automatically crop the image
    croppedImage = autocrop_image(removedBGimage, 0)
    print('croping')
    # Resize the cropped image to a specific size (700 pixels in this case)
    resizedImage = resize_image(croppedImage, 700)
    print('resizing')
    # Create a new canvas with a specific size (1000x1000) and paste the image onto it
    combinedImage = resize_canvas(resizedImage, 1000, 1000)
    print('resizing canvas')
    return combinedImage

 
# Define an endpoint to receive and save the image
@app.post("/remove_background/")
async def remove_background(file: UploadFile):
    try:
        # Create a directory to save the uploaded files if it doesn't exist
        upload_dir = Path("temp")
        upload_dir.mkdir(parents=True, exist_ok=True)

        # Save the uploaded file to the local directory
        with open(upload_dir / file.filename, "wb") as image_file:
            shutil.copyfileobj(file.file, image_file)
        
        print('going in')
        image=remove_bg(Image.open(upload_dir / file.filename))
        print('bg removed')
        shutil.rmtree('temp',ignore_errors=True)
          # Save the PIL Image as JPEG in a temporary file
        with BytesIO() as temp_buffer:
            image.save(temp_buffer, format="PNG")
            temp_buffer.seek(0)
            
            # Create a temporary file and write the image data to it
            with tempfile.NamedTemporaryFile(delete=False, suffix=".png") as temp_file:
                temp_file.write(temp_buffer.read())
                temp_file_path = temp_file.name
        print('returning')
        return FileResponse(temp_file_path, media_type="image/jpeg", headers={"Content-Disposition": "attachment; filename=removed.png"})

    except Exception as e:
        logging.error("An error occurred: %s", str(e))
        return JSONResponse(content={"error": str(e)}, status_code=500)
    

# Define an endpoint to receive and save the image
@app.post("/extract/")
async def upload_file(file: UploadFile):
    try:
        # Create a directory to save the uploaded files if it doesn't exist
        upload_dir = Path("temp")
        upload_dir.mkdir(parents=True, exist_ok=True)

        # Save the uploaded file to the local directory
        with open(upload_dir / file.filename, "wb") as image_file:
            shutil.copyfileobj(file.file, image_file)
            
        items_list=extract(upload_dir / file.filename)
        images_list=[]
        for item in items_list:
            image_name=list(item.keys())[0]
            image=list(item.values())[0]
            image=remove_bg(image)
            image.save('{}.png'.format(image_name))
            logging.info(image_name)
            images_list.append({'name':image_name,'image':'image'}) # i want to return this image 
        
        shutil.rmtree('temp',ignore_errors=True)
        return JSONResponse(content={"message": images_list})
    except Exception as e:
        logging.error("An error occurred: %s", str(e))
        return JSONResponse(content={"error": str(e)}, status_code=500)
    
   
# Define an endpoint to receive and save the image
@app.get("/getweather/{area}")
async def getweather(area):
  # declare the client. the measuring unit used defaults to the metric system (celcius, km/h, etc.)
  async with python_weather.Client(unit=python_weather.IMPERIAL) as client:
    # fetch a weather forecast from a city
    weather = await client.get(area)
    temperature=weather.current.temperature
    temperature = (temperature - 32) * 5/9
    if temperature<25:
        season='winter'     
    else:
        season='summer'
    return JSONResponse(content={"temperature": temperature,"season":season,'description':weather.current.description,'kind':str(weather.current.kind)})


@app.post('/get_recommendation')
async def get_recommendations(file: UploadFile,Gender,Ocassion,Season):
    
    # Create a directory to save the uploaded files if it doesn't exist
    upload_dir = Path("temp")
    upload_dir.mkdir(parents=True, exist_ok=True)

    # Save the uploaded file to the local directory
    with open(upload_dir / file.filename, "wb") as image_file:
        shutil.copyfileobj(file.file, image_file)
    input_image={'image_path':upload_dir / file.filename,'Image Tags':{'Gender':Gender.lower(),'Season':Season.lower(),'Occasion':Ocassion.lower()}}
    print(input_image)
    recoutfit=RecOutfit(input_image,'Wardrobe')
    recommended_outfit,image=recoutfit.controller()
   
    # Save the PIL Image as JPEG in a temporary file
    with BytesIO() as temp_buffer:
        image.save(temp_buffer, format="JPEG")
        temp_buffer.seek(0)
        
        # Create a temporary file and write the image data to it
        with tempfile.NamedTemporaryFile(delete=False, suffix=".jpg") as temp_file:
            temp_file.write(temp_buffer.read())
            temp_file_path = temp_file.name
    return FileResponse(temp_file_path, media_type="image/jpeg", headers={"Content-Disposition": "attachment; filename=recommended.png"})


@app.post('/get_recommendations_collage')
async def get_recommendations_collage(file: UploadFile,Gender,Ocassion,Season):
    
    # Create a directory to save the uploaded files if it doesn't exist
    upload_dir = Path("temp")
    upload_dir.mkdir(parents=True, exist_ok=True)

    # Save the uploaded file to the local directory
    with open(upload_dir / file.filename, "wb") as image_file:
        shutil.copyfileobj(file.file, image_file)

    items_list=extract(upload_dir / file.filename)
    images_list=[]
    for item in items_list:
        image_name=list(item.keys())[0]
        image=list(item.values())[0]
        image=remove_bg(image)
        image.save('temp.png')
        
        input_image={'image_path':upload_dir / file.filename,'Image Tags':{'Gender':Gender.lower(),'Season':Season.lower(),'Occasion':Ocassion.lower()}}
        print(input_image)
        recoutfit=RecOutfit(input_image,'Wardrobe')
        recommended_outfit,rec_image=recoutfit.controller()
        images_list.append(rec_image)

    try:
        os.remove('temp.png')
    except:
        pass
    print(images_list[0])
    
    #combine images and make a collage
    total_width = sum([img.width for img in images_list])
    max_height = max([img.height for img in images_list])
    
    
    # Create an empty canvas for the collage
    collage = Image.new("RGB", (total_width, max_height))
    x_offset = 0  # Starting position for the first image
    for img in images_list:
        collage.paste(img, (x_offset, 0))
        x_offset += img.width

    
    

    
    # Save the PIL Image as JPEG in a temporary file
    with BytesIO() as temp_buffer:
        collage.save(temp_buffer, format="JPEG")
        temp_buffer.seek(0)
        
        # Create a temporary file and write the image data to it
        with tempfile.NamedTemporaryFile(delete=False, suffix=".jpg") as temp_file:
            temp_file.write(temp_buffer.read())
            temp_file_path = temp_file.name
    return FileResponse(temp_file_path, media_type="image/jpeg", headers={"Content-Disposition": "attachment; filename=recommended.png"})


# if __name__ == "__main__":
#     import uvicorn
#     uvicorn.run(app, host="0.0.0.0", port=8000)