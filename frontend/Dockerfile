# ==================== сборка ====================
FROM node:16-alpine AS build

WORKDIR /app

# package.json и зависимости
COPY package*.json ./
RUN npm ci

# исходники и сборка проекта
COPY . .
RUN npm run build

# ==================== запуск ====================
FROM nginx:latest

# собранные файлы из этапа сборки
COPY --from=build /app/build /usr/share/nginx/html

# копируем конфигурацию nginx
COPY nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# порт 80
EXPOSE 80

# nginx
CMD ["nginx", "-g", "daemon off;"]