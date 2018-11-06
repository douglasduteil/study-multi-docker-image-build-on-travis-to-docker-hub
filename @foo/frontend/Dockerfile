ARG BASE_IMAGE=douglasduteil/study-multi-docker-image-build-on-travis-to-docker-hub:master

FROM ${BASE_IMAGE} as master

WORKDIR /app

FROM nginx:alpine

COPY --from=master ./@foo/fon/index.html /usr/share/nginx/html/index.html
