FROM node:19 AS src

# install deps
WORKDIR /build
ADD . .
RUN npm install

# build
RUN npm run build

# build caddy with caddy security
FROM caddy:2.6.2-builder AS builder
RUN xcaddy build --with github.com/greenpau/caddy-security@v1.1.18

# serve with caddy
FROM caddy:2.6.2
WORKDIR /portal

EXPOSE 80

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY --from=src /build/dist ./dist
COPY ./Caddyfile ./Caddyfile
CMD caddy run --config ./Caddyfile --adapter caddyfile
