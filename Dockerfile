FROM ubuntu

RUN apt-get update && \
    apt-get install bison flex perl pkg-config libicu-dev make -y

WORKDIR /home/ubuntu

COPY . .

RUN ./configure --without-readline --without-zlib && \
    make && \
    make install && \
    mkdir -p /usr/local/pgsql/data && \
    chown ubuntu /usr/local/pgsql/data

USER ubuntu

RUN /usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data && \
    /usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l /home/ubuntu/logfile.log start && \
    /usr/local/pgsql/bin/createdb test && \
    /usr/local/pgsql/bin/psql test