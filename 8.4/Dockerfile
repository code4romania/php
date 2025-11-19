# TODO: replace when stable is released
# beta-8.4-fpm-nginx-alpine
FROM serversideup/php@sha256:885f3ef31d193ee67e03863d50a349a0ce2c31cd74eb42c79f7a37e7a6918120

COPY --chmod=755 common/etc/entrypoint.d /etc/entrypoint.d
COPY --chmod=755 --chown=www-data:www-data common/etc/nginx /etc/nginx

# PHP limits
ENV PHP_MEMORY_LIMIT=256M
ENV PHP_POST_MAX_SIZE=100M
ENV PHP_UPLOAD_MAX_FILE_SIZE=${PHP_POST_MAX_SIZE}

# OPcache settings
ENV PHP_OPCACHE_ENABLE=1
ENV PHP_OPCACHE_INTERNED_STRINGS_BUFFER=8
ENV PHP_OPCACHE_MEMORY_CONSUMPTION=128
ENV PHP_OPCACHE_REVALIDATE_FREQ=2

# PHP-FPM settings
ENV PHP_FPM_PM_CONTROL=ondemand
ENV PHP_FPM_PM_MAX_CHILDREN=20
ENV PHP_FPM_PM_START_SERVERS=2
ENV PHP_FPM_PM_MIN_SPARE_SERVERS=1
ENV PHP_FPM_PM_MAX_SPARE_SERVERS=3

# Laravel settings
ENV AUTORUN_ENABLED=true
ENV AUTORUN_LARAVEL_MIGRATION=true
ENV AUTORUN_LARAVEL_STORAGE_LINK=true
ENV AUTORUN_LARAVEL_OPTIMIZE=true
ENV AUTORUN_LARAVEL_FILAMENT=true

ENV HEALTHCHECK_PATH=/up

# Composer settings
ENV COMPOSER_ALLOW_SUPERUSER=0
ENV COMPOSER_CACHE_DIR=/dev/null
ENV COMPOSER_FUND=0
ENV COMPOSER_HOME=/tmp
ENV COMPOSER_NO_DEV=1
ENV COMPOSER_NO_INTERACTION=1

# App defaults
ENV LOG_CHANNEL=stderr

# Switch to root so we can do root things
USER root

# Install additional PHP extensions
RUN set -ex; \
    install-php-extensions \
    event \
    excimer \
    exif \
    gd \
    intl;

# Drop back to our unprivileged user
USER www-data

EXPOSE 8080 8443
