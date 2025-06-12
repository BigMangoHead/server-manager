#!/bin/bash
FILE_LOCK_LOC=~/scripts/data/mserver-lock

flock "$FILE_LOCK_LOC" lua mserver.lua "$@"
