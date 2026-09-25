# ─────────────────────────────────────────────────────────
#  beeWork OTA Server
#  Lightweight Nginx image (config only — no static files).
#
#  All served files (index.html, manifest.json, .exe, .png)
#  live in ./public/ on the HOST and are volume-mounted at
#  runtime via docker-compose.yml.
#
#  To deploy a new version:
#    1. Drop new .exe into ./public/
#    2. Update ./public/manifest.json
#    3. docker compose restart      ← NO rebuild needed
# ─────────────────────────────────────────────────────────
FROM nginx:alpine

# Remove default Nginx welcome page
RUN rm -rf /usr/share/nginx/html/*

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy all web files (index.html, logo, manifest, setup.exe)
COPY public/ /usr/share/nginx/html/

EXPOSE 80

LABEL maintainer="Zen Computer Systems Sdn. Bhd."
LABEL description="beeWork OTA update server"
