#!/bin/bash
# Arguments: server directory, system user for program, 
# minimum RAM, maximum RAM
directory=$1
user=$2

cd "$1"
bash scripts.sh start &

while true; do
    bash scripts.sh run &
    echo "Starting $1/run.sh..."
    sudo -u "$user" "$directory/run.sh" "$3" "$4"

    echo "$directory/run.sh stopped. Restarting in 10 seconds..."
    bash scripts.sh stop &

    sleep 10
done
