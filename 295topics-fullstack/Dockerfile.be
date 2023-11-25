FROM node:16-alpine AS builder

WORKDIR /295fullstack

COPY ./backend/package.json  ./

RUN apk add yarn

RUN yarn install --frozen-lockfile

COPY ./backend/.env.template ./.env

ENV DATABASE_URL=mongodb://mongodb:27017
ENV DATABASE_NAME=TopicstoreDB
ENV HOST=localhost
ENV PORT=5000

COPY ./backend/. .

CMD ["yarn", "start"]
