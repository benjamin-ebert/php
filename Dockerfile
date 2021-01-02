# 7.3 is minimum requirement for Laravel 8
FROM php:7.3-fpm-stretch

# install caddy
RUN curl --silent --show-error --fail --location \
 --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
 "https://github.com/caddyserver/caddy/releases/download/v1.0.4/caddy_v1.0.4_linux_amd64.tar.gz" \
 | tar --no-same-owner -C /usr/bin -xz caddy \
# set correct permissions \
&& chmod 0755 /usr/bin/caddy \
# output caddy version \
&& caddy -version \
# install some php extensions needed for laravel \
&& docker-php-ext-install mbstring pdo pdo_mysql \
# create project root to be used by caddy (see Caddyfile) \
&& mkdir -p /srv/app/public

# copy Caddy configuration
COPY Caddyfile /etc/Caddyfile

# set the default working directory
WORKDIR /srv/app

# expose port 80
EXPOSE 80

# run caddy - this overrides the default CMD built into the php-fpm image
CMD ["/usr/bin/caddy", "--conf", "/etc/Caddyfile", "--log", "stdout"]

