from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.orm import Session
from app.config.db import get_db
from app.models import models_kamus as models
from app.models.schema import KamusSchema, KamuskosakataSchema
from typing import List
import os
from pathlib import Path

router = APIRouter(
    prefix="/kamus",
    tags=["Kamus"]
)

@router.get("/", response_model=List[KamusSchema])
def get_kamus(request: Request, db: Session = Depends(get_db)):
    base_url = str(request.base_url).rstrip("/")
    kamus_data = db.query(models.Kamus).all()

    for item in kamus_data:
        if item.url_gambar and not item.url_gambar.startswith("http"):
            item.url_gambar = f"{base_url}{item.url_gambar}"
    return kamus_data


@router.get("/kosakata", response_model=List[KamuskosakataSchema])
def get_kosakata(request: Request, db: Session = Depends(get_db)):
    base_url = str(request.base_url).rstrip("/")
    kosakata_data = (
        db.query(models.Kamus_kosakata)
        .order_by(models.Kamus_kosakata.nama_gerakan.asc())
        .all()
    )

    for item in kosakata_data:
        if item.url_gambar and not item.url_gambar.startswith("http"):
            item.url_gambar = f"{base_url}{item.url_gambar}"
    return kosakata_data


@router.get("/daftar-gambar")
def get_static_image_urls(request: Request):
    base_url = str(request.base_url).rstrip("/")
    static_url = f"{base_url}/static"
    STATIC_DIR = Path(__file__).resolve().parent.parent / "static"


    urls = []
    for root, _, files in os.walk(STATIC_DIR):
        for file in files:
            rel_path = Path(root).relative_to(STATIC_DIR) / file
            urls.append(f"{static_url}/{rel_path.as_posix()}")
    return {"urls": urls}

@router.get("/daftar-gambar-kosakata")
def get_kosakata_image_urls(request: Request):
    base_url = str(request.base_url).rstrip("/")
    static_url = f"{base_url}/static/kamus/kosakata"
    STATIC_DIR = Path(__file__).resolve().parent.parent / "static" / "kamus" / "kosakata"

    urls = []
    if STATIC_DIR.exists():
        for root, _, files in os.walk(STATIC_DIR):
            for file in files:
                rel_path = Path(root).relative_to(Path(__file__).resolve().parent.parent / "static")
                urls.append(f"{static_url}/static/{rel_path.as_posix()}/{file}")
    else:
        return {"message": "Folder kosakata tidak ditemukan"}

    return {"urls": urls}
