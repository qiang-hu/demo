FROM pristtlt/lnp-base:7.2-fpm-stretch  AS build

WORKDIR /var/web/www
COPY . .
