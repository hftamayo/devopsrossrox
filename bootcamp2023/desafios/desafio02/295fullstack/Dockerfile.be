FROM node:16-alpine AS builder

WORKDIR /295fullstack

COPY package.json  ./

RUN apt update && pat install yarn

RUN yarn install --frozen-lockfile

RUN cp .env.template .env

ENV DATABASE_URL=mongodb://mongodb:27017
ENV DATABASE_NAME=TopicstoreDB
ENV HOST=localhost
ENV PORT=5000

COPY . .

CMD ["yarn", "start"]
