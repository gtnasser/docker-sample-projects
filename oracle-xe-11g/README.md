# ORACLE-XE-11.2.0.2

Vamos subir uma instância do Banco de Dados Oracle Express Edition 11g Release 2 (versão 11.2.0.2) no Ubuntu 18.04 LTS, usando como base uma imagem pré-existente [oracleinanutshell/oracle-xe-11g](https://hub.docker.com/r/oracleinanutshell/oracle-xe-11g). Vamos criar um volume para manter a persistência dos dados. Em seguida vamos criar um usuário, uma tabela e popularemos os dados na tabela.

Vamos executar de 3 maneiras diferentes:
- executando os comandos manualmente, passo a passo
- utilizando o Dockerfile
- utilizando o Docker Compose

Esta imagem cria o usuário *oracle* no ubuntu, e os usuários SYS no banco de dados. Para mais detalhes, acesse o [Docker Hub](https://hub.docker.com/r/oracleinanutshell/oracle-xe-11g). Para acessar o banco podemos usar o [Oracle SQL Developer](https://www.oracle.com/database/sqldeveloper/) ou o [DBeaver](https://dbeaver.io/), com a configuração:

Parâmetro|Valor
---|---
hostname | localhost
port | 1521
sid | xe
username | USERDB
password | PWDUSERDB

Em seguida, e abrir o navegador em http://localhost:8080 para acessar o APEX com as credenciais Username=```ADMIN``` e Password=```admin```.



## 1. executando os comandos manualmente, passo a passo

Executar a imagem publicando a porta 1521 para acesso remoto ao banco. Por questões de performance, especificamente do banco XE em Docker, pode ser necessário desabilitar a entrada/saída assíncrona do disco, incluindo a diretiva ```-e ORACLE_DISABLE_ASYNCH_IO=true```.

```sh
docker run -d -p 1524:1521 -e ORACLE_ALLOW_REMOTE=true --name oracle-xe oracleinanutshell/oracle-xe-11g
```

Executar o script para inicialização do banco, criando uma tablespace, um usuário, uma tabela e populando dados nesta tabela. Como a imagem não tem o serviço *ssh*, logar como root e alterar para o usuario *oracle*, Em seguida, abrir o *sqlplus* e executar os comandos para criação dos objetos

```sh
docker exec -it oracle-xe bash
su - oracle
sqlplus '/as sysdba'

CREATE TABLESPACE TSD_USERDB LOGGING DATAFILE 'TSD_USERDB.DBF' SIZE 200M AUTOEXTEND ON NEXT 200M MAXSIZE 400M;
CREATE TABLESPACE TSI_USERDB LOGGING DATAFILE 'TSI_USERDB.DBF' SIZE 200M AUTOEXTEND ON NEXT 50M MAXSIZE 400M;

CREATE USER USERDB IDENTIFIED BY PASSWORD DEFAULT TABLESPACE TSI_USERDB QUOTA UNLIMITED ON TSD_USERDB QUOTA UNLIMITED ON TSI_USERDB;
GRANT CREATE SESSION, CREATE PROCEDURE, CREATE VIEW, CREATE TABLE, CREATE SEQUENCE, CREATE TRIGGER TO USERDB;

CONN USERDB/PWDUSERDB

CREATE SEQUENCE id_seq
START WITH      1
INCREMENT BY    1
NOCACHE;

CREATE TABLE vendas (
    id         NUMBER        PRIMARY KEY,
    data_venda DATE          NOT NULL,
    produto    VARCHAR(100)  NOT NULL,
    categoria  VARCHAR(50)   NOT NULL,
    valor      DECIMAL(10,2) NOT NULL,
    quantidade INT           NOT NULL
);

CREATE OR REPLACE TRIGGER vendas_tr
BEFORE INSERT ON vendas
FOR EACH ROW
BEGIN
    SELECT id_seq.NEXTVAL INTO :new.id FROM dual;
END;
/

INSERT INTO vendas (data_venda, produto, categoria, valor, quantidade)
VALUES (TO_DATE('2025-01-15','YYYY-MM-DD'), 'Curso Python', 'Educação', 197.00, 45);
INSERT INTO vendas (data_venda, produto, categoria, valor, quantidade)
VALUES (TO_DATE('2025-01-20','YYYY-MM-DD'), 'Assinatura BI', 'Software', 89.90, 28);
INSERT INTO vendas (data_venda, produto, categoria, valor, quantidade)
VALUES (TO_DATE('2025-02-05','YYYY-MM-DD'), 'Consultoria', 'Serviços', 1200.00, 3);
INSERT INTO vendas (data_venda, produto, categoria, valor, quantidade)
VALUES (TO_DATE('2025-02-12','YYYY-MM-DD'), 'Curso SQL', 'Educação', 147.00, 52);
INSERT INTO vendas (data_venda, produto, categoria, valor, quantidade)
VALUES (TO_DATE('2025-03-01','YYYY-MM-DD'), 'Licença Tableau', 'Software', 999.00, 15);

COMMIT;
```


## 2. utilizando o Dockerfile

```sh
docker build -t oracle-xe .
docker run -d -p 1521:1521 -p 21:21 -p 5500:5500 -p 8080:8080 -e ORACLE_ALLOW_REMOTE=true --name ora11 oracle-xe
```


## 3. utilizando o Docker Compose

```sh
docker compose up -d
```


