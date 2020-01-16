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

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -

RUN apt-get update -q \
    && apt-get install -y --no-install-recommends \
        nodejs \
    && apt-get clean

WORKDIR /code/

COPY package*.json /code/

RUN npm install \
    && npm install gulp-cli -g \
    && npm install natives

RUN curl --silent --show-error https://getcomposer.org/installer | php -- --quiet \
    && mv composer.phar /usr/local/bin/composer \
    && composer global require hirak/prestissimo

COPY composer.* /code/
RUN composer install $COMPOSER_FLAGS --no-scripts --no-autoloader

COPY . /code/

RUN composer install $COMPOSER_FLAGS

EXPOSE 8000

CMD ["gulp"]
