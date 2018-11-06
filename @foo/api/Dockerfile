ARG BASE_IMAGE=douglasduteil/study-multi-docker-image-build-on-travis-to-docker-hub:master as builder

FROM ${BASE_IMAGE} as builder

WORKDIR /app

FROM node:11

COPY --from=builder ./@foo/api/package.json /app/package.json
COPY --from=builder ./@foo/api/index.js /app/index.js

ENTRYPOINT ["yarn", "start"]
