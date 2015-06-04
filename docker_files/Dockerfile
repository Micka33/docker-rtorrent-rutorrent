FROM        phusion/baseimage
MAINTAINER  Mickael Cassy <twitter@mickaelcassy>
ENV         HOME /root
RUN         /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD         ["/sbin/my_init"]


RUN         apt-get -y update
RUN         apt-get -y install automake libtool curl gzip wget unzip libxml2 libxml2-dev libgd2-xpm-dev libgeoip-dev libperl-dev libxslt1-dev libxslt1.1 libssl-dev make g++ php5-fpm subversion pkg-config libcppunit-dev libcurl4-openssl-dev libncurses-dev

# Gets PCRE
WORKDIR     /install
RUN         (wget http://linux.stanford.edu/pub/exim/pcre/pcre-8.35.tar.gz) && (tar -xzf pcre-8.35.tar.gz) && (rm pcre-8.35.tar.gz)
# Gets Nginx Developer Kit
WORKDIR     /install
RUN         (wget https://github.com/simpl/ngx_devel_kit/archive/v0.2.19.zip) && (unzip v0.2.19.zip) && (rm v0.2.19.zip)
# Gets Zlib
WORKDIR     /install
RUN         (wget http://zlib.net/zlib-1.2.8.tar.gz) && (tar -xzf zlib-1.2.8.tar.gz) && (rm zlib-1.2.8.tar.gz)

# Installs Nginx
WORKDIR     /install
RUN         (wget http://nginx.org/download/nginx-1.6.1.tar.gz) && (tar -xzf nginx-1.6.1.tar.gz) && (rm nginx-1.6.1.tar.gz)
WORKDIR     /install/nginx-1.6.1
RUN         (sed -i "s/static char ngx_http_server_string\[\] = \"Server: nginx\" CRLF;/static char ngx_http_server_string\[\] = \"Server: Lol web server\" CRLF;/g" /install/nginx-1.6.1/src/http/ngx_http_header_filter_module.c) && \
            (sed -i "s/static char ngx_http_server_full_string\[\] = \"Server: \" NGINX_VER CRLF;/static char ngx_http_server_full_string\[\] = \"Server: Lol web server\" CRLF;/g" /install/nginx-1.6.1/src/http/ngx_http_header_filter_module.c)
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
              --with-pcre=`pwd`/../pcre-8.35  \
              --with-zlib=`pwd`/../zlib-1.2.8  \
              --add-module=`pwd`/../ngx_devel_kit-0.2.19

RUN           make
RUN         sudo make install
RUN         ln -s `pwd`/objs/nginx  /bin/nginx

# Installs libtorrent
WORKDIR     /rtorrent
RUN         (wget -O libtorrent-0.13.4.tar.gz https://github.com/rakshasa/libtorrent/archive/0.13.4.tar.gz) && \
            (tar -xzf libtorrent-0.13.4.tar.gz) && (rm libtorrent-0.13.4.tar.gz)
WORKDIR     libtorrent-0.13.4
RUN         (./configure) && (make) && (make install)

# Installs xmlrpc
WORKDIR     /rtorrent
RUN         svn checkout http://svn.code.sf.net/p/xmlrpc-c/code/stable xmlrpc-c
WORKDIR     xmlrpc-c
RUN         (./configure --disable-cplusplus) && (make) && (make install)

# Installs rtorrent
WORKDIR     /rtorrent
RUN         (wget -O rtorrent-0.9.4.tar.gz https://github.com/rakshasa/rtorrent/archive/0.9.4.tar.gz) && \
            (tar -xzf rtorrent-0.9.4.tar.gz) && (rm rtorrent-0.9.4.tar.gz)
WORKDIR     rtorrent-0.9.4
RUN         (./configure --with-xmlrpc-c) && (make) && (make install) && (ldconfig)




# Creates nginx Service
WORKDIR     /etc/service/nginx
ADD         ./nginx.conf /etc/nginx/nginx.conf
ADD         ./run_nginx.sh /etc/service/nginx/run
RUN         chmod +x ./run
#we're not displaying our nginx version to the world
RUN         (sed -i "s/nginx\/$nginx_version/web\/lol/g" /etc/nginx/fastcgi.conf)

# Configures fpm
RUN         (sed -i "s/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini) && \
            (sed -i "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php5-fpm.sock/g" /etc/php5/fpm/pool.d/www.conf)

# Creates fpm Service
WORKDIR   /etc/service/fpm
ADD       ./run_fpm.sh /etc/service/fpm/run
RUN       chmod +x ./run


# Gets ruTorrent
WORKDIR     /usr/share/nginx/www/rutorrent
RUN         (svn checkout http://rutorrent.googlecode.com/svn/trunk/ .) && \
            (rm -rf .rutorrent/conf/) && (chown -R www-data:www-data .)
ADD         ./rutorrent_conf/ /root/rutorrent/rutorrent/conf/


ADD         .rtorrent.rc /root/.rtorrent.rc

# Creates rtorrent as a service (using runit)
#WORKDIR     /etc/service/rtorrent
#ADD        ./run_rtorrent.sh /etc/service/rtorrent/run
#RUN        chmod +x ./run

# Cleans up APT when done.
RUN         apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
