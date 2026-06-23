local argparse = require("argparse")

SERVER_DATA_PATH = "/home/bigma/scripts/data/mserver-data.json"
ONLINE_SERVER_DATA_PATH = "/home/bigma/scripts/data/mserver-online.json"
FREEZE_FILE_PATH = "/home/bigma/scripts/data/mserver-freeze"

-- In megabytes
MAX_RAM = 32768

MY_PATH="/home/bigma/coding/projects/server-manager/"
package.path = package.path .. ";" .. MY_PATH .. "commands/?.lua;" .. MY_PATH .. "util/?.lua;" .. MY_PATH .. "interface/?.lua"

logger = require("logger")


local parser = argparse() {
    name = "mserv",
    description = "Scripts for managing gaming servers"
}

parser:command("update u", "Stops and starts servers as necessary to match the online server data file")
parser:command("status", "Gives all info about currently running servers")
local run = parser:command("run start", "Adds server(s) to the online server data file, then runs update to start it")
run:argument("servers"):args("+")
local stop = parser:command("stop", "Removes server(s) from the online server data file, then runs update to stop it")
stop:argument("servers"):args("+")
parser:command("freeze", "Stops all servers and prevents all updates until unfrozen")
parser:command("unfreeze", "Removes frozen flag and runs update")

local args = parser:parse()

logger.status("Running command \"" .. table.concat(arg, " ") .. "\" at " .. os.date("%c") .. ".")

if args.update then require("update").run()
elseif args.status then require("info").status()
elseif args.run then require("runner").run(args.servers)
elseif args.stop then require("runner").stop(args.servers)
elseif args.freeze then require("freezer").freeze()
elseif args.unfreeze then require("freezer").unfreeze()
end
