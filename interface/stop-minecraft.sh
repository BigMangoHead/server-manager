#!/bin/bash

function run()
{
echo 0 > "$2/.running"
screen -XS "$1" stuff "\nsay Automated Message: Server is shutting down.\n"
screen -XS "$1" stuff "save-all\n"
sleep 5
screen -XS "$1" stuff "stop\n"
}

run "$1" "$2" &
