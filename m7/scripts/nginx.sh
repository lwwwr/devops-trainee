#!/bin/bash

sudo apt-get update
sudo apt-get install nginx -y
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt-get update
sudo apt-get install certbot python-certbot-nginx -y

cat <<EOF > /etc/nginx/nginx.conf
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;
events {
        worker_connections 768;
}
http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
    gzip on;
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
    upstream tomcat {
EOF

for ip in ${tomcat_ips}; do
    echo "    server $ip:8080;" >> /etc/nginx/nginx.conf
done

cat <<EOF >> /etc/nginx/nginx.conf
    }
}
EOF

cat <<EOF > /etc/nginx/sites-available/proxy.conf
server {
    listen 80;
    server_name  nginx.alavr.test.coherentprojects.net;
    location / {
    proxy_pass http://tomcat;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/proxy.conf /etc/nginx/sites-enabled/proxy.conf
sudo systemctl reload nginx.service

sudo certbot    --nginx \
                --agree-tos \
                --register-unsafely-without-email \
                -d nginx.alavr.test.coherentprojects.net \
                --non-interactive \
                --redirect