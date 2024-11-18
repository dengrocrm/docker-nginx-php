FROM ubuntu:24.04
LABEL maintainer="dengrocrm"

# Deleting the ubuntu user as it's not required and is known to conflict with host system user/group IDs
RUN userdel -f ubuntu && \
  if getent group ubuntu ; then groupdel ubuntu; fi

ENV LOCALE="en_US.UTF-8"
ENV DEBIAN_FRONTEND=noninteractive \
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
        php8.3 \
        php8.3-bcmath \
        php8.3-cli \
        php8.3-common \
        php8.3-curl \
        # php8.3-ctype \
        php8.3-dev \
        # php8.3-dom \
        # php8.3-fileinfo \
        php8.3-fpm \
        php8.3-gd \
        # php8.3-iconv \
        php8.3-intl \
        php8.3-mbstring \
        # php8.3-mcrypt \
        php8.3-opcache \
        # php8.3-openssl \
        # php8.3-pdo \
        php8.3-mysql \
        php8.3-pgsql \
        # php8.3-session \
        # php8.3-simplexml \
        php8.3-soap \
        php8.3-sqlite3 \
        # php8.3-tokenizer \
        php8.3-xml \
        # php8.3-xmlreader \
        # php8.3-xmlwriter \
        # php8.3-xdebug \
        php8.3-zip \
        # php8.3-zlib \
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