FROM node:latest as build

WORKDIR /home/node/

COPY ./ ./

RUN npm install \ 
        && npm run build

FROM nginx:latest

COPY --from=build /home/node/build/ /usr/share/nginx/html/

ARG DEFAULT_API_URL
ENV API_ROOT=${DEFAULT_API_URL:-"https://conduit.productionready.io/api"}

EXPOSE 80

CMD sed "s|https://conduit.productionready.io/api|${API_ROOT}|" -i /usr/share/nginx/html/static/js/* && exec nginx -g 'daemon off;'
