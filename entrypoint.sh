#!/bin/bash

##
# javanile/loopdoor (v0.0.1)
##

echo "----[ loopdoor v0.0.1 ]----"

## Variables
r="^([^:]*)(:([0-9]+))?$" && [[ "${LOOPDOOR_HOST}" =~ $r ]] && h="${BASH_REMATCH[1]}" && p="${BASH_REMATCH[3]}"
HOST=${h:-localhost}
PORT=${p:-55555}
USER=${LOOPDOOR_USER:-loopdoor}
PASS=${LOOPDOOR_PASSWORD:-loopdoor}

## Apply password
echo "loopdoor:${PASS}" | chpasswd

## Run as master
if [ -z "${LOOPDOOR_HOST}" ]; then
    echo "(*) Master node listen on port '${PORT}'."
    /usr/sbin/sshd
    while sleep 5; do
        echo "(*) Try opening connection..."
        sshpass -p ${PASS} \
        ssh -o StrictHostKeyChecking=accept-new \
            -p 5000 -l ${USER} 127.0.0.1
        echo "(!) Press Ctrl+C to exit."
    done
    echo "  Exit."
    exit 1
fi

## Run as slave
while sleep 5; do
    echo "(*) Slave node initialization..."
    /usr/sbin/sshd
    echo "(*) Try slave to master connection..."
    sshpass -p ${PASS} \
    ssh -o StrictHostKeyChecking=accept-new \
        -R 5000:127.0.0.1:55555 -p ${PORT} -l loopdoor ${HOST}
    echo "(!) Press Ctrl+C to exit."
done
echo "  Exit."
exit 1