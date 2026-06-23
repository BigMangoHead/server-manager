local screenhelper = require("screen")
local serverinterface = require("serverinterface")
local jsonhandler = require("jsonhandler")
local moreos = require("moreos")

local update = {}

function update.run()

    -- Don't process update at all if frozen
    local freezeFile = io.open(FREEZE_FILE_PATH)
    if (freezeFile:read("*all") == "1") then 
        logger.status("Server is frozen, update not processed.")
        return
    end
    freezeFile:close()

    local serverData, onlineServerData = jsonhandler.getServers()

    for name, server in pairs(onlineServerData) do
        if not server.priority then
            logger.warning("WARNING: Server \"" .. name .. "\" had no set priority; assuming priority to be 0.")
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
        if not server.directory then
            logger.error("Server \"" .. server.name .. "\" had no directory, skipping.")
            goto continue
        end

        if server.maxRAM then
            totalRAM = totalRAM + server.maxRAM
        end
        if server.processorWeight then
            processorWeight = processorWeight + server.processorWeight
        end

        if processorWeight > 100 or totalRAM > MAX_RAM then
            if processorWeight > 100 and totalRAM > MAX_RAM then
                logger.status("Processor weight maximum and RAM maximum would be reached by running \"" .. server.name .. "\", skipping.")
            elseif processorWeight > 100 then
                logger.status("Processor weight maximum would be reached by running \"" .. server.name .. "\", skipping.")
            else 
                logger.status("RAM maximum would be reached by running \"" .. server.name .. "\", skipping.")
            end

            if server.processorWeight then processorWeight = processorWeight - server.processorWeight end
            if server.maxRAM then totalRAM = totalRAM - server.maxRAM end
            goto continue
        end

        logger.status("Choosing to run " .. server.name .. ".")
        serversToRun[server.name] = server

        ::continue::
    end

    -- Update permissions for all running servers
    for _, server in pairs(serversToRun) do
        local checkFile = io.open(server.directory .. "/.server-check")
        if checkFile then
            local user = "ms-" .. server.name
            moreos.makeUser(user)
            checkFile:close()
            os.execute("sudo chown -R " .. user .. ":" .. user .. " \'" .. server.directory .. "/instance\'" )
        else 
            logger.warning(".server-check file not found for \"" .. server.name .. 
                            "\". File permissions not updated.")
        end
    end

    -- Check which screens are running to find servers that need to 
    -- be turned off and servers that don't need to be turned on
    screens = screenhelper.getScreens()
    serversToKill = {}
    for _, screen in pairs(screens) do
        if not serversToRun[screen] then
            server = serverData[screen]
            server.name = screen
            table.insert(serversToKill, server)
        else 
            serversToRun[screen] = nil
        end
    end

    if #serversToKill > 0 then serverinterface.stopServers(serversToKill) end

    serverinterface.startServers(serversToRun)

end

return update
