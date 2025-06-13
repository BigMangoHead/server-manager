
local jsonhandler = require("jsonhandler")

local runcmd = {}

function runcmd.run(name) 
    serverData, onlineServerData = jsonhandler.getServers()

    if serverData[name] == nil then
        error("No server with that name!")
    end

    onlineServerData[name] = serverData[name]
    jsonhandler.updateOnlineServers(onlineServerData)

    require("update").run()
end

return runcmd
