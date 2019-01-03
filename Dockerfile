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

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

COPY composer.* /code/
RUN composer install $COMPOSER_FLAGS --no-scripts --no-autoloader

COPY . /code/

RUN composer install $COMPOSER_FLAGS

EXPOSE 8000

CMD ["gulp"]
