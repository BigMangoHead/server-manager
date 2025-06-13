local json = require("lunajson")

local jsonhandler = {}

-- Parse servers
function jsonhandler.getServers()
    local serverDataFile, error = io.open(SERVER_DATA_PATH)
    if not serverDataFile then
        error("Error opening server data file: " .. error)
    end
    local serverData = json.decode(serverDataFile:read("*all"))
    serverDataFile:close()

    local onlineServerDataFile, error = io.open(ONLINE_SERVER_DATA_PATH)
    if not onlineServerDataFile then
        error("Error opening online server data file: " .. error)
    end
    local onlineServerData = json.decode(onlineServerDataFile:read("*all"))
    onlineServerDataFile:close()

    io.stderr:write("STATUS: Successfully decoded server data and online server data.\n")

    return serverData, onlineServerData
end

function jsonhandler.updateServerData(data)
    local jsondata = json.encode(data)
    local serverDataFile, error = io.open(SERVER_DATA_PATH, 'w')
    if not serverDataFile then
        error("Error opening server data file: " .. error)
    end
    serverDataFile:write(jsondata)
    serverDataFile:close()
end

function jsonhandler.updateOnlineServers(data)
    local jsondata = json.encode(data)
    local onlineServerDataFile, error = io.open(ONLINE_SERVER_DATA_PATH, 'w')
    if not onlineServerDataFile then
        error("Error opening online server data file: " .. error)
    end
    onlineServerDataFile:write(jsondata)
    onlineServerDataFile:close()
end

return jsonhandler
