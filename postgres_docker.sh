#!/bin/bash

docker run -d \
-e POSTGRES_DB=roomx_dev \
-e POSTGRES_USER=postgres \
-e POSTGRES_PASSWORD=postgres \
--name roomx_postgresql \
-v roomx_postgresql_dbdata:/var/lib/postgresql/data \
-p 5432:5432 postgres:alpine
