# build environment
FROM node:14-alpine as react-build
WORKDIR /app
COPY . ./
RUN yarn
RUN yarn build

# server environment
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/configfile.template

COPY --from=react-build /app/build /usr/share/nginx/html

# Set environment variables
ENV BACKEND_URL=https://api-grupo09-prod-bmhkhouqrq-uc.a.run.app/

ENV PORT 8080
ENV HOST 0.0.0.0
EXPOSE 8080
CMD sh -c "envsubst '\$PORT' < /etc/nginx/conf.d/configfile.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"