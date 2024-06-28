#!/bin/bash
set -e

export DB_USER
export DB_PASS

/etc/init.d/postgresql start

psql -v ON_ERROR_STOP=1 --username "postgres" <<-EOSQL
    CREATE DATABASE movies;
    CREATE USER $DB_USER WITH ENCRYPTED PASSWORD '$DB_PASS';
    GRANT ALL PRIVILEGES ON DATABASE movies TO $DB_USER;
    GRANT ALL PRIVILEGES ON SCHEMA public TO $DB_USER;
    CREATE TABLE movies (
        id SERIAL PRIMARY KEY,
        title VARCHAR(100) NOT NULL,
        description VARCHAR(255)
    );
    GRANT ALL PRIVILEGES ON TABLE movies TO $DB_USER;
    GRANT ALL ON SEQUENCE movies_id_seq TO $DB_USER;
EOSQL

/etc/init.d/postgresql stop

exec /usr/lib/postgresql/16/bin/postgres -D /var/lib/postgresql/16/main -c config_file=/etc/postgresql/16/main/postgresql.conf
