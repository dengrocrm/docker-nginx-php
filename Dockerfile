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
    apt-get install --no-install-recommends -y locales && \
    locale-gen ${LOCALE} && \
    dpkg-reconfigure locales && \
    # Install libraries
    apt-get install --no-install-recommends -y \
        $BUILD_DEPS \
        composer \
        cron \
        nginx \
        nodejs \
        npm \
        php7.4 \
        php7.4-bcmath \
        php7.4-cli \
        php7.4-common \
        php7.4-curl \
        # php7.4-ctype \
        php7.4-dev \
        # php7.4-dom \
        # php7.4-fileinfo \
        php7.4-fpm \
        php7.4-gd \
        # php7.4-iconv \
        php7.4-intl \
        php7.4-json \
        php7.4-mbstring \
        # php7.4-mcrypt \
        php7.4-opcache \
        # php7.4-openssl \
        # php7.4-pdo \
        php7.4-mysql \
        php7.4-pgsql \
        # php7.4-session \
        # php7.4-simplexml \
        php7.4-soap \
        php7.4-sqlite3 \
        # php7.4-tokenizer \
        php7.4-xml \
        # php7.4-xmlreader \
        # php7.4-xmlwriter \
        # php7.4-xdebug \
        php7.4-zip \
        # php7.4-zlib \
        supervisor \
        tzdata \
        yarnpkg \
        zip \
        unzip \
        wget && \
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
RUN chown -Rf www-data:www-data /var/www/app /var/log/nginx /var/lib/nginx 

VOLUME ["/run/php", "/var/lib/php"]

WORKDIR /var/www/app

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisor/supervisord.conf"]