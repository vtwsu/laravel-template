FROM php:8.2.10-fpm

RUN apt-get update && apt-get -y upgrade

RUN apt-get install -y git autoconf g++ supervisor make libmcrypt-dev \
    mosquitto-dev nginx tzdata libxml2-dev libzip-dev libpq-dev \
    postgresql libldap2-dev p7zip-full

ADD ./conf/php/www.conf /usr/local/etc/php-fpm.d/www.conf

# Add user for laravel application
RUN groupadd -g 1000 laravel
RUN useradd -u 1000 -ms /bin/bash -g laravel laravel

RUN chown laravel:laravel /var/www/html

WORKDIR /var/www/html

# Установка extensions
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install pgsql
RUN docker-php-ext-install ldap
RUN docker-php-ext-install session
RUN docker-php-ext-install dom
RUN docker-php-ext-install xml
RUN docker-php-ext-install xmlwriter 
RUN docker-php-ext-install fileinfo
RUN docker-php-ext-install zip

# Устанавливаем Composer (если подразумевается его использование в контейнере)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# nginx
COPY ./conf/nginx/nginx.conf /etc/nginx/
COPY ./conf/nginx/default.conf /etc/nginx/conf.d/

RUN cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
    echo "Europe/Moscow" >  /etc/timezone

# cron
COPY ./conf/cron/cronjobs /etc/crontabs/root
RUN crontab /etc/crontabs/root

# supervisord
COPY ./conf/php/supervisord.conf /etc/supervisord.conf

ADD src /var/www/html/

RUN mkdir -p /var/log/cron/

ADD ./conf/php/uploads.ini /usr/local/etc/php/conf.d/

### Фронт
#RUN apt-get install --no-cache nodejs npm yarn

EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
