FROM node:16

WORKDIR /cloudapp/server
COPY . .
RUN npm ci

EXPOSE 8000
ENTRYPOINT [ "node", "server.js" ]