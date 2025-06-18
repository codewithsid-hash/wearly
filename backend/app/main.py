# app/main.py

from schema.item import ClothingItem, Season, ClothingTag
from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import cv2
import numpy as np
from ultralytics import YOLO
from utils import get_dominant_color
from typing import Optional
from fastapi import Query
import pandas as pd
import os
from datetime import datetime


app = FastAPI()

# Enable CORS for Flutter app access
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)



# Load YOLOv8 model
model = YOLO("yolov8n.pt")  # You can replace with a fine-tuned one

seasons_db = []
tagged_items = []

#################### HOME ROUTES ####################
@app.get("/")
async def root():
    return {"message": "Wearly backend running"}

@app.post("/analyze/")
async def analyze_clothing(file: UploadFile = File(...)):
    # Read image from upload
    contents = await file.read()
    np_img = np.frombuffer(contents, np.uint8)
    img = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

    # Run YOLOv8 detection
    results = model(img)[0]
    detections = []

    for box in results.boxes:
        cls_id = int(box.cls[0])
        conf = float(box.conf[0])
        label = model.names[cls_id]
        x1, y1, x2, y2 = map(int, box.xyxy[0])
        cropped = img[y1:y2, x1:x2]

        color = get_dominant_color(cropped)
        detections.append({
            "label": label,
            "confidence": round(conf, 2),
            "bounding_box": [x1, y1, x2, y2],
            "dominant_color": color
        })

    return {"detections": detections}

##################### SEASON ROUTES ####################\

@app.post("/add_season/")
def add_season(season: Season):
    if any(s['name'].lower() == season.name.lower() for s in seasons_db):
        return {"message": f"Season '{season.name}' already exists."}

    seasons_db.append(season.dict())
    return {"message": "Season added successfully", "season": season}


@app.get("/seasons/")
def get_seasons():
    return {"seasons": seasons_db}

###################### TAG ROUTES ####################

@app.post("/tag/")
async def tag_clothing(item: ClothingTag):
    tagged_items.append(item.dict())
    return {
        "message": "Clothing item tagged successfully",
        "data": item
    }

@app.get("/tags/")
async def get_all_tags():
    return {"items": tagged_items}