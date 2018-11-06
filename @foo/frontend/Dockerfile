ARG BASE_IMAGE=douglasduteil/study-multi-docker-image-build-on-travis-to-docker-hub:master as builder

FROM ${BASE_IMAGE} as builder

WORKDIR /app

FROM nginx:alpine

COPY --from=builder ./@foo/fon/index.html /usr/share/nginx/html/index.html
