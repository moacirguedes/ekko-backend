FROM dunglas/frankenphp

WORKDIR /app

RUN install-php-extensions pcntl sockets pdo_pgsql zip \
    && apt-get update \
    && apt-get install -y git unzip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . /app

RUN composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader

RUN chown -R www-data:www-data /app

ENTRYPOINT ["sh", "-c", "composer update && php artisan octane:start --server=frankenphp --port=9804 --host=0.0.0.0"]
