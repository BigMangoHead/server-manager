
local screenhandler = require("screen")
local jsonhandler = require("jsonhandler")

local info = {}

function info.status()
    local serverData, onlineServerData, miscData = jsonhandler.getServers()
    local screens = screenhandler.getScreens()
    freezeStatus = miscData.frozen

    if freezeStatus == "0" then
        print("Servers currently not frozen.")
    else
        print("SERVERS CURRENTLY FROZEN.")
    end
    print("Current running screens: [" .. table.concat(screens, ", ") .. "]")
    print("Online servers: ")
    for k, v in pairs(onlineServerData) do
        print("    " .. k)
        for a, b in pairs(v) do
            print("        " .. tostring(a) .. ": " .. tostring(b))
        end
    end
end

return info
