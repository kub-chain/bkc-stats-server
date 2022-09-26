FROM node:lts-alpine AS builder
ARG GRUNT_TASK=default
ARG NETWORK_NAME=BitkubChain
WORKDIR /bkcstats-server
COPY ["package.json", "package-lock.json*", "./"]
RUN npm ci --only=production && npm install -g grunt-cli
COPY --chown=node:node . .
RUN sed -i s/"BKC"/"${NETWORK_NAME}"/g src/js/defaultConfig.js
RUN grunt $GRUNT_TASK

FROM node:lts-alpine
RUN apk add dumb-init
WORKDIR /bkcstats-server
COPY --chown=node:node --from=builder /bkcstats-server .
USER node
EXPOSE  3000
CMD ["dumb-init", "node", "./bin/www"]
