FROM node:11

WORKDIR /app

COPY ./package.json /app/package.json
COPY ./yarn.lock /app/yarn.lock
COPY ./@foo/api/package.json /app/@foo/api/package.json
COPY ./@foo/frontend/package.json /app/@foo/frontend/package.json

RUN yarn --frozen-lockfile

COPY . /app

RUN yarn build
