FROM php:5.6-fpm

RUN echo "Asia/Shanghai" > /etc/timezone
RUN \
    apt-get update && \
    apt-get install -y libwebp-dev git vim wget python3.4-dev curl libjpeg62-turbo-dev libpng12-dev libxml2-dev libfreetype6-dev libmcrypt-dev libssl-dev libgearman-dev

RUN \
    docker-php-ext-configure pdo_mysql && \
    docker-php-ext-configure opcache && \
    docker-php-ext-configure exif && \
    docker-php-ext-configure gd \
    --with-webp-dir=/usr/include --with-png-dir=/usr/include --with-jpeg-dir=/usr/include --with-freetype-dir=/usr/include && \
    docker-php-ext-configure sockets && \
    docker-php-ext-configure mcrypt

RUN \
    pecl install redis && \
    pecl install mongo && \
    pecl install xdebug && \
    pecl install swoole && \
    pecl install gearman && \
    pecl clear-cache
    
RUN \
    docker-php-ext-install zip mbstring mysql mysqli iconv pdo pdo_mysql opcache exif gd sockets mcrypt soap && \
    docker-php-ext-enable redis.so && \
    docker-php-ext-enable mongo.so && \
    docker-php-ext-enable xdebug.so && \
    docker-php-ext-enable gearman.so && \
    docker-php-ext-enable swoole.so && \
    docker-php-source delete

RUN \
    wget -O get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python3.4 get-pip.py && \
    pip3 install nose --no-cache-dir && \
    git clone https://github.com/tmfc/lz4tools.git && \
    cd lz4tools/ && \
    python3.4 setup.py install && \
    cd .. && \
    apt-get clean && \
    rm -rf lz4tools/ get-pip.py && \
    rm -rf /var/lib/apt/list/*
