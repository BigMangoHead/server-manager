local json = require("lunajson")

local jsonhandler = {}

-- Parse servers
function jsonhandler.getServers()
    local serverDataFile, err = io.open(SERVER_DATA_PATH)
    if not serverDataFile then
        error("Error opening server data file: " .. err)
    end
    local serverData = json.decode(serverDataFile:read("*all"))
    serverDataFile:close()

    local onlineServerDataFile, err = io.open(ONLINE_SERVER_DATA_PATH)
    if not onlineServerDataFile then
        error("Error opening online server data file: " .. err)
    end
    local onlineServerData = json.decode(onlineServerDataFile:read("*all"))
    onlineServerDataFile:close()

    local miscServerDataFile, err = io.open(MISC_SERVER_DATA_PATH)
    if not miscServerDataFile then
        error("Error opening misc server data file: " .. err)
    end
    local miscServerData = json.decode(miscServerDataFile:read("*all"))
    miscServerDataFile:close()

    io.stderr:write("STATUS: Successfully decoded all server data.\n")

    return serverData, onlineServerData, miscServerData
end

local function updateJSONData(filePath, data, type)
    local jsondata = json.encode(data)
    local file, err = io.open(filePath, 'w')
    if not file then
        error("Error opening " .. type .. " file: " .. err)
    end
    file:write(jsondata)
    file:close()
end

function jsonhandler.updateServerData(data)
    updateJSONData(SERVER_DATA_PATH, data, "server data")
end

function jsonhandler.updateOnlineServers(data)
    updateJSONData(ONLINE_SERVER_DATA_PATH, data, "online server data")
end

function jsonhandler.updateMiscServerData(data)
    updateJSONData(MISC_SERVER_DATA_PATH, data, "misc server data")
end

return jsonhandler
