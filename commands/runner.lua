
local jsonhandler = require("jsonhandler")
local update = require("update")

local runner = {}

function runner.run(args) 
    serverData, onlineServerData = jsonhandler.getServers()

    for _, name in ipairs(args.servers) do
        if serverData[name] == nil then
            error("No server with that name!")
        end

        onlineServerData[name] = serverData[name]
    end

    jsonhandler.updateOnlineServers(onlineServerData)
    update.run()
end

function runner.stop(args)
    serverData, onlineServerData = jsonhandler.getServers()

    for _, name in ipairs(args.servers) do
        onlineServerData[name] = nil
    end

    jsonhandler.updateOnlineServers(onlineServerData)
    update.run()
end
    

return runner
