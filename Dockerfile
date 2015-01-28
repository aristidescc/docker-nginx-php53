FROM ubuntu:12.04
MAINTAINER Aristides Castillo <aristidescc@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN adduser --uid 1000 --ingroup staff webapp
RUN apt-get update -y && apt-get install curl aptitude -y
RUN apt-get upgrade --force-yes -y

RUN apt-get install git-core --force-yes -y
RUN apt-get install xclip --force-yes -y

RUN apt-get install php5 php5-cli php5-common php5-curl php5-fpm php5-gd php5-geoip php5-gmp php5-imagick php5-intl php5-json php5-mcrypt php5-memcached php5-mysql php-apc php-pear php5-xdebug --force-yes -y 

RUN pear upgrade pear
RUN pear config-set auto_discover 1

# Configure PHP-FPM
RUN mv /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf.old
ADD docker-conf/fpm-www.conf /etc/php5/fpm/pool.d/www.conf

RUN apt-get install nginx --force-yes -y

ADD docker-conf/nginx-cakephp.conf /etc/nginx/cakephp.conf
ADD docker-conf/nginx-common.conf /etc/nginx/common.conf
ADD docker-conf/nginx-fastcgi-params /etc/nginx/fastcgi_params
ADD docker-conf/nginx.conf /etc/nginx/nginx.conf
ADD docker-conf/nginx-php.conf /etc/nginx/php.conf

ADD docker-conf/sites-default /etc/nginx/sites-available/default

RUN apt-get install supervisor --force-yes -y
ADD supervisor/supervisord.conf /etc/supervisord.conf


RUN mkdir -p /var/virtual
RUN chown www-data:www-data /var/virtual 

RUN curl -sS https://getcomposer.org/installer | php

RUN mv composer.phar /usr/share/composer

RUN chmod 777 /usr/share/composer

RUN alias composer='/usr/share/composer'

RUN apt-get autoremove --force-yes -y

