FROM postgres:16.3

RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/16/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/16/main/postgresql.conf

COPY init.sh /docker-entrypoint-initdb.d/

