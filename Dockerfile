#syntax=docker/dockerfile:1.4

FROM ghcr.io/shopware/docker-base:8.3-caddy-otel AS base-image
FROM ghcr.io/shopware/docker-dev:php8.3-node24-caddy AS shopware-builder
FROM ghcr.io/shopware/shopware-cli:latest-php-8.3 AS shopware-cli

FROM shopware-builder AS setup

RUN printf "N\n" | new-shopware-setup

FROM shopware-cli AS build

COPY --from=setup /var/www/html /src
WORKDIR /src

RUN --mount=type=cache,target=/root/.composer \
    --mount=type=cache,target=/root/.npm \
    /usr/local/bin/entrypoint.sh shopware-cli project ci /src

FROM base-image AS final

COPY --from=build --chown=82 --link /src /var/www/html
