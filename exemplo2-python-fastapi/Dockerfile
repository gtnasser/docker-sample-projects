# Dockerfile
FROM python:3.12-slim

WORKDIR /app

# Instalar dependências
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código
COPY . .

# Expor porta para o Streamlit
EXPOSE 8000

# Comando para iniciar o Streamlit
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
