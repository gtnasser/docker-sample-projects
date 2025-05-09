# Exemplo 4 - App Fullstack Python + Postgres

Este projeto exemplifica uma aplicação completa, uma aplicação em Streamlit consumindo uma API em FastAPI que acessa os dados de um banco Postgres.

Iniciar os 3 serviços (backend, frontend e banco de dados)
```sh
docker compose up
```

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


Para validar a API, executar no terminal
```sh
curl -X GET http://localhost:8000/vendas
```

Para executar o front-end, abrir o navegador em ```http://localhost:8501```



