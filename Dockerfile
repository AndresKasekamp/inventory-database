FROM postgres:16.3


# Allow external connections by updating the pg_hba.conf and postgresql.conf files
RUN echo "host all  all    0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf \
    && echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf

COPY init.sh /docker-entrypoint-initdb.d/

