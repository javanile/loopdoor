#!/bin/bash

##
# javanile/loopdoor (v0.0.1)
##

docker-compose run --rm -e LOOPDOOR_HOST=master0:55555 -e LOOPDOOR_PASSWORD=P4ssw0rd slave
