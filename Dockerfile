FROM node:20.7 AS src

# install deps
WORKDIR /build
ADD . .
RUN npm install

# build
RUN npm run build

# build caddy with caddy security
FROM caddy:2.7.4-builder AS builder
RUN xcaddy build --with github.com/greenpau/caddy-security@v1.1.20

# serve with caddy
FROM alpine:3.18.3
WORKDIR /portal

EXPOSE 80

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY --from=src /build/dist ./dist
COPY ./Caddyfile ./Caddyfile
CMD caddy run --config ./Caddyfile --adapter caddyfile
