Downloading base ubuntu image from ecr
FROM ubuntu:18.04
#FROM 059465471618.dkr.ecr.eu-west-2.amazonaws.com/base-container-ubuntu:latest
#FROM nginxlocal
##Installing nginx
RUN apt-get -y update;
RUN apt-get -y upgrade;
#RUN apt-get -y install curl vim
RUN apt-get -y install -y nginx;
RUN rm -rf /var/lib/apt/lists/*;
#RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN chown -R www-data:www-data /var/lib/nginx;
RUN rm -rfv /var/www/html/*;
RUN rm -rfv /etc/nginx/sites-enabled/default;
RUN rm -rfv /etc/nginx/nginx.conf;
RUN mkdir /nginx-cache;
RUN chown -R www-data:www-data /nginx-cache;
COPY ../docker-ubuntu-base-nginx/conf/default /etc/nginx/sites-enabled/default
COPY ../docker-ubuntu-base-nginx/conf/nginx.conf /etc/nginx/
COPY html /var/www/html/
#
###Define mountable directories
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]
#
###Define work directory
WORKDIR /etc/nginx
#
###Define default command
#CMD ["nginx -t"]
CMD ["nginx"]
#
###Expose ports
EXPOSE 80
EXPOSE 443
