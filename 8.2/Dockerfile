FROM php:8.2-fpm-alpine

ARG S6_OVERLAY_VERSION=3.2.0.0
ARG PHP_EXTENSION_INSTALLER_VERSION=2.5.0

ARG VERSION
ARG REVISION

RUN echo "$VERSION (${REVISION:0:7})" > /var/www/.version

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/tmp
ENV COMPOSER_CACHE_DIR=/dev/null
ENV COMPOSER_FUND=0
ENV COMPOSER_NO_INTERACTION=1
ENV COMPOSER_NO_DEV=1

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/download/${PHP_EXTENSION_INSTALLER_VERSION}/install-php-extensions /usr/local/bin/install-php-extensions
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# production dependencies
RUN set -ex; \
    apk add --no-cache \
    nginx;

# install extensions
RUN set -ex; \
    install-php-extensions \
    event \
    excimer \
    exif \
    gd \
    intl \
    opcache \
    pdo_mysql \
    pcntl \
    zip;

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN set -ex; \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz; \
    tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz;

CMD ["/init"]

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY common/s6-rc.d /etc/s6-overlay/s6-rc.d
COPY common/nginx/nginx.conf /etc/nginx/nginx.conf
COPY 8.2/php.ini /usr/local/etc/php/conf.d/zz-custom.ini
COPY 8.2/www.conf /usr/local/etc/php-fpm.d/zz-docker.conf

ENV ENV="/etc/profile"
COPY common/aliases.sh /etc/profile.d/aliases.sh

WORKDIR /var/www

# Sensible defaults for production
ENV LOG_CHANNEL=stderr

# Enable the worker
ENV WORKER_ENABLED=false

# The number of jobs to process before stopping
ENV WORKER_MAX_JOBS=50

# Number of seconds to sleep when no job is available
ENV WORKER_SLEEP=30

# Number of seconds to rest between jobs
ENV WORKER_REST=1

# The number of seconds a child process can run
ENV WORKER_TIMEOUT=600

# Number of times to attempt a job before logging it failed
ENV WORKER_TRIES=3

# determines what the container should do if one of the service scripts fails
# 0: Continue silently even if a script has failed.
# 1: Continue but warn with an annoying error message.ext script
# 2: Stop the container.
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

ENV SENTRY_SAMPLE_RATE=0

ENV PHP_MEMORY_LIMIT=256M
ENV PHP_POST_MAX_SIZE=50M
ENV PHP_UPLOAD_MAX_FILESIZE=50M

ENV PHP_PM_MAX_CHILDREN=32
ENV PHP_PM_MAX_REQUESTS=1000

EXPOSE 80
