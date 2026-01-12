
Custom set of scripts for managing my server.

Server data is stored in a separate "server-data" file and then copied to an "online-servers" file, which determines what is running and is read for info on the server. The json data that a server can have is as follows:
- maxRAM: Used for determining server resource demand if running that process. Also used for RAM allocation in certain processes. (Recommended, default 0)
- processorWeight: Setting this to 100 would mean that this process is expected to take 100% of the system's processor usage. Used to calculate if a process can be run without exhausting server resources. (Recommended, default 0)
- type: Used to determine how to start the server. (Options: minecraft, game (starts server with auto-restart script), default (runs run.sh in the directory))
- directory: Folder for the server. 

There is an expected format for this directory. It should contain the following files:
- instance directory: contains server files, will be owned by game system user 
(chown is used to force this, system user is created automatically with name ms-<server>)
- run.sh: will be run by the game system user and should start the game server
- scripts.sh: will be run by the manager user with the first argument being either:
    - start (called when the screen is initialized)
    - run (called right before run.sh is executed)
    - stop (called after run.sh finishes execution, such as after a crash)
- .server-check: is an empty file that just verifies we are in a game server directory.
Not used consistently, mainly for some scary operations like when changing file ownership.
- .running: generated automatically, file with 1 or 0 to denote whether the server should be running.
