FROM dunglas/frankenphp

ARG UID
ARG GID

WORKDIR /var/www/html

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git \
    unzip \
    librabbitmq-dev \
    libpq-dev \
    supervisor

RUN install-php-extensions \
    gd \
    pcntl \
    opcache \
    pdo_pgsql \
    redis

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

COPY ./dockerfiles/php.ini /usr/local/etc/php/
COPY ./dockerfiles/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN pecl install xdebug

RUN composer install

RUN docker-php-ext-enable xdebug

RUN addgroup --gid $GID hostgroup && \
    adduser --disabled-password --gecos '' --uid $UID --gid $GID hostuser

RUN chown -R www-data:www-data storage bootstrap/cache

EXPOSE 80 443

RUN echo "#!/bin/sh\numask 002\nexec /usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf" > /usr/local/bin/start_supervisord.sh \
    && chmod +x /usr/local/bin/start_supervisord.sh

CMD ["/usr/local/bin/start_supervisord.sh"]
