from sqlalchemy import Column, Integer, String, Text, DateTime
from sqlalchemy.sql import func
from app.config.db import Base

class Kamus(Base):
    __tablename__ = "kamus_huruf"

    id = Column(Integer, primary_key=True, index=True)
    nama_gerakan = Column(String(100), nullable=False)
    deskripsi = Column(Text, nullable=True)
    url_gambar = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class Kamus_kosakata(Base):
    __tablename__ = "kamus_kosakata"

    id = Column(Integer, primary_key=True, index=True)
    nama_gerakan = Column(String(100), nullable=False)
    deskripsi = Column(Text, nullable=True)
    url_gambar = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
