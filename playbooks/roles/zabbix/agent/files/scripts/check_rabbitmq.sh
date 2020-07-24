#!/bin/sh
PATH=/usr/sbin:/sbin:${PATH}
RABBITMQCTL="timeout 25 rabbitmqctl"

if [ "$1" = "status" ]; then
    ST=`${RABBITMQCTL} status 2>&1`
    if echo "${ST}" | grep -q alarms ; then
        echo "${ST}" | grep "alarms,\[\]" | wc -l
    else
        echo "${ST}" | grep "uptime" | wc -l
    fi

    exit
fi

if [ "$1" = "lld_queues" ]; then
    FIRST="yes"
    echo '{'
    echo '  "data": ['
    for q in `${RABBITMQCTL} -q list_queues name | grep -v '^name$' | sort`; do
        if [ "${FIRST}" = "yes" ]; then
            FIRST="no"
        else
            echo ','
        fi
        echo '    {'
        echo '      "{#QUEUE_NAME}": "'${q}'"'
        echo -n '    }'
    done
    echo ''
    echo '  ]'
    echo '}'

    exit
fi

if [ "$1" = "queues_stat" ]; then
    ${RABBITMQCTL} -q list_queues name consumers messages messages_unacknowledged consumer_utilisation state | grep -v "^name.*consumers.*messages" | tr '\t' ':'

    exit
fi

${RABBITMQCTL} $*
