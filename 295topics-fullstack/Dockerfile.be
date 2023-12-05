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
RUN sed -i '1iNODE_ENV=development' ./.env
RUN sed -i 's/DATABASE_URL=.*$/DATABASE_URL=mongodb:\/\/mongodb:27017/' ./.env
RUN sed -i 's/DATABASE_NAME=.*$/DATABASE_NAME=TopicstoreDB/' ./.env
RUN sed -i 's/HOST=.*$/HOST=0.0.0.0/' ./.env
RUN sed -i 's/PORT=.*$/PORT=5000/' ./.env

#ENV NODE_ENV=development
#ENV DATABASE_URL=mongodb://mongodb:27017
#ENV DATABASE_NAME=TopicstoreDB
#ENV HOST=localhost
#ENV PORT=5000

EXPOSE 5000

CMD ["yarn", "run", "start:with-env"]
