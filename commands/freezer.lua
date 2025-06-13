
local serverinterface = require("serverinterface")
local jsonhandler = require("jsonhandler")

local freezer = {}

function freezer.freeze()
    local freezeFile = io.open(FREEZE_FILE_PATH, 'w')
    freezeFile:write("1")
    freezeFile:close()

    local _, onlineServers = jsonhandler.getServers()
    for n, s in pairs(onlineServers) do
        s.name = n
    end

    serverinterface.stopServers(onlineServers)
end

function freezer.unfreeze()
    local freezeFile = io.open(FREEZE_FILE_PATH, 'w')
    freezeFile:write("0")
    freezeFile:close()

    local _, onlineServers = jsonhandler.getServers()
    for n, s in pairs(onlineServers) do
        s.name = n
    end

    serverinterface.startServers(onlineServers)
end

return freezer
