FROM        phusion/baseimage:latest
MAINTAINER  Mickael Cassy <twitter@mickaelcassy>
ENV         HOME /root
RUN         /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD         ["/sbin/my_init"]


RUN         apt-get -y update
RUN         apt-get -y install automake libtool curl gzip wget unzip libxml2 libxml2-dev libgd2-xpm-dev libgeoip-dev libperl-dev libxslt1-dev libxslt1.1 libssl-dev make g++ php5-fpm subversion pkg-config libcppunit-dev libcurl4-openssl-dev libncurses-dev

# Gets PCRE
WORKDIR     /install
RUN         (wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.36.tar.bz2) && (tar -xjf pcre-8.36.tar.bz2) && (rm pcre-8.36.tar.bz2)
# Gets Nginx Developer Kit
WORKDIR     /install
RUN         (wget https://github.com/simpl/ngx_devel_kit/archive/v0.2.19.zip) && (unzip v0.2.19.zip) && (rm v0.2.19.zip)
# Gets Zlib
WORKDIR     /install
RUN         (wget http://zlib.net/zlib-1.2.8.tar.gz) && (tar -xzf zlib-1.2.8.tar.gz) && (rm zlib-1.2.8.tar.gz)

# Installs Nginx
WORKDIR     /install
RUN         (wget http://nginx.org/download/nginx-1.8.0.tar.gz) && (tar -xzf nginx-1.8.0.tar.gz) && (rm nginx-1.8.0.tar.gz)
WORKDIR     /install/nginx-1.8.0
RUN         (sed -i "s/static char ngx_http_server_string\[\] = \"Server: nginx\" CRLF;/static char ngx_http_server_string\[\] = \"Server: Lol web server\" CRLF;/g" /install/nginx-1.8.0/src/http/ngx_http_header_filter_module.c) && \
            (sed -i "s/static char ngx_http_server_full_string\[\] = \"Server: \" NGINX_VER CRLF;/static char ngx_http_server_full_string\[\] = \"Server: Lol web server\" CRLF;/g" /install/nginx-1.8.0/src/http/ngx_http_header_filter_module.c)
RUN         mkdir -p /var/lib/nginx/body
RUN         ./configure \
              --prefix=/usr/share/nginx  \
              --conf-path=/etc/nginx/nginx.conf  \
              --error-log-path=/var/log/nginx/error.log  \
              --http-client-body-temp-path=/var/lib/nginx/body  \
              --http-fastcgi-temp-path=/var/lib/nginx/fastcgi  \
              --http-log-path=/var/log/nginx/access.log  \
              --http-proxy-temp-path=/var/lib/nginx/proxy  \
              --http-scgi-temp-path=/var/lib/nginx/scgi  \
              --http-uwsgi-temp-path=/var/lib/nginx/uwsgi  \
              --lock-path=/var/lock/nginx.lock  \
              --pid-path=/run/nginx.pid  \
              --with-pcre-jit  \
              --with-debug  \
              --with-http_addition_module  \
              --with-http_dav_module  \
              --with-http_flv_module  \
              --with-http_geoip_module  \
              --with-http_gzip_static_module  \
              --with-http_image_filter_module  \
              --with-http_mp4_module  \
              --with-http_perl_module  \
              --with-http_random_index_module  \
              --with-http_realip_module  \
              --with-http_secure_link_module  \
              --with-http_stub_status_module  \
              --with-http_ssl_module  \
              --with-http_sub_module  \
              --with-http_xslt_module  \
              --with-ipv6  \
              --with-sha1=/usr/include/openssl  \
              --with-md5=/usr/include/openssl  \
              --with-mail  \
              --with-mail_ssl_module  \
              --with-http_spdy_module  \
              --with-pcre=`pwd`/../pcre-8.36  \
              --with-zlib=`pwd`/../zlib-1.2.8  \
              --add-module=`pwd`/../ngx_devel_kit-0.2.19

RUN         make
RUN         sudo make install
RUN         ln -s `pwd`/objs/nginx  /bin/nginx

# Installs libtorrent
WORKDIR     /rtorrent
RUN         (wget -O libtorrent-0.13.4.tar.gz https://github.com/rakshasa/libtorrent/archive/0.13.4.tar.gz) && \
            (tar -xzf libtorrent-0.13.4.tar.gz) && (rm libtorrent-0.13.4.tar.gz)
WORKDIR     libtorrent-0.13.4
RUN         (sh autogen.sh) && (./configure) && (make) && (make install)

# Installs xmlrpc
RUN         apt-get -y install libxmlrpc-core-c3 libxmlrpc-core-c3-dev


# Installs rtorrent
WORKDIR     /rtorrent
RUN         (wget -O rtorrent-0.9.4.tar.gz https://github.com/rakshasa/rtorrent/archive/0.9.4.tar.gz) && \
            (tar -xzf rtorrent-0.9.4.tar.gz) && (rm rtorrent-0.9.4.tar.gz)
WORKDIR     rtorrent-0.9.4
RUN         (sh autogen.sh) && (./configure --with-xmlrpc-c) && (make) && (make install) && (ldconfig)


# DEV ONLY
WORKDIR   /
RUN       (wget http://curl.haxx.se/download/curl-7.44.0.tar.gz) && \
          (tar -xzf curl-7.44.0.tar.gz) && (rm curl-7.44.0.tar.gz)
WORKDIR   curl-7.44.0
RUN       ./configure && make && make install


# Creates nginx Service
WORKDIR     /etc/service/nginx
ADD         ./nginx.conf /etc/nginx/nginx.conf
ADD         ./run_nginx.sh /etc/service/nginx/run
RUN         chmod +x ./run
#we're not displaying our nginx version to the world
RUN         (sed -i "s/nginx\/$nginx_version/web\/lol/g" /etc/nginx/fastcgi.conf)

# Configures fpm
RUN          apt-get -y install php5-common php5-cli
RUN         (sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini) && \
            (sed -i "s/;catch_workers_output = yes/catch_workers_output = yes/" /etc/php5/fpm/pool.d/www.conf) && \
            (sed -i "s/;daemonize = yes/;daemonize = no/g" /etc/php5/fpm/php-fpm.conf) && \
            (sed -i "s/;include=\/etc\/php5\/fpm\/*.conf/include=\/etc\/php5\/fpm\/pool.d\/*.conf/g" /etc/php5/fpm/php-fpm.conf) && \
            (sed -i "s/;chroot =/chroot = \/var\/www\/rutorrent/g" /etc/php5/fpm/pool.d/www.conf)



# Creates fpm Service
WORKDIR     /etc/service/fpm
ADD         ./run_fpm.sh /etc/service/fpm/run
RUN         chmod +x ./run


# Gets ruTorrent
WORKDIR     /var/www
RUN         (svn checkout http://rutorrent.googlecode.com/svn/trunk/ .) && \
            (rm -rf .rutorrent/conf/) && (chown -R www-data:www-data ../www) && (chmod -R 755 ../www)
ADD         ./rutorrent_conf/ /var/www/rutorrent/conf/


ADD         .rtorrent.rc /root/.rtorrent.rc

# Creates rtorrent as a service (using runit)
# WORKDIR     /etc/service/rtorrent
# ADD         ./run_rtorrent.sh /etc/service/rtorrent/run
# RUN         chmod +x ./run

# Cleans up APT when done.
RUN         apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
