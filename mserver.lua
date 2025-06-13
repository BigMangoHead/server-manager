
SERVER_DATA_PATH = "/home/bigma/scripts/data/mserver-data.json"
ONLINE_SERVER_DATA_PATH = "/home/bigma/scripts/data/mserver-online.json"
FREEZE_FILE_PATH = "/home/bigma/scripts/data/mserver-freeze"

-- In megabytes
MAX_RAM = 32768

MY_PATH="/home/bigma/scripts/lua/mserver/"
package.path = package.path .. ";" .. MY_PATH .. "commands/?.lua;" .. MY_PATH .. "util/?.lua;" .. MY_PATH .. "interface/?.lua"

io.stderr:write("STATUS: Running command \"" .. table.concat(arg, " ") .. "\" at " .. os.date("%c") .. ".\n")

if arg[1] == "update" then
    require("update").run()

elseif arg[1] == "status" then
    require("info").status()

elseif arg[1] == "run" then
    require("runner").run(arg[2])

elseif arg[1] == "stop" then
    require("runner").stop(arg)

elseif arg[1] == "edit" then
    require("edit").run(arg)

elseif arg[1] == "add" then
    require("add").run(arg)

elseif arg[1] == "freeze" then
    require("freezer").freeze()

elseif arg[1] == "unfreeze" then
    require("freezer").unfreeze()

end
