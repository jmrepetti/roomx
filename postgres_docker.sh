#!/bin/bash

podman inspect roomx_postgresql 1> /dev/null 2> /dev/null

if [ $? -eq 0 ]
then # start existing container
  podman start roomx_postgresql
else # create postgres container
  podman run -d \
  -e POSTGRES_DB=roomx_dev \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  --name roomx_postgresql \
  -v roomx_postgresql_dbdata:/var/lib/postgresql/data:z \
  -p 5432:5432 postgres:alpine
fi