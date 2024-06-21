FROM debian:stable

# Set environment variables to reduce output from debconf
ARG DB_USER
ARG DB_PASS
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# Update package list and install prerequisites
RUN apt update && apt install -y \
    wget \
    gnupg \
    lsb-release \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/postgresql-archive-keyring.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt update && apt install -y \
    postgresql-16 \
    postgresql-client-16 \
    && rm -rf /var/lib/apt/lists/*

# Setup PostgreSQL
USER postgres
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE ROLE $DB_USER PASSWORD '$DB_PASS' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN;" &&\
    createdb -O $DB_USER movies &&\
    psql -d movies --command "CREATE TABLE movies (ID SERIAL PRIMARY KEY, title VARCHAR(255), description VARCHAR(255));"


RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/16/main/pg_hba.conf

RUN echo "listen_addresses='*'" >> /etc/postgresql/16/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

CMD ["/usr/lib/postgresql/16/bin/postgres", "-D", "/var/lib/postgresql/16/main", "-c", "config_file=/etc/postgresql/16/main/postgresql.conf"]

