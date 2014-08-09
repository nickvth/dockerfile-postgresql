# if exit number is non-zero script will stop.
set -e

# Set DATA_DIR variable to check if exist.
DATA_DIR=/var/lib/pgsql/9.3/data

# if $DATA_DIR exits start postgresql.
if [ -d $DATA_DIR ]; then
      /etc/init.d/postgresql-9.3 start 

# If not exist create default postgresql instance, with default configuration and password for user postgres.
else
      /etc/init.d/postgresql-9.3 initdb
      rm -f $DATA_DIR/pg_hba.conf
      rm -f $DATA_DIR/postgresql.conf
      mv /var/lib/pgsql/pg_hba.conf $DATA_DIR/
      mv /var/lib/pgsql/postgresql.conf $DATA_DIR/
      /etc/init.d/postgresql-9.3 start
      /usr/scripts/alter_postgresdb_user.sh
      rm -f /usr/scripts/alter_postgresdb_user.sh
fi
