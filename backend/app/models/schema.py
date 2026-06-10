from pydantic import BaseModel

class PredictionRequest(BaseModel):
    image_base64: str 

class PredictionResponse(BaseModel):
    result: str

class KamusSchema(BaseModel):
    id: int
    nama_gerakan: str
    deskripsi: str
    url_gambar: str | None = None

    class Config:
        orm_mode = True

class KamuskosakataSchema(BaseModel):
    id: int
    nama_gerakan: str
    deskripsi: str
    url_gambar: str | None = None

    class Config:
        orm_mode = True