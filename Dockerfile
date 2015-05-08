FROM ubuntu:14.04
MAINTAINER Mike May <themistymay@gmail.com>

ENV VERSION_SQUID 3.5.3

RUN apt-get update
RUN apt-get build-dep squid3 -y -q
RUN apt-get install -y -q wget libssl-dev
#RUN apt-get install -y -q libssl-dev build-essential automake wget libxml2-dev libcap-dev libltdl-dev

# autoconf automake autotools-dev binutils bsdmainutils build-essential
#   ca-certificates cdbs comerr-dev cpp cpp-4.8 debhelper dh-apparmor
#   dh-translations dpkg-dev g++ g++-4.8 gcc gcc-4.8 gettext gettext-base
#   groff-base intltool intltool-debian krb5-multidev libasan0 libasn1-8-heimdal
#   libasprintf0c2 libatomic1 libc-dev-bin libc6-dev libcap-dev libcloog-isl4
#   libcppunit-1.13-0 libcppunit-dev libcroco3 libdb-dev libdb5.3-dev
#   libdpkg-perl libecap2 libecap2-dev libencode-locale-perl libexpat1-dev
#   libfile-listing-perl libgcc-4.8-dev libglib2.0-0 libgmp10 libgomp1
#   libgssapi-krb5-2 libgssapi3-heimdal libgssrpc4 libhcrypto4-heimdal
#   libheimbase1-heimdal libheimntlm0-heimdal libhtml-parser-perl
#   libhtml-tagset-perl libhtml-tree-perl libhttp-cookies-perl libhttp-date-perl
#   libhttp-message-perl libhttp-negotiate-perl libhx509-5-heimdal
#   libio-html-perl libio-socket-ssl-perl libisl10 libitm1 libk5crypto3
#   libkadm5clnt-mit9 libkadm5srv-mit9 libkdb5-7 libkeyutils1 libkrb5-26-heimdal
#   libkrb5-3 libkrb5-dev libkrb5support0 libldap-2.4-2 libldap2-dev libltdl-dev
#   libltdl7 liblwp-mediatypes-perl liblwp-protocol-https-perl libmnl0 libmpc3
#   libmpfr4 libnet-http-perl libnet-ssleay-perl libnetfilter-conntrack-dev
#   libnetfilter-conntrack3 libnfnetlink-dev libnfnetlink0 libpam0g-dev
#   libpipeline1 libpython-stdlib libpython2.7-minimal libpython2.7-stdlib
#   libquadmath0 libroken18-heimdal libsasl2-2 libsasl2-dev libsasl2-modules-db
#   libsigsegv2 libstdc++-4.8-dev libtimedate-perl libtsan0 libunistring0
#   liburi-perl libwind0-heimdal libwww-perl libwww-robotrules-perl
#   libxml-parser-perl libxml2 libxml2-dev linux-libc-dev m4 make man-db openssl
#   patch pkg-config po-debconf python python-minimal python-scour python2.7
#   python2.7-minimal xz-utils

RUN mkdir -p /opt/squid-$VERSION_SQUID

WORKDIR /opt
RUN wget http://www.squid-cache.org/Versions/v3/3.5/squid-$VERSION_SQUID.tar.gz

RUN tar -xvf squid-$VERSION_SQUID.tar.gz

WORKDIR /opt/squid-$VERSION_SQUID
RUN ./configure --prefix=/usr \
                --localstatedir=/var \
                --libexecdir=${prefix}/lib/squid \
                --srcdir=. \
                --datadir=${prefix}/shared/squid \
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
