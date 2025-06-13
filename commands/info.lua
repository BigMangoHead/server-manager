
local screenhandler = require("screen")
local jsonhandler = require("jsonhandler")

local info = {}

function info.status()
    local serverData, onlineServerData = jsonhandler.getServers()
    local screens = screenhandler.getScreens()

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
