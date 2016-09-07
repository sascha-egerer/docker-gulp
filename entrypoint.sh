#!/usr/bin/env bash

set -e

# start styleguide
if [[ -n "$START_STYLEGUIDE" ]]
then
    gulp styleguide > /dev/null &

    set +e
    COUNTER=0
    while [ "$(curl --write-out %{http_code} --silent --output /dev/null http://localhost:3000)" -ne '200' ]; do
        let COUNTER=COUNTER+1
        if [ $COUNTER -eq 20 ]
        then
            echo "Could not start styleguide. Looks like you have problem."
            echo "Try to start the styleguide on your machine. Giving up..."
            exit 1;
        fi
        echo "Wait for the styleguide to start..."
        sleep 2
    done
    set -e
    echo "Styleguide is started!"
fi

trap 'kill -TERM $PID' TERM INT
$@ &
PID=$!

wait $PID
trap - TERM INT
wait $PID
EXIT_STATUS=$?
