FROM ubuntu:23.04
LABEL maintainer="dengrocrm"

# Deleting the ubuntu user as it's not required and is known to conflict with host system user/group IDs
RUN userdel -f ubuntu && \
  if getent group ubuntu ; then groupdel ubuntu; fi

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
        build-essential

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
        php8.1 \
        php8.1-bcmath \
        php8.1-cli \
        php8.1-common \
        php8.1-curl \
        # php8.1-ctype \
        php8.1-dev \
        # php8.1-dom \
        # php8.1-fileinfo \
        php8.1-fpm \
        php8.1-gd \
        # php8.1-iconv \
        php8.1-intl \
        php8.1-mbstring \
        # php8.1-mcrypt \
        php8.1-opcache \
        # php8.1-openssl \
        # php8.1-pdo \
        php8.1-mysql \
        php8.1-pgsql \
        # php8.1-session \
        # php8.1-simplexml \
        php8.1-soap \
        php8.1-sqlite3 \
        # php8.1-tokenizer \
        php8.1-xml \
        # php8.1-xmlreader \
        # php8.1-xmlwriter \
        # php8.1-xdebug \
        php8.1-zip \
        # php8.1-zlib \
        ssh \
        supervisor \
        tzdata \
        yarnpkg \
        zip \
        unzip \
        wget && \
    # Install composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
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