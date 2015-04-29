FROM postgres:9.2
MAINTAINER teijo.laine@reaktor.com

RUN install -m700 -gpostgres -opostgres -d /data
RUN gosu postgres initdb -D /data
RUN echo "host all postgres 0.0.0.0/0 trust" >> /data/pg_hba.conf

ADD /pgpass /root/.pgpass
RUN chmod 400 /root/.pgpass

ADD /clone-database.sh /clone-database.sh
RUN chmod 100 /clone-database.sh
RUN /clone-database.sh

ENTRYPOINT gosu postgres postgres -D /data -h 0.0.0.0

EXPOSE 5432
