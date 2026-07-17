FROM debian:11-slim
RUN apt-get update && \
apt-get install -y --no-install-recommends nginx && \
mkdir -p /opt/www && \
rm -rf /var/lib/apt/lists/*

COPY index.html /opt/www/index.html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]