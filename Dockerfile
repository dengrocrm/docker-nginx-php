FROM ubuntu:19.10
LABEL maintainer="dengrocrm"

ENV LOCALE="en_US.UTF-8" \
    DEBIAN_FRONTEND=noninteractive \
    LANG=${LOCALE} \
    LANGUAGE=${LOCALE} \
    LC_ALL=${LOCALE} \
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
        php7.3 \
        php7.3-bcmath \
        php7.3-cli \
        php7.3-common \
        php7.3-curl \
        # php7.3-ctype \
        php7.3-dev \
        # php7.3-dom \
        # php7.3-fileinfo \
        php7.3-fpm \
        php7.3-gd \
        # php7.3-iconv \
        php7.3-intl \
        php7.3-json \
        php7.3-mbstring \
        # php7.3-mcrypt \
        php7.3-opcache \
        # php7.3-openssl \
        # php7.3-pdo \
        php7.3-mysql \
        php7.3-pgsql \
        # php7.3-session \
        # php7.3-simplexml \
        php7.3-soap \
        php7.3-sqlite3 \
        # php7.3-tokenizer \
        php7.3-xml \
        # php7.3-xmlreader \
        # php7.3-xmlwriter \
        # php7.3-xdebug \
        php7.3-zip \
        # php7.3-zlib \
        supervisor \
        tzdata \
        yarnpkg \
        wget && \
    # Remove default Nginx directories
    rm -rf /etc/nginx/sites-enabled/* /etc/nginx/sites-available/ && \
    # Create Supervisor log directory
    mkdir -p /var/log/supervisor && \
    # Clean-up
    apt-get purge -y --auto-remove $BUILD_DEPS && \
    apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # Forward access and error logs to stdout and stderr
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY ./root /

# Set permissions
RUN chown -Rf www-data:www-data /etc/php/7.3 && \
    chown -Rf www-data:www-data /var/www/app

# Set workdir to app
WORKDIR /var/www/app

EXPOSE 80 443

VOLUME ["/run/php", "/var/lib/php"]

CMD ["/usr/bin/supervisord"]
