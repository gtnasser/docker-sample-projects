# Exemplo 4 - App Fullstack Python + Postgres

Este projeto exemplifica uma aplicação completa, uma aplicação em Streamlit consumindo uma API em FastAPI que acessa os dados de um banco Postgres.

Inicie os 3 serviços (backend, frontend e storage)
```sh
docker compose up -d
```
e abra o navegador em ```http://localhost:8501```

Para validar a execução do banco de dados, executar no terminal
```sh
echo "select * from vendas;" | docker exec -i container4-db psql -U analista -d datawarehouse
```
ou através de um aplicativo específico (como psql ou DBeaver), neste caso, usar as credenciais

Parâmetro|Valor
---|---
Driver| Postgres
Host| localhost
Port| 5432
User| analista
Password| segredo
Database| datawarehouse

Para realizar uma chamada na API, por exemplo listar as vendas, execute no terminal
```sh
curl -X GET http://localhost:8000/vendas
```
Para acessar a documentação da API, abra o navegador em ```http://localhost:8501```

Para encerrar os serviços removendo os containeres mas mantendo o volume com os dados, execute no terminal
```sh
docker compose down
```

Para encerrar os serviços removendo também o volume, execute no terminal
```sh
docker compose down -v
```
