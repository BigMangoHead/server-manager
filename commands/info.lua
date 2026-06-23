
local screenhandler = require("screen")
local jsonhandler = require("jsonhandler")

local info = {}

function info.status()
    local serverData, onlineServerData, miscData = jsonhandler.getServers()
    local screens = screenhandler.getScreens()

    if miscData.frozen then
        print("SERVERS CURRENTLY FROZEN.")
    else
        print("Servers currently not frozen.")
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
