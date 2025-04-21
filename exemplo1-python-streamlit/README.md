# Exemplo 1 - App em Python usando Streamlit

## 1. Executando App local

1.1. criar ambiente virtual

```sh
python -m venv venv
.\venv\Scripts\activate
```

1.2. criar o arquivo *requirements.txt* com o seguinte conteúdo:
```
streamlit==1.44.0
pandas==2.2.3
matplotlib==3.10.1
```

1.3. instalar dependencias
```sh
pip install -r requirements.txt
```

1.4. executar app
```sh
streamlit run app.py
```
e abir o navegador em http://localhost:8501


## 2. Executando API no Docker

2.1. criar o arquivo *Dockerfile* definindo:

a imagem base
```
FROM python:3.12-slim
```

a pasta onde serão executados os comandos
```
WORKDIR /app
```

comandos para instalação das dependências e demais configurações

por exemplo, montar o mesmo ambiente baseado no arquivo *requirements.txt*
```
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
```

copiar os arquivos do projeto (na verdade, todos os arquivos da pasta atual)
```
COPY . .
```

liberar as portas, por exemplo, para a API
```
EXPOSE 8501
```

comando a ser executado quando o container for iniciado
```
CMD ["streamlit", "run", "app.py", "--server.address=0.0.0.0"]
```

2.2 criar a imagem e executar o container
```sh
docker build --tag image1 .
docker run -p 8501:8501 --name container1 server1
```

