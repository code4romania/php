FROM php:8.2-fpm-alpine

ARG S6_OVERLAY_VERSION=3.1.6.2

ARG VERSION
ARG REVISION

RUN echo "$VERSION (${REVISION:0:7})" > /var/www/.version

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_CACHE_DIR /dev/null

COPY --from=mlocati/php-extension-installer:2 /usr/bin/install-php-extensions /usr/local/bin/install-php-extensions
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

RUN set -ex; \
    apk update;

# production dependencies
RUN set -ex; \
    apk add --no-cache \
    nginx;

# install extensions
RUN set -ex; \
    install-php-extensions \
    excimer \
    exif \
    gd \
    intl \
    mbstring \
    opcache \
    pdo_mysql \
    zip;

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN set -ex; \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz; \
    tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz;

ENTRYPOINT ["/init"]

COPY nginx.conf /etc/nginx/nginx.conf
COPY php.ini /usr/local/etc/php/php.ini
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

# Sensible defaults for production
ENV APP_ENV production

ENV APP_DEBUG false

ENV LOG_CHANNEL stderr

ENV CACHE_DRIVER database

ENV QUEUE_CONNECTION database

ENV SESSION_DRIVER database

# The number of jobs to process before stopping
ENV WORKER_MAX_JOBS 50

# Number of seconds to sleep when no job is available
ENV WORKER_SLEEP 30

# Number of seconds to rest between jobs
ENV WORKER_REST 1

# The number of seconds a child process can run
ENV WORKER_TIMEOUT 600

# Number of times to attempt a job before logging it failed
ENV WORKER_TRIES 3

ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME 0

ENV SENTRY_SAMPLE_RATE 0

EXPOSE 80
