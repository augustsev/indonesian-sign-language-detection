from fastapi import FastAPI
from pathlib import Path
# from app.routes import train
from app.routes import predict
from app.routes import kamus
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# app.include_router(train.router)
app.include_router(predict.router)
app.include_router(kamus.router)
app.mount(
    "/static",
    StaticFiles(directory=Path(__file__).parent / "static"),
    name="static"
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)