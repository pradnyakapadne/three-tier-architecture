#!/bin/sh
set -e

if [ -z "$API_URL" ]; then
  API_URL="http://localhost:8000"
fi

cat > /etc/nginx/conf.d/default.conf <<EOF
server {
    listen 80;

    location /products {
        proxy_pass $API_URL;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files \$uri /index.html;
    }
}
EOF

exec "$@"
