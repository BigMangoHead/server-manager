jsonhandler = require("jsonhandler")

local generator = {}

function prompt(text, checkFunc)
    local valid = false
    while not valid do
        io.write(text .. " ")
        local response = io.read()
        valid = checkFunc(response)
    end
    return response
end

function generator.run() 
    local server = {}
    serverData = jsonhandler.getServers()

    local name = prompt("Server name?", function (t)
        if (#t < 2) then print("Name too short.") return false
        elseif t:match("[^%w%-%_]") then print("Invalid characters.") return false
        elseif not serverData[name] then print("Name already taken.") return false
        else return true end
    end)

    server.directory = prompt("Directory?", function (t)
        if (#t < 3) then print("String too short, likely invalid.") return false end
        return true
    end)

    server.minRAM = prompt("Minimum RAM in MB? [Default: 4096]", function (t)
        if (t == "") then return true end
        x = tonumber(t)
        if not x then print("Numeric answer required.") return false end
        if (x < 100 or x > MAX_RAM) then print("RAM amount must be at least 100 and at most MAX_RAM (" .. MAX_RAM .. ")") return false end
        return true
    end)
    if not server.minRAM then server.minRAM = 4096 end

    server.maxRAM = prompt("Maximum RAM in MB? [Default: 8192]", function (t)
        if (t == "") then return true end
        x = tonumber(t)
        if not x then print("Numeric answer required.") return false end
        if (x < 100 or x > MAX_RAM) then print("RAM amount must be at least 100 and at most MAX_RAM (" .. MAX_RAM .. ")") return false end
        return true
    end)
    if not server.maxRAM then server.maxRAM = 8192 end

    server.processorWeight = prompt("Processor weight? Must be in range 0-100. [Default: 20]", function (t)
        if (t == "") then return true end
        x = tonumber(t)
        if not x then print("Numeric answer required.") return false end
        if (x < 0 or x > 100) then print("Processor weight outside of valid range.") return false end
        return true
    end)
    if not server.processorWeight then server.processorWeight = 8192 end

    server.type = prompt("Server type? [Default: minecraft]")

    server.priority = prompt("Priority? [Default: 0]", function (t)
        if (t == "") then return true end
        x = tonumber(t)
        if not x then print("Numeric answer required.") return false end
        if (x < 0) then print("Must be nonnegative.") return false end
        return true
    end)
    if not server.priority then server.priority = 0 end

    server.autorestart = prompt("Autorestart enabled? [Default: true]", function (t)
        if (t == "true" or t == "false") then return true
        else return false end
    end)
    if server.autorestart == "false" then server.autorestart = false
    else server.autorestart = true end

    if os.execute("mkdir -p " .. server.directory) then
        logger.status("Directory created successfully.")
        if SYMLINK_DIR and not os.execute("cd " .. SYMLINK_DIR .. "; ln -s " .. server.directory .. " " .. name) then
            logger.error("Failed to make symlink.")
        else
            logger.status("Symlink made successfully.")
        end
        if not os.execute("cp -r " .. MY_PATH .. "template/all/* " .. server.directory) then
            logger.error("Failed to copy files from template/all.")
        else
            logger.status("Successfully copied files from template/all.")
        end

        -- Check file exists to pull type specific template files from
        local templatePath = MY_PATH .. "template/" .. server.type
        if os.rename(templatePath, templatePath) then
            if not os.execute("cp -r " .. templatePath .. "/* " .. server.directory) then
                logger.error("Failed to copy files from template/" .. server.type .. ".")
            else
                logger.status("Successfully copied files from template/" .. server.type .. ".")
            end
        else
            logger.warning("No template found for type \"" .. server.type .. "\".")
        end

        serverData[name] = server
        jsonhandler.updateServerData(serverData)
    else
        error("Failed to make server directory.")
    end

end

return generator
