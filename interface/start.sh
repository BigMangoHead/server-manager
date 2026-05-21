#!/bin/bash
# Arguments: server directory, system user for program, 
# minimum RAM, maximum RAM
directory=$1
user=$2
minRAM=$3
maxRAM=$4
autorestart=$5

cd "$1"
echo 1 > "$directory/.running"
bash scripts.sh start "$directory" "$user" &

while true; do
    bash scripts.sh run "$directory" "$user" &
    echo "Starting $directory/run.sh..."
    sudo -u "$user" "$directory/run.sh" "$minRAM" "$maxRAM"

    bash scripts.sh stop "$directory" "$user" &

    if [[ $(cat "$directory/.running") = 0 || $autorestart = 0 ]]; then 
        break 
    fi

    echo "$directory/run.sh stopped. Restarting in 10 seconds..."
    sleep 10
done

# Scuffed solution when autorestart is disabled.
# We just keep the screen open so it isn't restarted.
while [[ $autorestart = 0 ]]; do
    sleep 10
    if [[ $(cat "$directory/.running") = 0 ]]; then 
        break
    fi
done
