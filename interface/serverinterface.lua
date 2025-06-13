
local screenhelper = require("screen")

local serverinterface = {}

local function stopGenericServer(server)
    os.execute("screen -XS %" .. server.name .. " quit")
end

local function startGenericServer(server)
    os.execute(string.format([[screen -Sdm "%%%s" bash -c "cd '%s'; bash run.sh"]], server.name, server.directory))
end

function serverinterface.startServer(server)
    if not server.directory then io.stderr:write("ERROR: Missing server directory for \"" .. server.name .. "\". Skipping starting it.\n"); return end

    if server.type == "minecraft" then
        if not server.minRAM then io.stderr:write("WARNING: Missing server minRAM for minecraft server \"" .. server.name .. "\". Assuming to be 4096\n"); server.minRAM = 4096 end
        if not server.maxRAM then io.stderr:write("WARNING: Missing server maxRAM for minecraft server \"" .. server.name .. "\". Assuming to be 8192\n"); server.maxRAM = 8192 end

        os.execute(string.format([[screen -Sdm "%%%s" bash -c "cd '%s'; bash %sinterface/auto-restart.sh '%s/run.sh' %d %d"]], 
                                   server.name, server.directory, MY_PATH, server.directory, server.minRAM, server.maxRAM))
    else
        startGenericServer(server)
    end
end

function serverinterface.stopServer(server)
    if server.type == "minecraft" then
        os.execute("bash \"" .. MY_PATH .. "interface/stop-minecraft.sh\" \"%" .. server.name .. "\" &")
    else
        stopGenericServer(server)
    end
end

function serverinterface.startServers(servers)
    for k, s in pairs(servers) do
        if not s.name then 
            io.stderr:write("ERROR: A server was passed to serverinterface.startServers with no attached name. Skipping server.\n")
            servers[k] = nil
        else 
            io.stderr:write("STATUS: Starting server \"" .. s.name .. "\".\n")
            serverinterface.startServer(s)
        end
    end
end

function serverinterface.stopServers(servers)
    for k, s in pairs(servers) do
        if not s.name then 
            io.stderr:write("ERROR: A server was passed to serverinterface.stopServers with no attached name. Skipping server.\n")
            servers[k] = nil
        else 
            io.stderr:write("STATUS: Stopping server \"" .. s.name .. "\".\n")
            serverinterface.stopServer(s)
        end
    end

    io.stderr:write("STATUS: Waiting for closing servers to stop...\n")
    local allStopped = false
    local counter = 0
    while not allStopped do
        counter = counter + 1
        allStopped = true
        local stillRunning = {}
        local screens = screenhelper.getScreens()
        for _, s in pairs(servers) do
            local stopped = true
            for _, c in pairs(screens) do
                if s.name == c then
                    stopped = false
                    break
                end
            end
            if not stopped then 
                allStopped = false 
                table.insert(stillRunning, s.name)
            end
        end
        if counter > 60 then
            io.stderr:write("ERROR: After waiting 60 seconds, the following servers have still not stopped: \nERROR: ")
            for _, name in pairs(stillRunning) do
                io.stderr:write(name .. "   ")
            end
            io.stderr:write("\nERROR: Continuing forward with execution regardless.\n")
            break
        end
        if not allStopped then os.execute("sleep 1") end
    end
    if allStopped then io.stderr:write("STATUS: Closed servers successfully\n") end
end

return serverinterface
