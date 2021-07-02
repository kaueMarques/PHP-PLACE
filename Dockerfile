FROM php:5.6-apache

#2 Install unzip
RUN apt-get update && apt-get install -y \
    unzip

#3 Install git
RUN apt-get update && apt-get install -y \
    git

#4 Enable mod-rewrite
RUN a2enmod rewrite

#5 Install pdo_mysql
RUN docker-php-ext-install pdo_mysql

#6 Install intl
RUN apt-get update && apt-get install -y \
    g++ \
    libicu-dev \
    zlib1g-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

#7 Install GD2
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

#8 Install zip
RUN docker-php-ext-install zip

#9 Install XDebug
RUN pecl install xdebug-2.5.0 \
    && docker-php-ext-enable xdebug

#10 Install SOAP
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    && docker-php-ext-install soap


#11 Install composer and make the correct dirs writable
ENV PATH "/composer/vendor/bin:$PATH"
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
RUN curl -s -f -L -o /tmp/installer.php https://getcomposer.org/installer \
    && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer \
    && rm /tmp/installer.php \
    && mkdir -p /composer \
    && chmod -R 777 /composer

