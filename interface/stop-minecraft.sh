#!/bin/bash

function run()
{
screen -XS "$1" stuff "\nsay Automated Message: Server is shutting down.\n"
screen -XS "$1" stuff "save-all\n"
sleep 10
screen -XS "$1" stuff "stop\n"
sleep 10
screen -XS "$1" quit
}

run "$1" &
