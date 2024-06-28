FROM postgres:16.3

COPY init.sh /docker-entrypoint-initdb.d/

