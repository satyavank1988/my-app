FROM ubuntu:16.04
MAINTAINER satyavan.k1988@gmail.com

RUN apt-get -y update
RUN apt-get -y install nginx

copy config/index.html /var/www/html/
# app version 2.0 deployment
#COPY index.html /var/www/html/

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]


