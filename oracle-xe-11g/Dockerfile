# base image
FROM oracleinanutshell/oracle-xe-11g

# inicializa o banco
ADD init.sql /docker-entrypoint-initdb.d/

# compartilha portas
EXPOSE 1521
EXPOSE 8080
EXPOSE 5500
