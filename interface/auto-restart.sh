#!/bin/bash
ALL_ARGS=("$@")
arguments=("${ALL_ARGS[@]:1}")
program=$1

while true; do
    echo "Starting $program..."
    $program $arguments

    echo "$program stopped. Restarting in 15 seconds..."

    sleep 15
done
