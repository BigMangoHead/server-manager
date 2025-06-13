
local jsonhandler = require("jsonhandler")
local update = require("update")

local runner = {}

function runner.run(name) 
    serverData, onlineServerData = jsonhandler.getServers()

    if serverData[name] == nil then
        error("No server with that name!")
    end

    onlineServerData[name] = serverData[name]
    jsonhandler.updateOnlineServers(onlineServerData)

    update.run()
end

function runner.stop(name)
    serverData, onlineServerData = jsonhandler.getServers()

    onlineServerData[name] = nil
    jsonhandler.updateOnlineServers(onlineServerData)

    update.run()
end
    

return runner
