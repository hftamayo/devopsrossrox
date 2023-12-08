FROM node:18-alpine AS builder

WORKDIR /295fullstack

COPY ./backend/*.json  ./

RUN apk add yarn
RUN apk add bash
RUN apk add curl

RUN yarn install --frozen-lockfile

COPY ./backend/. .

RUN yarn add dotenv

COPY ./backend/.env.template ./.env
RUN sed -i '1iNODE_ENV=development' ./.env
RUN sed -i 's/DATABASE_URL=.*$/DATABASE_URL=mongodb:\/\/mongodb:27017/' ./.env
RUN sed -i 's/DATABASE_NAME=.*$/DATABASE_NAME=TopicstoreDB/' ./.env
RUN sed -i 's/HOST=.*$/HOST=0.0.0.0/' ./.env
RUN sed -i 's/PORT=.*$/PORT=5000/' ./.env

#adding a script for loading env with Typescript
RUN sed -i '/"scripts": {/a\    "start:with-env": "ts-node -r dotenv/config src\/app",' package.json

EXPOSE 5000

CMD ["yarn", "run", "start:with-env"]
