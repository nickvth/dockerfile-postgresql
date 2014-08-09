dockerfile-postgresql
=====================

Dockerfile for postgresql and data outside the container.

Postgresql 9.3 is used.

<b>Usage</b>

<pre>
cd /tmp/
git clone https://github.com/nickvth/dockerfile-postgresql.git 
docker build -t="[your username]/postgresql93" .
mkdir /postdb1
docker run -t -d --name="postdb1" -p [ip or empty]:32:22 -p [ip or empty]:5432:5432 -v /postdb1/:/var/lib/pgsql/9.3/ [your username]/postgresql93 /usr/bin/supervisord -c /etc/supervisord.conf
psql -p 5432 -h [ip or localhost] -d postgres -U postgres
</pre>
