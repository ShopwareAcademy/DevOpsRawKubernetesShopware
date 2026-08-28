#syntax=docker/dockerfile:1.4

FROM ghcr.io/shopware/docker-base:8.5-frankenphp AS base-image
FROM ghcr.io/shopware/shopware-cli:latest-php-8.5 AS build

ADD . /src
WORKDIR /src

RUN --mount=type=cache,target=/root/.composer \
    --mount=type=cache,target=/root/.npm \
    /usr/local/bin/entrypoint.sh shopware-cli project ci --force /src

FROM base-image AS final

COPY --from=build --chown=82 --link /src /var/www/html
