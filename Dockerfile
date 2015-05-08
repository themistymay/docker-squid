FROM ubuntu:14.04
MAINTAINER Mike May <themistymay@gmail.com>

ENV VERSION_MAJOR_SQUID 3
ENV VERSION_MINOR_SQUID 5
ENV VERSION_PATCH_SQUID 3

ENV VERSION_SQUID $VERSION_MAJOR_SQUID.$VERSION_MINOR_SQUID.$VERSION_PATCH_SQUID

RUN apt-get update
RUN apt-get build-dep squid3 -y -q
RUN apt-get install -y -q wget libssl-dev

RUN mkdir -p /opt/squid-$VERSION_SQUID

WORKDIR /opt
RUN wget http://www.squid-cache.org/Versions/v$VERSION_MAJOR_SQUID/$VERSION_MAJOR_SQUID.$VERSION_MINOR_SQUID/squid-$VERSION_SQUID.tar.gz

RUN tar -xvf squid-$VERSION_SQUID.tar.gz

WORKDIR /opt/squid-$VERSION_SQUID
RUN ./configure --prefix=/usr \
                --localstatedir=/var \
                --libexecdir=/usr/lib/squid \
                --srcdir=. \
                --datadir=/usr/shared/squid \
                --sysconfdir=/etc/squid \
                --with-openssl \
                --enable-ssl-crtd \
                --enable-linux-netfilter \
                --enable-icap-client \
                --enable-snmp \
                --enable-follow-x-forwarded-for \
                --with-default-user=proxy \
                --with-logdir=/var/log \
                --with-pidfile=/var/run/squid.pid

RUN make
RUN make install

RUN mkdir /certs
WORKDIR /certs

ADD inet.cert inet.cert
ADD inet.csr inet.csr
ADD inet.private inet.private

# RUN openssl genrsa -out inet.private 2048
# RUN openssl req -new -key inet.private -out inet.csr
# RUN openssl x509 -req -days 3652 -in inet.csr -signkey inet.private -out inet.cert
