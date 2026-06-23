local argparse = require("argparse")
local dotenv = require("lua-dotenv")
logger = require("logger")

local ok, err = dotenv.load("/path/to/.env")
if not ok then
  error("Could not load .env file:", err)
end

SERVER_DATA_PATH = dotenv.get("SERVER_DATA_PATH")
ONLINE_SERVER_DATA_PATH = dotenv.get("ONLINE_SERVER_DATA_PATH")
MISC_SERVER_DATA_PATH = dotenv.get("MISC_SERVER_DATA_PATH")
MAX_RAM = dotenv.get("MAX_RAM")
MY_PATH = dotenv.get("PROJECT_PATH") .. '/'
SYMLINK_PATH = dotenv.get("SYMLINK_DIR", nil)
package.path = package.path .. ";" .. MY_PATH .. "commands/?.lua;" .. MY_PATH .. "util/?.lua;" .. MY_PATH .. "interface/?.lua"


parser = argparse() {
    name = "mserv",
    description = "Scripts for managing gaming servers"
}

parser:command("update u", "Stops and starts servers as necessary to match the online server data file")
parser:command("status", "Gives all info about currently running servers")
local run = parser:command("run start", "Adds server(s) to the online server data file, then runs update to start it")
run:argument("servers"):args("+")
local stop = parser:command("stop", "Removes server(s) from the online server data file, then runs update to stop it")
stop:argument("servers"):args("+")
parser:command("generate", "Interactive command to generate server files from a template")
parser:command("freeze", "Stops all servers and prevents all updates until unfrozen")
parser:command("unfreeze", "Removes frozen flag and runs update")
local set = parser:command("set", "Store value for flag, and then run update")
set:argument("key")
set:argument("value")
set:flag("-n --no-update")

local args = parser:parse()

logger.status("Running command \"" .. table.concat(arg, " ") .. "\" at " .. os.date("%c") .. ".")

if args.update then require("update").run()
elseif args.status then require("info").status()
elseif args.run then require("runner").run(args)
elseif args.stop then require("runner").stop(args)
elseif args.freeze then require("freezer").freeze()
elseif args.unfreeze then require("freezer").unfreeze()
elseif args.set then require("settings").set(args)
elseif args.generate then require("generate").run()
end
