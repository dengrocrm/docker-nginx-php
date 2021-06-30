FROM ubuntu:20.04
LABEL maintainer="dengrocrm"

ENV LOCALE="en_US.UTF-8" \
    DEBIAN_FRONTEND=noninteractive \
    LANG=${LOCALE} \
    LANGUAGE=${LOCALE} \
    LC_ALL=${LOCALE} \
    TERM="xterm" \
    BUILD_DEPS="software-properties-common"

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
        $BUILD_DEPS \
        build-essential && \
    add-apt-repository -y ppa:ondrej/php

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y locales && \
    locale-gen ${LOCALE} && \
    dpkg-reconfigure locales && \
    apt-get install --no-install-recommends -y \
        cron \
        curl \
        libpng-dev \
        nginx \
        nodejs \
        npm \
        php8.0 \
        php8.0-bcmath \
        php8.0-cli \
        php8.0-common \
        php8.0-curl \
        # php8.0-ctype \
        php8.0-dev \
        # php8.0-dom \
        # php8.0-fileinfo \
        php8.0-fpm \
        php8.0-gd \
        # php8.0-iconv \
        php8.0-intl \
        php8.0-mbstring \
        # php8.0-mcrypt \
        php8.0-opcache \
        # php8.0-openssl \
        # php8.0-pdo \
        php8.0-mysql \
        php8.0-pgsql \
        # php8.0-session \
        # php8.0-simplexml \
        php8.0-soap \
        php8.0-sqlite3 \
        # php8.0-tokenizer \
        php8.0-xml \
        # php8.0-xmlreader \
        # php8.0-xmlwriter \
        # php8.0-xdebug \
        php8.0-zip \
        # php8.0-zlib \
        ssh \
        supervisor \
        tzdata \
        yarnpkg \
        zip \
        unzip \
        wget && \
    # Install composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    # Update NPM
    npm install npm@latest -g && \
    # Remove default Nginx directories
    rm -rf /etc/nginx/sites-enabled/* /etc/nginx/sites-available/ && \
    # Create Supervisor log directory
    mkdir -p /var/log/supervisor && \
    # Clean-up
    apt-get purge -y --auto-remove $BUILD_DEPS && \
    apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./root /

# Fix permissions
RUN chown -Rf www-data:www-data /var/www/app /var/log/nginx /var/lib/nginx /var/lib/php/sessions

VOLUME ["/run/php", "/var/lib/php"]

WORKDIR /var/www/app

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisor/supervisord.conf"]