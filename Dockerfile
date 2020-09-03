FROM php:7.3-alpine

RUN apt-get update \  
    && apt-get install -y \
        libmcrypt-dev \
        libz-dev \
	libcurl3-gnutls-dev \
	libzip-dev \
	libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        git \
        wget \
	supervisor \
	cron \
    && ln -s /usr/include/x86_64-linux-gnu/curl /usr/include/ \
    && pecl install mcrypt-1.0.2 yar \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install \
        mbstring \
        pdo_mysql \
	zip \
	bcmath \
    && docker-php-ext-enable mcrypt yar \	

    && apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \

    && curl -sS https://getcomposer.org/installer \
        | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer config -g cache-dir "~/.cache/composer/cache" \
	&& composer config -g data-dir "~/.cache/composer" \
	&& composer global config data-dir ~/.cache/composer
