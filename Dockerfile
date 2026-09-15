# Vue / node-sass 4 still need Node 12. Runtime is Node 22.
FROM node:12 AS frontend
WORKDIR /app/front-end
COPY front-end/ /app/front-end/
RUN npm install && npm run-script build

FROM node:22
WORKDIR /app
COPY package.json package-lock.json /app/
RUN npm install
COPY --from=frontend /app/front-end/dist /app/front-end/dist
COPY server.js probe.js constants.js notification.js database.js api.js app.js utils.js /app/
COPY docker-entrypoint.sh /app/
RUN chmod +x /app/docker-entrypoint.sh
COPY templates /app/templates

# HTTP only; Caddy terminates TLS on 80/443
EXPOSE 8080

ENTRYPOINT ["/app/docker-entrypoint.sh"]
