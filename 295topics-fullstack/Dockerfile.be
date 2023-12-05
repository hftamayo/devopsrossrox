FROM node:16-alpine AS builder

WORKDIR /295fullstack

COPY ./backend/*.json  ./

RUN apk add yarn
RUN apk add bash
RUN apk add curl

RUN yarn install --frozen-lockfile

COPY ./backend/. .

RUN yarn add dotenv

COPY ./backend/.env.template ./.env
RUN sed -i '1iNODE_ENV=testing01' ./.env
RUN sed -i 's/DATABASE_URL=.*$/DATABASE_URL=mongodb:\/\/testing02:1234/' ./.env
RUN sed -i 's/DATABASE_NAME=.*$/DATABASE_NAME=testing04/' ./.env
RUN sed -i 's/HOST=.*$/HOST=testing05/' ./.env
RUN sed -i 's/PORT=.*$/PORT=5678/' ./.env

#ENV NODE_ENV=development
#ENV DATABASE_URL=mongodb://mongodb:27017
#ENV DATABASE_NAME=TopicstoreDB
#ENV HOST=localhost
#ENV PORT=5000

EXPOSE 5000

CMD ["yarn", "run", "start:with-env"]
