local jsonhandler = require("jsonhandler")

local settings = {}

local VALID_OPTIONS = {"limit"}

function settings.set(args)
    local key = args.key
    local val = args.value

    local found = false
    for _, value in ipairs(VALID_OPTIONS) do
        if key == value then found = true end
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

    if not args.no_update then
        require("update").run()
    end
end

return settings
