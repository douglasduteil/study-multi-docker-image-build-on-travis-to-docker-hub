ARG BASE_IMAGE=douglasduteil/study-multi-docker-image-build-on-travis-to-docker-hub:master

FROM ${BASE_IMAGE} as master

WORKDIR /app

FROM node:11

COPY --from=master /app/@foo/api/package.json /app/package.json
COPY --from=master /app/@foo/api/index.js /app/index.js

ENTRYPOINT ["yarn", "start"]
