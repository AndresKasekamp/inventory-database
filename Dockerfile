FROM debian:stable

# Set environment variables to reduce output from debconf
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# Copy the initialization script into the container
COPY ./init.sh /

# Grant execute permissions on the script
RUN chmod +x /init.sh

# Update package list and install prerequisites
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    lsb-release \
    sudo && \
    rm -rf /var/lib/apt/lists/*
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/postgresql-archive-keyring.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" >/etc/apt/sources.list.d/pgdg.list
RUN apt-get update && apt-get install -y \
    postgresql-16 \
    postgresql-client-16 && \
    rm -rf /var/lib/apt/lists/*
# Setup PostgreSQL
USER postgres

RUN echo "host all  all    0.0.0.0/0  md5" >>/etc/postgresql/16/main/pg_hba.conf
RUN echo "listen_addresses='*'" >>/etc/postgresql/16/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

ENTRYPOINT [ "/init.sh" ]

# Use CMD to run the PostgreSQL server
CMD ["/usr/lib/postgresql/16/bin/postgres", "-D", "/var/lib/postgresql/16/main", "-c", "config_file=/etc/postgresql/16/main/postgresql.conf"]
