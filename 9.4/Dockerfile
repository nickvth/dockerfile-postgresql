
FROM postgres:9.4.5
RUN apt-get update ; apt-get -y install postgresql-server-dev-9.4 build-essential ; apt-get clean
ADD pg_statsinfo-3.1.0.tar /pg_statsinfo-3.1.0.tar
ADD build-pg_statsinfo.sh /build-pg_statsinfo.sh
RUN sh build-pg_statsinfo.sh
ADD initdb.sh /docker-entrypoint-initdb.d/
ADD extensions.sql /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/initdb.sh
RUN sed -i "/postgres \/run\/postgresql/a  chown -R postgres /var/lib/postgresql" /docker-entrypoint.sh