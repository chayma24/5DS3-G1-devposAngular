FROM nginx:1.23.2-alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY ./dist/5DS3-G1-devopsAngular /usr/share/nginx/html
EXPOSE 4200