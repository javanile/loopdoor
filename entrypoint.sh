#!/bin/bash

##
# javanile/loopdoor (v0.0.1)
##

echo "----[ loopdoor v0.0.1 ]----"

## Variables
r="^([^:]*)(:([0-9]+))?$" && [[ "${LOOPDOOR_HOST}" =~ $r ]] && h="${BASH_REMATCH[1]}" && p="${BASH_REMATCH[3]}"
HOST=${h:-localhost}
PORT=${p:-55555}
: ${LOOPDOOR_PASSWORD:=loopdoor}
: ${SLAVE_USER:=loopdoor}
: ${SLAVE_PASSWORD:=loopdoor}
: ${SLAVE_SIDE:=55555}
: ${SLAVE_BIND:=10000}

## Apply password
echo "loopdoor:${LOOPDOOR_PASSWORD}" | chpasswd

## Clean-up known hosts
ssh-keygen -R "${HOST}:${PORT}" > /dev/null 2>&1
ssh-keygen -R "[${HOST}]:${PORT}" > /dev/null 2>&1

## Run as 'master'
if [ -z "${LOOPDOOR_HOST}" ]; then
    echo "(*) Master node listen on port '${PORT}'."
    /usr/sbin/sshd
    while sleep 5; do
        echo "(*) Try opening connection on bind '${SLAVE_BIND}'..."
        if [ -n "${SLAVE_PASSWORD}" ]; then
            sshpass -p ${SLAVE_PASSWORD} \
            ssh -o StrictHostKeyChecking=accept-new \
                -p ${SLAVE_BIND} -l ${SLAVE_USER} 127.0.0.1
        else
            ssh -o StrictHostKeyChecking=accept-new \
                -p ${SLAVE_BIND} -l ${SLAVE_USER} 127.0.0.1
        fi
        echo "(!) Press Ctrl+C to exit."
    done
    echo "  Exit."
    exit 1
fi

## Run as 'slave'
while sleep 5; do
    echo "(*) Slave node initialization..."
    /usr/sbin/sshd
    echo "(*) Try slave to master connection at '${HOST}' on port '${PORT}'..."
    sshpass -p ${LOOPDOOR_PASSWORD} \
    ssh -o StrictHostKeyChecking=accept-new \
        -R ${SLAVE_BIND}:127.0.0.1:${SLAVE_SIDE} -p ${PORT} -l loopdoor ${HOST}
    echo "(!) Press Ctrl+C to exit."
done
echo "  Exit."
exit 1
