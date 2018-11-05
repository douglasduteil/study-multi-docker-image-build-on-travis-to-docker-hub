FROM node:11

WORKDIR /app

COPY . /app

RUN yarn

RUN yarn build
