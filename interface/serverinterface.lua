
local screenhelper = require("screen")

local serverinterface = {}

local function stopGenericServer(server)
    os.execute("screen -XS %" .. server.name .. " quit")
end

function serverinterface.stopServer(server)
    if server.type == "minecraft" then
        os.execute("bash \"" .. MY_PATH .. "interface/minecraft.sh\" \"%" .. server.name .. "\" &")
    else
        stopGenericServer(server)
    end
end

function serverinterface.startServers(servers)

end

function serverinterface.stopServers(servers)
    for k, s in pairs(servers) do
        if not s.name then 
            io.stderr:write("ERROR: A server was passed to serverinterface.stopServers with no attached name. Skipping server.\n")
            servers[k] = nil
        else 
            serverinterface.stopServer(s)
        end
    end

    io.stderr:write("STATUS: Waiting for closing servers to stop...")
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
end

return serverinterface
