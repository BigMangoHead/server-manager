local json = require("lunajson")
local screenhelper = require("screen")
local serverinterface = require("serverinterface")

local update = {}

function update.run()
    serverDataFile, error = io.open(SERVER_DATA_PATH)
    if not serverDataFile then
        error("Error opening server data file: " .. error)
    end
    serverData = json.decode(serverDataFile:read("*all"))
    serverDataFile:close()

    onlineServerDataFile, error = io.open(ONLINE_SERVER_DATA_PATH)
    if not onlineServerDataFile then
        error("Error opening online server data file: " .. error)
    end
    onlineServerData = json.decode(onlineServerDataFile:read("*all"))
    onlineServerDataFile:close()

    io.stderr:write("STATUS: Successfully decoded server data and online server data.\n")

    for name, server in pairs(onlineServerData) do
        if not server.priority then
            io.stderr:write("WARNING: Server \"" .. name .. "\" had no set priority; assuming priority to be 0.\n")
            server.priority = 0
        end
    end

    -- Convert online server data to an array 
    -- Then sort that array in decreasing priority
    local a = {}
    for name, server in pairs(onlineServerData) do
        server.name = name
        table.insert(a, server)
    end
    onlineServerData = a
    function prioritySort(a, b) 
        return (a.priority > b.priority)
    end
    table.sort(onlineServerData, prioritySort)

    -- Generate servers to run, prioritizing those with higher priority
    serversToRun = {}
    totalRAM = 0
    processorWeight = 0
    for _, server in ipairs(onlineServerData) do
        if server.maxRAM then
            totalRAM = totalRAM + server.maxRAM
        end
        if server.processorWeight then
            processorWeight = processorWeight + server.processorWeight
        end

        if processorWeight > 100 or totalRAM > MAX_RAM then
            if processorWeight > 100 and totalRAM > MAX_RAM then
                io.stderr:write("STATUS: Processor weight maximum and RAM maximum would be reached by running \"" .. server.name .. "\", skipping.\n")
            elseif processorWeight > 100 then
                io.stderr:write("STATUS: Processor weight maximum would be reached by running \"" .. server.name .. "\", skipping.\n")
            else 
                io.stderr:write("STATUS: RAM maximum would be reached by running \"" .. server.name .. "\", skipping.\n")
            end

            if server.processorWeight then processorWeight = processorWeight - server.processorWeight end
            if server.maxRAM then totalRAM = totalRAM - server.maxRAM end
            goto continue
        end

        io.stderr:write("STATUS: Choosing to run " .. server.name .. ".\n")
        serversToRun[server.name] = server

        ::continue::
    end

    screens = screenhelper.getScreens()
    serversToKill = {}
    for _, screen in pairs(screens) do
        if not serversToRun[screen] then
            server = serverData[screen]
            server.name = screen
            table.insert(serversToKill, server)
            io.stderr:write("STATUS: Scheduling " .. screen .. " to be killed.\n")
        else 
            serversToRun[screen] = nil
        end
    end

    serverinterface.stopServers(serversToKill)

    for name in pairs(serversToRun) do
        io.stderr:write("STATUS: Scheduling " .. name .. " to be started.\n")
    end
    serverinterface.startServers(serversToRun)

end

return update
