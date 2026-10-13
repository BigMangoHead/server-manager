instance directory contains server files, will be owned by game system user

run.sh will be run by the game system user and should start the game server

scripts.sh will be run by the manager user with the first argument being either:
- start (called when the screen is initialized)
- run (called right before run.sh is executed)
- stop (called after run.sh finishes execution, such as after a crash)
- close (called after run.sh finishes execution and right before the screen will be closed)

.server-check is an empty file that just verifies we are in a game server directory.
Not used consistently, mainly for some scary operations like when changing file ownership.

.running is an automatically generated file that stores either a 1 or 0 to denote whether the server should be running
