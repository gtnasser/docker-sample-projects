# Exemplo 3 - Instância do Banco de Dados Postgres

Vamos mostrar como manter a persistência dos dados


# 1. Iniciar o contêiner com o banco de dados

Executar o container baseado em uma imagem oficial do Postgres, passando as definições de nome da instância, usuário e senha pelas variáveis de ambiente.
```sh
docker run --name postgres-dados -e POSTGRES_DB=datawarehouse -e POSTGRES_USER=analista -e POSTGRES_PASSWORD=segredo -p 5432:5432 -d postgres:14.8
```

executar o cliente psql dentro do contêiner para criar a tabela *vendas* e inserir alguns registros

```sh
docker exec -it postgres-dados psql -U analista -d datawarehouse

psql (14.8 (Debian 14.8-1.pgdg120+1))
Type "help" for help.

datawarehouse-# CREATE TABLE vendas (
    id SERIAL PRIMARY KEY,
    data_venda DATE NOT NULL,
    produto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    quantidade INT NOT NULL
);
CREATE TABLE

datawarehouse-# INSERT INTO vendas (data_venda, produto, categoria, valor, quantidade)
VALUES
  ('2025-01-15', 'Curso Python', 'Educação', 197.00, 45),
  ('2025-01-20', 'Assinatura BI', 'Software', 89.90, 28),
  ('2025-02-05', 'Consultoria', 'Serviços', 1200.00, 3),
  ('2025-02-12', 'Curso SQL', 'Educação', 147.00, 52),
  ('2025-03-01', 'Licença Tableau', 'Software', 999.00, 15);
INSERT 0 5

datawarehouse-# select * from vendas;
 id | data_venda |     produto     | categoria |  valor  | quantidade
----+------------+-----------------+-----------+---------+------------
  1 | 2025-01-15 | Curso Python    | Educação  |  197.00 |         45
  2 | 2025-01-20 | Assinatura BI   | Software  |   89.90 |         28
  3 | 2025-02-05 | Consultoria     | Serviços  | 1200.00 |          3
  4 | 2025-02-12 | Curso SQL       | Educação  |  147.00 |         52
  5 | 2025-03-01 | Licença Tableau | Software  |  999.00 |         15
(5 rows)
```

para acessar o banco externamente, por exemplo utilizando o [DBeaver](https://dbeaver.io), utilize as informações:

Parâmetro|Valor
---|---
Driver| Postgres
Host| localhost
Port| 5432
User| analista
Password| segredo
Database| datawarehouse


# 2. Executar o backup

Vamos executar o backup para poder restaurá-lo em outra instância
```sh
PS C:\Users\gtnas\Downloads\docker-sample-projects\exemplo3-postgres> docker exec -t postgres-dados pg_dump -U analista -d datawarehouse > backup.sql
```

# 3. Executar uma nova instância

Executar um novo container mas agora definindo um volume para persistir os dados. A montagem de volume (```-v postgres_data_novo:/var/lib/postgresql/data```) cria um volume do Docker chamado *postgres_data_novo* que mantém os arquivos de banco de dados fora do contêiner. Isso garante que seus dados não sejam perdidos quando o contêiner parar ou for removido.

```sh
docker run --name postgres-dados-novo -e POSTGRES_PASSWORD=segredo -e POSTGRES_USER=analista -e POSTGRES_DB=datawarehouse -v postgres_data_novo:/var/lib/postgresql/data -p 5433:5432 -d postgres:14.8
```

restaurar os dados
```sh
cat backup.sql | docker exec -i postgres-dados-novo psql -U analista -d datawarehouse

SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 5
 setval
--------
      5
(1 row)

ALTER TABLE
```

vamos verificar o conteúdo da tabela *vendas*
```sh
echo "select * from vendas;" | docker exec -i postgres-dados psql -U analista -d datawarehouse

 id | data_venda |     produto      | categoria  |  valor  | quantidade
----+------------+------------------+------------+---------+------------
  1 | 2025-01-15 | Curso Python     | Educa????o |  197.00 |         45
  2 | 2025-01-20 | Assinatura BI    | Software   |   89.90 |         28
  3 | 2025-02-05 | Consultoria      | Servi??os  | 1200.00 |          3
  4 | 2025-02-12 | Curso SQL        | Educa????o |  147.00 |         52
  5 | 2025-03-01 | Licen??a Tableau | Software   |  999.00 |         15
(5 rows)
```

agora vamos parar as duas instâncias e reiniciá-las.

```sh
# listar contâineres em execução
docker ps -a

CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS                   PORTS                    NAMES
c19e3d942d9b   postgres:14.8   "docker-entrypoint.s…"   9 minutes ago    Up 9 minutes             0.0.0.0:5433->5432/tcp   postgres-dados-novo
636de3d9ca07   postgres:14.8   "docker-entrypoint.s…"   35 minutes ago   Up 35 minutes            0.0.0.0:5432->5432/tcp   postgres-dados

# parar o contâiner novo e recriar utilizando o mesmo voluma

docker stop postgres-dados-novo
docker rm postgres-dados-novo
docker run --name postgres-dados-novo -e POSTGRES_PASSWORD=segredo -e POSTGRES_USER=analista -e POSTGRES_DB=datawarehouse -v postgres_data_novo:/var/lib/postgresql/data -p 5433:5432 -d postgres:14.8

# executar a consulta na base persistida

echo "select * from vendas;" | docker exec -i postgres-dados-novo psql -U analista -d datawarehouse
 id | data_venda |     produto      | categoria  |  valor  | quantidade
----+------------+------------------+------------+---------+------------
  1 | 2025-01-15 | Curso Python     | Educa????o |  197.00 |         45
  2 | 2025-01-20 | Assinatura BI    | Software   |   89.90 |         28
  3 | 2025-02-05 | Consultoria      | Servi??os  | 1200.00 |          3
  4 | 2025-02-12 | Curso SQL        | Educa????o |  147.00 |         52
  5 | 2025-03-01 | Licen??a Tableau | Software   |  999.00 |         15
(5 rows)
```

