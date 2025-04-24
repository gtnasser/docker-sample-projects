# DOCKER-SAMPLE-PROJECTS

<div style="background-color: #1D63ED; width: 100%; padding: 20px 0; margin-bottom: 50px; text-align: center;">

<svg style="height: 100px;" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 18" fill="white"><path d="M23.763 6.886c-.065-.053-.673-.512-1.954-.512-.32 0-.659.03-1.01.087-.248-1.703-1.651-2.533-1.716-2.57l-.345-.2-.227.328a4.596 4.596 0 0 0-.611 1.433c-.23.972-.09 1.884.403 2.666-.596.331-1.546.418-1.744.42H.752a.753.753 0 0 0-.75.749c-.007 1.456.233 2.864.692 4.07.545 1.43 1.355 2.483 2.409 3.13 1.181.725 3.104 1.14 5.276 1.14 1.016 0 2.03-.092 2.93-.266 1.417-.273 2.705-.742 3.826-1.391a10.497 10.497 0 0 0 2.61-2.14c1.252-1.42 1.998-3.005 2.553-4.408.075.003.148.005.221.005 1.371 0 2.215-.55 2.68-1.01.505-.5.685-.998.704-1.053L24 7.076l-.237-.19Z"></path><path d="M2.216 8.075h2.119a.186.186 0 0 0 .185-.186V6a.186.186 0 0 0-.185-.186H2.216A.186.186 0 0 0 2.031 6v1.89c0 .103.083.186.185.186Zm2.92 0h2.118a.185.185 0 0 0 .185-.186V6a.185.185 0 0 0-.185-.186H5.136A.185.185 0 0 0 4.95 6v1.89c0 .103.083.186.186.186Zm2.964 0h2.118a.186.186 0 0 0 .185-.186V6a.186.186 0 0 0-.185-.186H8.1A.185.185 0 0 0 7.914 6v1.89c0 .103.083.186.186.186Zm2.928 0h2.119a.185.185 0 0 0 .185-.186V6a.185.185 0 0 0-.185-.186h-2.119a.186.186 0 0 0-.185.186v1.89c0 .103.083.186.185.186Zm-5.892-2.72h2.118a.185.185 0 0 0 .185-.186V3.28a.186.186 0 0 0-.185-.186H5.136a.186.186 0 0 0-.186.186v1.89c0 .103.083.186.186.186Zm2.964 0h2.118a.186.186 0 0 0 .185-.186V3.28a.186.186 0 0 0-.185-.186H8.1a.186.186 0 0 0-.186.186v1.89c0 .103.083.186.186.186Zm2.928 0h2.119a.185.185 0 0 0 .185-.186V3.28a.186.186 0 0 0-.185-.186h-2.119a.186.186 0 0 0-.185.186v1.89c0 .103.083.186.185.186Zm0-2.72h2.119a.186.186 0 0 0 .185-.186V.56a.185.185 0 0 0-.185-.186h-2.119a.186.186 0 0 0-.185.186v1.89c0 .103.083.186.185.186Zm2.955 5.44h2.118a.185.185 0 0 0 .186-.186V6a.185.185 0 0 0-.186-.186h-2.118a.185.185 0 0 0-.185.186v1.89c0 .103.083.186.185.186Z"></path></svg>

</div>

Este repositório contém vários exemplos de projetos simples utilizando [Docker](https://www.docker.com/). O Objetivo é mostrar as diversas configurações de **Dockerfile** exemplificando o seu uso.

## 1. [exemplo1-python-streamlit](./exemplo1-python-streamlit) App em Python/Streamlit

Para executá-lo, inicie o container
```sh
cd exemplo1-pytyhon-streamlit
docker build --tag image1 .
docker run -p 8501:8501 --name container1 image1
```
e abra o navegador em http://localhost:8501


## 2. [exemplo2-python-fastapi](./exemplo2-python-fastapi) API em Python/FastAPI/Gunicorn

```sh
cd exemplo2-python-fastapi
docker build --tag image2 .
docker run -p 8000:8000 --name container2 image2
```
e execute a chamada
```sh
curl -X GET http://localhost:8000/produtos
```


## 3. [exemplo3-postgres](./exemplo3-postgres) Instância do Postgres DB

Para executá-lo, inicie o container, execute o script para criação dos objetos de banco e verifique o conteúdo de uma das tabelas
```sh
cd exemplo3-postgres
docker run --name container3-b -e POSTGRES_PASSWORD=segredo -e POSTGRES_USER=analista -e POSTGRES_DB=datawarehouse -v container3-vol:/var/lib/postgresql/data -p 5433:5432 -d postgres:14.8
cat backup.sql | docker exec -i container3-b psql -U analista -d datawarehouse
echo "select * from vendas;" | docker exec -i container3 psql -U analista -d datawarehouse
```

