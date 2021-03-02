FROM php:7-cli

ARG COMPOSER_FLAGS="--prefer-dist --no-interaction"
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_PROCESS_TIMEOUT 3600

RUN apt-get update -q \
        && apt-get install -y gnupg
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update -q \
    && apt-get install -y --no-install-recommends \
        git \
        unzip \
        gnupg \
    && apt-get clean

WORKDIR /code/

RUN curl --silent --show-error https://getcomposer.org/installer | php -- --1 --quiet \
    && mv composer.phar /usr/local/bin/composer \
    && composer global require hirak/prestissimo

COPY composer.* /code/
RUN composer install $COMPOSER_FLAGS --no-scripts --no-autoloader

COPY . /code/

RUN composer install $COMPOSER_FLAGS

EXPOSE 8000

CMD ["php", "-S", "0.0.0.0:8000", "-t", "output"]
