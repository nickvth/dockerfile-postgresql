FROM centos:centos6
MAINTAINER nickvth
RUN yum -y update
RUN yum -y install http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-redhat93-9.3-1.noarch.rpm
RUN yum -y install http://mirror.proserve.nl/fedora-epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum -y install postgresql93-server postgresql93-contrib
RUN yum -y install python-setuptools
RUN yum -y install sudo
RUN easy_install pip
RUN pip install supervisor
RUN yum -y install openssh-server 
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN useradd nickvth -G wheel
RUN echo 'root:secret' | chpasswd
RUN echo 'nickvth:test1234' | chpasswd
RUN echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
ADD pg_hba.conf /var/lib/pgsql/pg_hba.conf
ADD postgresql.conf /var/lib/pgsql/postgresql.conf
RUN chown postgres:postgres /var/lib/pgsql/*.conf
RUN mkdir -p /usr/scripts/
ADD create_user.sh /usr/scripts/create_user.sh
ADD start_postgres.sh /usr/scripts/start_postgres.sh
RUN chmod +x /usr/scripts/*.sh
ADD supervisord.conf /etc/supervisord.conf
