FROM ubuntu:23.10
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
        php8.2 \
        php8.2-bcmath \
        php8.2-cli \
        php8.2-common \
        php8.2-curl \
        # php8.2-ctype \
        php8.2-dev \
        # php8.2-dom \
        # php8.2-fileinfo \
        php8.2-fpm \
        php8.2-gd \
        # php8.2-iconv \
        php8.2-intl \
        php8.2-mbstring \
        # php8.2-mcrypt \
        php8.2-opcache \
        # php8.2-openssl \
        # php8.2-pdo \
        php8.2-mysql \
        php8.2-pgsql \
        # php8.2-session \
        # php8.2-simplexml \
        php8.2-soap \
        php8.2-sqlite3 \
        # php8.2-tokenizer \
        php8.2-xml \
        # php8.2-xmlreader \
        # php8.2-xmlwriter \
        # php8.2-xdebug \
        php8.2-zip \
        # php8.2-zlib \
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