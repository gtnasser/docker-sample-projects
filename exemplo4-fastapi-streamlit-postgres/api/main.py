# api/main.py
from datetime import date
import os
from typing import List

from pydantic import BaseModel
from sqlalchemy import create_engine, Column, Integer, String, Float, Date, func, text
from sqlalchemy.orm import sessionmaker, declarative_base, Session

from fastapi import FastAPI, Depends


# Postgres DB
DATABASE_URL = os.environ.get("DATABASE_URL")
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()


# SQLAlchemy Model
class VendaDB(Base):
    __tablename__ = "vendas"

    id = Column(Integer, primary_key=True, index=True)
    data_venda = Column(Date)
    produto = Column(String)
    categoria = Column(String)
    valor = Column(Float)
    quantidade = Column(Integer)


# Pydantic Model
class Venda(BaseModel):
    id: int
    data_venda: date
    produto: str
    categoria: str
    valor: float
    quantidade: int

    class Config:
        orm_mode = True # enable the model to work with ORM objects

# Modelo Pydantic para criação
class VendaCreate(BaseModel):
    data_venda: date
    produto: str
    categoria: str
    valor: float
    quantidade: int


# obtem uma sessão do banco temporária para usar com injeção de dependência
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

app = FastAPI(title="API de Análise de Dados")

@app.get("/")
def read_root():
    return {"mensagem": "API de Análise de Dados"}

@app.get("/vendas", response_model=List[Venda])
def listar_vendas(db: Session = Depends(get_db)):
    return db.query(VendaDB).all()

@app.get("/vendas/categoria/{categoria}", response_model=List[Venda])
def vendas_por_categoria(categoria: str, db: Session = Depends(get_db)):
    return db.query(VendaDB).filter(VendaDB.categoria == categoria).all()

@app.get("/vendas/analise")
def analise_vendas(db: Session = Depends(get_db)):
    resultado = db.query(
        VendaDB.categoria,
        func.count(VendaDB.id).label("total_vendas"),
        func.sum(VendaDB.valor * VendaDB.quantidade).label("receita_total"),
        func.avg(VendaDB.valor).label("ticket_medio")
    ).group_by(VendaDB.categoria).all()
    # cast return to List
    return [
        {
            "categoria": r.categoria,
            "total_vendas": r.total_vendas,
            "receita_total": float(r.receita_total),
            "ticket_medio": float(r.ticket_medio)
        }
        for r in resultado
    ]

@app.post("/vendas", response_model=Venda)
def criar_venda(venda: VendaCreate, db: Session = Depends(get_db)):
    nova_venda = VendaDB(**venda.dict())
    db.add(nova_venda)
    db.commit()
    db.refresh(nova_venda)
    return nova_venda
