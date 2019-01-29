#!/bin/bash

##
# javanile/loopdoor (v0.0.1)
##

docker-compose down --remove-orphans
docker-compose build
docker-compose run --rm --name master0 \
    -e LOOPDOOR_USER=loopdoor -e LOOPDOOR_PASSWORD=P4ssw0rd \
    -p 55555:55555 master
