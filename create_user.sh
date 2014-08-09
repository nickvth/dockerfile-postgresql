/etc/init.d/postgresql-9.3 start 
su postgres -c ' /usr/bin/psql -c "ALTER USER postgres WITH PASSWORD '\''postgres'\'';" '
