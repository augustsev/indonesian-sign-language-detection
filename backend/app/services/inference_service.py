from ultralytics import YOLO
import cv2
import numpy as np
import os

MODEL_PATH = os.path.join(
    "otak_ai",
    "yolov8-update-kosakata3",
    "weights",
    "best.pt"
)

model = YOLO(MODEL_PATH)

def format_label(label: str) -> str:
    return label.replace("_", "-")

def predict_image(image_bytes):
    nparr = np.frombuffer(image_bytes, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    results = model(img)

    detections = results[0].boxes.data.tolist()
    class_names = model.names

    if len(detections) == 0:
        return "Tidak ada gesture terdeteksi"

    first = detections[0]
    class_id = int(first[5])
    confidence = first[4]
    label = class_names[class_id]
    label = format_label(label)

    return {"label": label, "confidence": float(confidence)}
