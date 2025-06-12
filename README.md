
Custom set of scripts for managing my server.

Server data is stored in a separate "server-data" file and then copied to an "online-servers" file, which determines what is running and is read for info on the server. The json data that a server can have is as follows:
- maxRAM: Used for determining server resource demand if running that process. Also used for RAM allocation in certain processes. (Recommended, default 0)
- processorWeight: Setting this to 100 would mean that this process is expected to take 100% of the system's processor usage. Used to calculate if a process can be run without exhausting server resources. (Recommended, default 0)
- type: Used to determine how to start the server. (Options: minecraft)
- directory: Folder for the server. Must include `run.sh`, which will be executed on server start. (Required)
