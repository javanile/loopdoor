#!/bin/bash

##
# javanile/loopdoor (v0.0.1)
# Reverse SSH tunnel for Docker
##

## Variables
r="^([^:]*)(:([0-9]+))?$" && [[ "${LOOPDOOR_HOST}" =~ $r ]] && h="${BASH_REMATCH[1]}" && p="${BASH_REMATCH[3]}"
HOST=${h:-localhost}
PORT=${p:-55555}
USER=${LOOPDOOR_USER:-loopdoor}
PASS=${LOOPDOOR_PASSWORD:-loopdoor}

## Apply password
echo "backdoor:${PASS}" | chpasswd

## Run as master
if [ -n "${LOOPDOOR_HOST}" ]; then
    sleep 1
    echo "(*) Master listen on port '${PORT}'."
    /usr/sbin/sshd
    while sleep 5; do
        echo "(*) Try opening connection..."
        ssh -p 5000 -l ${USER} 127.0.0.1
    done
    echo "(?) Unexpected error."
    exit 1
fi

## Run as slave
while sleep 5; do
    echo "(*) Try slave connection..."
    sshpass -p ${PASSWORD} \
    shh -o StrictHostKeyChecking=accept-new \
        -R 5000:127.0.0.1:55555 \
        -p ${PORT} loopdoor@${HOST}
done
echo "(?) Unexpected error."
exit 1
