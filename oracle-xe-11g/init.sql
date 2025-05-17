prompt # Create tablespace

CREATE TABLESPACE TSD_USERDB LOGGING DATAFILE 'TSD_USERDB.DBF' SIZE 200M AUTOEXTEND ON NEXT 200M MAXSIZE 400M;
CREATE TABLESPACE TSI_USERDB LOGGING DATAFILE 'TSI_USERDB.DBF' SIZE 200M AUTOEXTEND ON NEXT 50M MAXSIZE 400M;

prompt # Create user

CREATE USER USERDB IDENTIFIED BY PWDUSERDB DEFAULT TABLESPACE TSD_USERDB QUOTA UNLIMITED ON TSD_USERDB QUOTA UNLIMITED ON TSI_USERDB;
GRANT CREATE SESSION, CREATE PROCEDURE, CREATE VIEW, CREATE TABLE, CREATE SEQUENCE, CREATE TRIGGER TO USERDB;

CONN USERDB/PWDUSERDB

prompt # Create objects

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
VALUES (TO_DATE('2025-01-15','YYYY-MM-DD'), 'Curso Python', 'Educacao', 197.00, 45);
INSERT INTO vendas (data_venda, produto, categoria, valor, quantidade)
VALUES (TO_DATE('2025-01-20','YYYY-MM-DD'), 'Assinatura BI', 'Software', 89.90, 28);
INSERT INTO vendas (data_venda, produto, categoria, valor, quantidade)
VALUES (TO_DATE('2025-02-05','YYYY-MM-DD'), 'Consultoria', 'Servicos', 1200.00, 3);
INSERT INTO vendas (data_venda, produto, categoria, valor, quantidade)
VALUES (TO_DATE('2025-02-12','YYYY-MM-DD'), 'Curso SQL', 'Educacao', 147.00, 52);
INSERT INTO vendas (data_venda, produto, categoria, valor, quantidade)
VALUES (TO_DATE('2025-03-01','YYYY-MM-DD'), 'Licenca Tableau', 'Software', 999.00, 15);

COMMIT;
