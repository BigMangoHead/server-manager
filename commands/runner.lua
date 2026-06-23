
local jsonhandler = require("jsonhandler")
local update = require("update")

local runner = {}

function runner.run(servers) 
    serverData, onlineServerData = jsonhandler.getServers()

    for _, name in ipairs(servers) do
        if serverData[name] == nil then
            error("No server with that name!")
        end

        onlineServerData[name] = serverData[name]
    end

    jsonhandler.updateOnlineServers(onlineServerData)
    update.run()
end

function runner.stop(servers)
    serverData, onlineServerData = jsonhandler.getServers()

    for _, name in ipairs(servers) do
        onlineServerData[name] = nil
    end

    jsonhandler.updateOnlineServers(onlineServerData)
    update.run()
end
    

return runner
