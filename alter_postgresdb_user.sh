# Alter user postgres, change password by yourself or after the installation is complete.
su postgres -c ' /usr/bin/psql -c "ALTER USER postgres WITH PASSWORD '\''postgres'\'';" '
