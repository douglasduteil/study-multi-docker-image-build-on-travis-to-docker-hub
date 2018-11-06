# Study multi docker image build on Travis to Docker Hub

[![Build Status](https://travis-ci.com/douglasduteil/study-multi-docker-image-build-on-travis-to-docker-hub.svg?branch=master)](https://travis-ci.com/douglasduteil/study-multi-docker-image-build-on-travis-to-docker-hub)

> :microscope: Studying multiple docker image publication from a monorepo through Travis to Docker Hub

<br>
<br>
<br>
<br>

## The problem

Yarn Workspace allow us to share installed dependencies, making monorepo faster, smaller to install and packages linking easier. However in a Docker context that can be counter intuitive as now any packages in the monorepo requires every monorepo dependencies to be installed to build. Yet I would argue that it is the monorepo goal to sync all builds in one context so that some packages can be used as transitive resources.  

<br>
<br>
<br>
<br>

## This study

I'm exploring how we can share an *master* docker image to :

- build all the packages
- test all the packages
- create standalone image ready to be used

The process is sync with Travis and deployed on Docker Hub.

<br>
<br>

<h3 align=center>Most of the evil magic here is in the `.travis.yml` file !</h3>

<br>
<br>
<br>
<br>

## Installation

### System driven

You can locally install the fake `@foo` app by running `yarn`

### Docker driven

You can use the root [Dockerfile](./Dockerfile) to have ready to use environment

```sh
# "smdibottdh" is short for "study-multi-docker-image-build-on-travis-to-docker-hub"
$ docker build -t smdibottdh .
```

<br>
<br>
<br>
<br>

## Usage

`@foo/*` is not a real application but you can still poke it.

### System driven

You can print a `hello world`

```sh
$ yarn workspace @foo/api start 
```

### Docker driven

You can print a `hello world`

```sh
$ docker run --rm -p 8080:80 smdibottdh yarn workspace @foo/api start 
```

<br>
<br>
<br>
<br>

## Run

Each packages have them own docker-compose for the "production".  
Note that they are using [published images](https://hub.docker.com/r/douglasduteil/study-multi-docker-image-build-on-travis-to-docker-hub/tags/) !  
I'm using 
- `*:master` tag for the current builder we have on the master branch
- `*:latest-api` tag for the latest @foo/api package image
- `*:latest-frontend` tag for the latest @foo/frontend package image
- `*:build.XX.master.YYYYYYY` tags are temporary images used by the CI (Travis) to build, test and create the above images

You can test the api with :

```sh
$ docker-compose -f @foo/api/docker-compose.yml up
```

You can test the frontend with :

```sh
$ docker-compose -f @foo/frontend/docker-compose.yml up
```

### Local production like build

You can locally create a production build by using the separate Dockerfiles in each packages.  
By default, they are using the latest published `master` branch image but you can change it by using the `BASE_IMAGE` arguments.

For example:

```sh
# I'm building the api to an image named "smdibottdh:api" using the previous built "smdibottdh" master image.
$ docker build -f ./@foo/api/Dockerfile -t smdibottdh:api --build-arg BASE_IMAGE=smdibottdh .
# Same for the frontend
$ docker build -f ./@foo/frontend/Dockerfile -t smdibottdh:frontend --build-arg BASE_IMAGE=smdibottdh .
```

If you want to use the existing docker-compose config, you might want to name or tag your image accordingly.

```sh
# For the propose of the study...
$ docker tag smdibottdh:frontend douglasduteil/study-multi-docker-image-build-on-travis-to-docker-hub:latest-frontend
# or
$ docker build -f ./@foo/frontend/Dockerfile -t douglasduteil/study-multi-docker-image-build-on-travis-to-docker-hub:latest-frontend --build-arg BASE_IMAGE=smdibottdh .

# Now docker will use your local image
$ docker-compose -f @foo/frontend/docker-compose.yml up
```

<br>
<br>
<br>
<br>

## Clean up

Don't forget to clean up those useless images ;)

```sh
$ docker-compose -f @foo/api/docker-compose.yml rm
$ docker-compose -f @foo/frontend/docker-compose.yml rm
# optional
$ docker rmi $(sudo docker images --filter "dangling=true" -q --no-trunc)
$ docker images -a | grep 'douglasduteil\|smdibottdh' | awk '{print $3}' | xargs docker rmi
```
