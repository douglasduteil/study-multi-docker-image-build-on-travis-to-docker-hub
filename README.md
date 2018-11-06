# Study multi docker image build on Travis to Docker Hub

[![Build Status](https://travis-ci.com/douglasduteil/study-multi-docker-image-build-on-travis-to-docker-hub.svg?branch=master)](https://travis-ci.com/douglasduteil/study-multi-docker-image-build-on-travis-to-docker-hub)

> :microscope: Studying multiple docker image publication from a monorepo through Travis to Docker Hub

## The problem

Yarn Workspace allow us to share installed dependencies, making monorepo faster, smaller to install and packages linking easier. However in a Docker context that can be counter intuitive as now any packages in the monorepo requires every monorepo dependencies to be installed to build. Yet I would argue that it is the monorepo goal to sync all builds in one context so that some packages can be used as transitive resources.  

## This study

I'm exploring how we can share an *master* docker image to :

- build all the packages
- test all the packages
- create standalone image ready to be used

The process is sync with Travis and deployed on Docker Hub.

<h3 align=center>Most of the evil magic here is in the `.travis.yml` file !</h3>

## Installation

### System driven

You can locally install the fake `@foo` app by running `yarn`

### Docker driven

You can use the root [Dockerfile](./Dockerfile) to have ready to use environment

```sh
# "smdibottdh" is short for "study-multi-docker-image-build-on-travis-to-docker-hub"
$ docker build -t smdibottdh .
```

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

## Run

Each packages have them own docker-compose for the "production".  
Note that they are using published images !

You can test the api with :

```sh
$ docker-compose -f @foo/api/docker-compose.yml up
```

You can test the frontend with :

```sh
$ docker-compose -f @foo/frontend/docker-compose.yml up
```

## Clean up

Don't forget to clean up those useless images ;)

```sh
$ docker-compose -f @foo/api/docker-compose.yml rm
$ docker-compose -f @foo/frontend/docker-compose.yml rm
# optional
$ docker rmi $(sudo docker images --filter "dangling=true" -q --no-trunc)
$ docker images -a | grep 'douglasduteil\|smdibottdh' | awk '{print $3}' | xargs docker rmi
```
