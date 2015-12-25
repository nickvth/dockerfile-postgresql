#!/bin/sh

# After enter set -e in an interactive bash, bash will exit immediately if any command exits with non-zero.
set -e

# Create dummy file when server is out of space, you can remove dummy to continu the service.
/bin/dd if=/dev/zero of=$PGDATA/dummyfileforrecoveroutofspace bs=104857600 count=1
chown postgres:postgres $PGDATA/dummyfileforrecoveroutofspace

#After setting postgres user password, disable trust login and only accept md5.
sed -ri "s/trust/md5/g" "$PGDATA"/pg_hba.conf

# Set tcp keepalives idle to 30 minutes, needed to ignore firewall timeout.
sed -ri "s/#tcp_keepalives_idle = 0/tcp_keepalives_idle = 600/" "$PGDATA"/postgresql.conf

# Set default logging parameters.
sed -ri "s/.*logging_collector =.*/logging_collector = on/" "$PGDATA"/postgresql.conf
sed -ri "s/.*log_truncate_on_rotation =.*/log_truncate_on_rotation = on/" "$PGDATA"/postgresql.conf
sed -ri "s/.*log_rotation_age =.*/log_rotation_age = 1d/" "$PGDATA"/postgresql.conf
sed -ri "s/.*log_min_messages =.*/log_min_messages = error/" "$PGDATA"/postgresql.conf
sed -ri "s/.*log_connections =.*/log_connections = on/" "$PGDATA"/postgresql.conf
sed -ri "s/.*log_hostname =.*/log_hostname = on/" "$PGDATA"/postgresql.conf
sed -ri "s/.*log_lock_waits =.*/log_lock_waits = on/" "$PGDATA"/postgresql.conf
sed -ri "s/.*log_statement =.*/log_statement = 'ddl'/" "$PGDATA"/postgresql.conf
sed -ri "s/.*log_filename =.*/log_filename = 'postgresql-%a.log'/" "$PGDATA"/postgresql.conf
sed -ri "s/.*log_timezone =.*/log_timezone = 'Europe\/Amsterdam'/" "$PGDATA"/postgresql.conf
sed -ri "s/.*timezone =.*/timezone = 'Europe\/Amsterdam'/" "$PGDATA"/postgresql.conf
sed -ri "s/.*log_line_prefix =.*/log_line_prefix = '< %m >'/" "$PGDATA"/postgresql.conf

# Set statictics functions
sed -ri "s/.*track_functions =.*/track_functions = all/" "$PGDATA"/postgresql.conf

# Create wal directory and set all archive parameters if POSTGRES_ARCHIVE = yes.
if [ "$POSTGRES_ARCHIVE" == "archive" ]
then
        mkdir -p /var/lib/postgresql/wal/
        chmod 700 /var/lib/postgresql/wal
        chown postgres /var/lib/postgresql/wal
        sed -ri "s/#wal_level = minimal/wal_level = archive/" "$PGDATA"/postgresql.conf
        sed -ri "s/#archive_mode = off/archive_mode = on/" "$PGDATA"/postgresql.conf
        sed -ri "s/#archive_command = ''/archive_command = 'test \! \-f \/var\/lib\/postgresql\/wal\/\%f \&\& cp \%p \/var\/lib\/postgresql\/wal\/\%f\'/" "$PGDATA"/postgresql.conf
        sed -ri "s/#archive_timeout = 0/archive_timeout = 14400/" "$PGDATA"/postgresql.conf
fi

# Set shared_buffers in postgresql.conf when $POSTGRES_MEMORY is not empty.
if [ -z $POSTGRES_MEMORY ]
then
        echo "Postgres memory not set"
else
        sed -ri "s/.*shared_buffers =.*/shared_buffers = $POSTGRES_MEMORY/" "$PGDATA"/postgresql.conf
fi

# Set max_connections in postgresql.conf when $POSTGRES_BACKENDS is not empty.
if [ -z $POSTGRES_BACKENDS ]
then
        echo "Postgres backends not set"
else 
        sed -ri "s/.*max_connections =.*/max_connections = $POSTGRES_BACKENDS/" "$PGDATA"/postgresql.conf
fi 
