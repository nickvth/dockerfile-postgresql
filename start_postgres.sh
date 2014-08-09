set -e

DATA_DIR=/var/lib/pgsql/9.3/data

if [ -d $DATA_DIR ]; then
      /etc/init.d/postgresql-9.3 start 

else
      /etc/init.d/postgresql-9.3 initdb
      rm -f $DATA_DIR/pg_hba.conf
      rm -f $DATA_DIR/postgresql.conf
      mv /var/lib/pgsql/pg_hba.conf $DATA_DIR/
      mv /var/lib/pgsql/postgresql.conf $DATA_DIR/
      /etc/init.d/postgresql-9.3 start
      /usr/scripts/create_user.sh
      rm -f /usr/scripts/create_user.sh
fi
