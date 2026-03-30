#!/bin/bash

DOMAIN="andanteassaiwishlist.nomorepartiessite.ru"
API_DOMAIN="api.andanteassaiwishlist.nomorepartiessite.ru"

echo "Starting deployment for $DOMAIN"

# копируем env файл,если нет
if [ ! -f .env ]; then
    cp .env.example .env
    echo "Created .env file. Edit it with real values!"
    exit 1
fi

# запускаем контейнеры
docker-compose up -d --build

# устанавливаем nginx, если нет
if ! command -v nginx &> /dev/null; then
    sudo apt update
    sudo apt install -y nginx
fi

# копируем конфиг nginx
sudo cp nginx/nginx.conf /etc/nginx/sites-available/$DOMAIN
sudo ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# certbot и получаем SSL
if ! command -v certbot &> /dev/null; then
    sudo apt install -y certbot python3-certbot-nginx
fi

sudo certbot --nginx -d $DOMAIN -d $API_DOMAIN --non-interactive --agree-tos --email julyshb@yandex.ru

echo "Deployment complete!"
echo "Frontend: https://$DOMAIN"
echo "Backend: https://$API_DOMAIN"