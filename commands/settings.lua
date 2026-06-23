local jsonhandler = require("jsonhandler")

local settings = {}

local OPTIONS = {
    ["limit"] = "control whether RAM and processor limits are enforced"
}

function settings.set(args)
    local key = args.key
    local val = args.value

    local found = false
    for x, _ in ipairs(OPTIONS) do
        if key == x then found = true end
    end
    if not found then
        parser:error("Key is invalid")
    end

    if not (val == "true" or val == "false") then
        parser:error("Value must either be \"true\" or \"false\"")
    end

    _, _, miscServerData = jsonhandler.getServers()
    if (val == "false") then
        miscServerData[key] = false
    else
        miscServerData[key] = true
    end
    jsonhandler.updateMiscServerData(miscServerData)
    if (val == "false") then
        print("Enabled setting to " .. OPTIONS[key])
    else
        print("Disabled setting to " .. OPTIONS[key])
    end


    if not args.no_update then
        require("update").run()
    end
end

return settings
