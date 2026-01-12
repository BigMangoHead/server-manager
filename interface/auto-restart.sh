#!/bin/bash
ALL_ARGS=("$@")
arguments=("${ALL_ARGS[@]:2}")
program=$1
user=$2

while true; do
    echo "Starting $program..."
    sudo -u "$user" "$program" $arguments

    echo "$program stopped. Restarting in 10 seconds..."

    sleep 10
done
