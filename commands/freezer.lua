
local serverinterface = require("serverinterface")
local jsonhandler = require("jsonhandler")

local freezer = {}

function freezer.freeze()
    local _, onlineServers, miscServerData = jsonhandler.getServers()
    miscServerData.frozen = true
    jsonhandler.updateMiscServerData(miscServerData)

    for n, s in pairs(onlineServers) do
        s.name = n
    end

    -- This stops all servers listed in the onlineServers
    -- file. Might want to check that the server being stopped
    -- actually still has an attached screen.
    serverinterface.stopServers(onlineServers)
end

function freezer.unfreeze()
    local _, _, miscServerData = jsonhandler.getServers()
    miscServerData.frozen = false
    jsonhandler.updateMiscServerData(miscServerData)

    require("update").run()
end

return freezer
