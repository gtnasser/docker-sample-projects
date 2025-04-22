# Exemplo 2 - API em Python usando FastAPI

## 1. Executando API local

1.1. criar ambiente virtual

```sh
python -m venv venv
.\venv\Scripts\activate
```

1.2. criar o arquivo *requirements.txt* com o seguinte conteúdo:
```
fastapi==0.115.12
uvicorn==0.34.0
pandas==2.2.3
pydantic==2.11.1
```

1.3. instalar dependencias
```sh
pip install -r requirements.txt
```

1.4. executar api
```sh
uvicorn main:app
```
e abir o navegador em http://localhost:8000


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
EXPOSE 8000
```

comando a ser executado quando o container for iniciado
```
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

2.2 criar a imagem e executar o container
```sh
docker build --tag image2 .
docker run -p 8000:8000 --name container2 image2
```


## 3. Consumindo a API

```sh
curl -X GET http://localhost:8000
HTTP/1.1 200 OK
{"mensagem":"API de Dados de Vendas"}
```

lista de produtos
```sh
curl -X GET http://localhost:8000/produtos

HTTP/1.1 200 OK
[{"id":1,"produto":"Laptop","categoria":"Computadores","preco":3500.0,"quantidade_vendida":12},{"id":2,"produto":"Mouse","categoria":"Acessórios","preco":150.0,"quantidade_vendida":85},{"id":3,"produto":"Teclado","categoria":"Acessórios","preco":200.0,"quantidade_vendida":63},{"id":4,"produto":"Monitor","categoria":"Periféricos","preco":1200.0,"quantidade_vendida":35},{"id":5,"produto":"Headphone","categoria":"Áudio","preco":350.0,"quantidade_vendida":42},{"id":6,"produto":"Webcam","categoria":"Periféricos","preco":180.0,"quantidade_vendida":30},{"id":7,"produto":"SSD","categoria":"Componentes","preco":450.0,"quantidade_vendida":55},{"id":8,"produto":"RAM","categoria":"Componentes","preco":300.0,"quantidade_vendida":70},{"id":9,"produto":"GPU","categoria":"Componentes","preco":2000.0,"quantidade_vendida":22},{"id":10,"produto":"CPU","categoria":"Componentes","preco":1500.0,"quantidade_vendida":25}]
```

recuperando produto especifico
```sh
curl -X GET http://localhost:8000/produtos/3

HTTP/1.1 200 OK
{"id":3,"produto":"Teclado","categoria":"Acessorios","preco":200.0,"quantidade_vendida":63}
```

recuperando produto não existente
```sh
curl -X GET http://localhost:8000/produtos/33

HTTP/1.1 500 Internal Server Error
```

pesquisando produto pela categoria
```sh
curl http://127.0.0.1:8000/produtos?categoria=Componentes

[{"id":7,"produto":"SSD","categoria":"Componentes","preco":450.0,"quantidade_vendida":55},{"id":8,"produto":"RAM","categoria":"Componentes","preco":300.0,"quantidade_vendida":70},{"id":9,"produto":"GPU","categoria":"Componentes","preco":2000.0,"quantidade_vendida":22},{"id":10,"produto":"CPU","categoria":"Componentes","preco":1500.0,"quantidade_vendida":25}]
```

combinando critérios de filtro
```sh
curl http://127.0.0.1:8000/produtos?min_preco=1000&categoria=Componentes

HTTP/1.1 200 OK
[{"id":9,"produto":"GPU","categoria":"Componentes","preco":2000.0,"quantidade_vendida":22},{"id":10,"produto":"CPU","categoria":"Componentes","preco":1500.0,"quantidade_vendida":25}]
 ```

forçando erro na requisicao
```sh
curl -X POST http://127.0.0.1:8000/produtos -d"{\"id\":3,\"produto\":\"Teclado\",\"categoria\":\"Acessorios\",\"preco\":200.0,\"quantidade_vendida\":63}"

HTTP/1.1 422 Unprocessable Content
{"detail":[{"type":"model_attributes_type","loc":["body"],"msg":"Input should be a valid dictionary or object to extract fields from","input":"{\"id\":3,\"produto\":\"Teclado\",\"categoria\":\"Acessorios\",\"preco\":200.0,\"quantidade_vendida\":63}"}]}* Connection #0 to host 127.0.0.1 left intact
```

incluindo uma nova venda
```sh
curl -X POST http://127.0.0.1:8000/produtos \
    -H "Content-Type: application/json" \
    -d "{\"produto\":\"Caixa de Som\",\"categoria\":\"Audio\",\"preco\":100.0,\"quantidade_vendida\":19}"

HTTP/1.1 200 OK
{"id":11,"produto":"Caixa de Som","categoria":"Audio","preco":100.0,"quantidade_vendida":19}
```