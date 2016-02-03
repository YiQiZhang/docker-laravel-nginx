FROM ubuntu:14.04
MAINTAINER Jerry Zhang "jerry_techtree@126.com"
ENV REFRESHED_AT 2016-02-03

RUN apt-get update && apt-get install -y \
	gcc

RUN apt-get clean \
	&& apt-get autoclean
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
