#!/bin/bash
# Arguments: [process step], [server directory], [game system user]
# Run inside the server directory (not instance folder) by the main user
# Note: this script is blocking! Also be careful with calling background tasks
# as the shell will exit shortly after running for things like stop or close

if [ "$1" = start ]; then # Runs on screen creation
    true # Replace this with code
elif [ "$1" = run ]; then # Runs right before server starts each time
    true
elif [ "$1" = stop ]; then # Runs right after server stops (including crahes)
    true
elif [ "$1" = close ]; then # Runs right before screen is exited
    true
fi
