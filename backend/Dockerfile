# ==================== сборка ====================
FROM node:16-alpine AS build

WORKDIR /app

# package.json и package-lock.json
COPY package*.json ./

# установка зависимостей
RUN npm ci

# исходный код
COPY . .

# сборка NestJS проекта
RUN npm run build

# ==================== запуск ====================
FROM node:16-alpine

WORKDIR /app

# установка pm2
RUN npm install -g pm2

# package.json для production
COPY package*.json ./

# production зависимости
RUN npm ci --only=production

# собранный билд с первого этапа
COPY --from=build /app/dist ./dist

# конфиг pm2
COPY ecosystem.config.js ./

# порт
EXPOSE 4000

# запуск через pm2-runtime
CMD ["pm2-runtime", "start", "ecosystem.config.js"]