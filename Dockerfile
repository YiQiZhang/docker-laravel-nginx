FROM ubuntu:14.04
MAINTAINER Jerry Zhang "jerry_techtree@126.com"
ENV REFRESHED_AT 2016-02-03

ENV NGINX_SOURCE_DIR /software/nginx/

# install dependencies
RUN apt-get update && apt-get install -y \
	gcc \
	g++ \
	make \
	zlib1g-dev \
	libpcre3 \
	libpcre3-dev \
	libssl-dev

ADD software/nginx.tar.gz $NGINX_SOURCE_DIR 
RUN cp -r $NGINX_SOURCE_DIR/nginx-*/* $NGINX_SOURCE_DIR

# add user & group
RUN groupadd -r www && \
	useradd -M -s /sbin/nologin -r -g www www

# install nginx
RUN cd /software/nginx && \
	./configure --prefix=/usr/local/nginx \
	--sbin-path=/usr/local/sbin \
	--conf-path=/etc/nginx/nginx.conf \
	--user=www --group=www \
	--error-log-path=/var/log/nginx/error.log \
	--http-log-path=/var/log/nginx/access.log \
	--pid-path=/var/run/nginx.pid \
	--with-pcre \
	--with-http_ssl_module \
	--with-http_gzip_static_module \
	--without-mail_pop3_module \
	--without-mail_imap_module && \	
	make && make install

# copy configure
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/website.conf /etc/nginx/conf.d/


RUN apt-get clean \
	&& apt-get autoclean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /software

VOLUME [ "/data/www/website" , "/var/log/nginx"]

EXPOSE 80

ENTRYPOINT [ "nginx" ]
