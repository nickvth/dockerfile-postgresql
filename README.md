## dockerfile with extensions on official postgres image. 

Dockerfile for postgresql, data outside the container and extra ENVIRONMENT VARIABLES.

- [`9.1.20`, `9.1` (*9.1/Dockerfile*)]
- [`9.2.15`, `9.2` (*9.2/Dockerfile*)]
- [`9.3.11`, `9.3` (*9.3/Dockerfile*)]
- [`9.4.6`, `9.4`, `9`, `latest` (*9.4/Dockerfile*)]

Based on official docker postgres 'debian wheezy'

https://registry.hub.docker.com/_/postgres/

Automated Build at docker hub: https://hub.docker.com/r/nickvth/dockerfile-postgresql/

<b>Usage</b>

docker pull

```
docker pull nickvth/dockerfile-postgresql:[version]
```

Start container(s)

```
ENV OPTIONS POSTGRESQL IMAGE
POSTGRES_USER  -->  postgresql running as user 'default is postgres'
POSTGRES_PASSWORD --> postgresql user password
POSTGRES_ARCHIVE --> postgresql archive mode archive 'default is noarchive' 
POSTGRES_BACKENDS --> postgresql max_connections 'default is 100'
POSTGRES_MEMORY --> postgresql shared_buffers 'each version has it's own default, check documentation'

mkdir -p /postdb1/data
mkdir -p /postdb1/wal
chcon -Rt svirt_sandbox_file_t /postdb1 "fix selinux"
docker run -t -d --name postdb1 -p [ip or empty]:5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=mysecretpassword -e POSTGRES_ARCHIVE=archive -e POSTGRES_BACKENDS=200 -e POSTGRES_MEMORY=256MB -v /postdb1/data:/var/lib/postgresql/data -v /postdb1/wal:/var/lib/postgresql/wal nickvth/dockerfile-postgresql:[version]  
psql -p 5432 -h [ip or localhost] -d postgres -U postgres
```

When you start the container, check with ```docker logs postdb1``` if everything is started succesfully

Data is outside the container in /postdb1

From docker 1.3 you can connect inside a running container, so ssh is no longer needed

```
docker exec -it postdb1 bash

docker exec -it postdb1 psql -U postgres
```

Backup script template for backup with continuous archiving, see scripts directory

Build your own image

```
git clone https://github.com/nickvth/dockerfile-postgresql.git
cd dockerfile-postgresql/[version]
docker build --force-rm=true --no-cache=true -t [image]:[version] .
docker tag --help
docker push --help
```
