FROM postgres:16.3

# Switch to the root user to modify the configuration files
USER root

# Allow external connections by updating the pg_hba.conf and postgresql.conf files
RUN echo "host all  all    0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf \
    && echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Switch back to the postgres user
USER postgres

COPY init.sh /docker-entrypoint-initdb.d/

