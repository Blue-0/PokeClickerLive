FROM node:22-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY web ./web
RUN npm run build
FROM nginx:stable-alpine
COPY --from=build /app/web/dist /usr/share/nginx/html
EXPOSE 80
