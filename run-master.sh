#!/bin/bash

##
# javanile/loopdoor (v0.0.1)
# Reverse SSH tunnel for Docker
##

docker-compose down --remove-orphans
docker-compose build
docker-compose run --rm -e LOOPDOOR_USER=ubuntu -e LOOPDOOR_PASSWORD=P4ssw0rd -p 10022:10022 loopdoor
