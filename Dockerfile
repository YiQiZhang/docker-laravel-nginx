FROM ubuntu:14.04
MAINTAINER Jerry Zhang "jerry_techtree@126.com"
ENV REFRESHED_AT 2016-02-03

ENV NGINX_SOURCE_DIR /software/nginx/

RUN apt-get update && apt-get install -y \
	gcc \
	make

ADD software/nginx.tar.gz $NGINX_SOURCE_DIR 
RUN cp -r $NGINX_SOURCE_DIR/nginx-*/* $NGINX_SOURCE_DIR
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/website.conf /etc/nginx/conf.d/

RUN groupadd -r www && \
	useradd -M -s /sbin/nologin -r -g www www

# install nginx
RUN cd /software/nginx && \
	./configure --prefix=/usr/local/nginx \
	--user=www --group=www \
	--error-log-path=/var/log/nginx_error.log \
	--http-log-path=/var/log/nginx_access.log \
	--pid-path=/var/run/nginx.pid \
	--with-pcre \
	--with-http_ssl_module \
	--with-http_gzip_static_module \
	--without-mail_pop3_module \
	--without-mail_imap_module && \	
	make && make install


RUN apt-get clean \
	&& apt-get autoclean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /software

VOME [ "/data/www/website" ]

EXPOSE 80
