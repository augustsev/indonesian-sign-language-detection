# BISINDO Recognition API

Backend API untuk pengenalan Bahasa Isyarat Indonesia (BISINDO) menggunakan YOLOv8 dan FastAPI.

## Fitur
- Deteksi 26 huruf alfabet BISINDO
- Deteksi 15 kosakata BISINDO
- REST API menggunakan FastAPI
- Integrasi PostgreSQL

## Dataset
- Total kelas: 41
- 26 huruf alfabet
- 15 kosakata
- Total gambar: 7.586

## Teknologi
- Python
- FastAPI
- PostgreSQL
- SQLAlchemy
- YOLOv8

## Menjalankan

pip install -r requirements.txt

uvicorn app.main:app --reload