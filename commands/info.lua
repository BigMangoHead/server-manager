
local screenhandler = require("screen")
local jsonhandler = require("jsonhandler")

local info = {}

function info.status()
    local freezeFile = io.open(FREEZE_FILE_PATH)
    local freezeStatus = freezeFile:read("*all")
    freezeFile:close()
    local serverData, onlineServerData = jsonhandler.getServers()
    local screens = screenhandler.getScreens()

    if freezeStatus == 0 then
        print("Servers currently not frozen.")
    else
        print("SERVERS CURRENTLY FROZEN.")
    end
    print("Current running screens: [" .. table.concat(screens, ", ") .. "]")
    print("Online servers: ")
    for k, v in pairs(onlineServerData) do
        print("    " .. k)
        for a, b in pairs(v) do
            print("        " .. a .. ": " .. b)
        end
    end
end

return info
