from fastapi import APIRouter, File, UploadFile
from ultralytics import YOLO
import cv2
import numpy as np
from io import BytesIO

router = APIRouter()


model = YOLO("otak_ai/yolov8-update-kosakata3/weights/best.pt")  

@router.post("/predict")
async def predict_image(file: UploadFile = File(...)):
    contents = await file.read()
    npimg = np.frombuffer(contents, np.uint8)
    image = cv2.imdecode(npimg, cv2.IMREAD_COLOR)

    results = model(image)
    predictions = results[0].boxes.data.cpu().numpy()

    labels = results[0].names
    classes = [
        labels[int(cls)].replace("_", "-")
        for cls in results[0].boxes.cls
    ]

    return {"predicted": classes}
