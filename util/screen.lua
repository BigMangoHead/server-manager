os = require("moreos")

local function lineIterator( str )
    local pos = 1;
    return function()
        if not pos then return nil end
        local  p1, p2 = string.find( str, "\r?\n", pos )
        local line
        if p1 then
            line = str:sub( pos, p1 - 1 )
            pos = p2 + 1
        else
            line = str:sub( pos )
            pos = nil
        end
        return line
    end
end

screen = {}

-- Returns screens a list of screens that begin with "%".
-- Note that the "%" character is cropped from the beginning of the name
function screen.getScreens()
    out = os.capture("screen -ls", true)

    screens = {}
    for line in lineIterator(out) do
        if string.find(line, "%.%%") then -- Matches ".%", which must exist in the given line
            posA = string.find(line, "%%")
            posB = string.find(line, "%(", posA)
            screen = string.sub(line, posA+1, posB-1) .. '~'
            screen = string.gsub(screen, "%s+~", "")
            table.insert(screens, screen)
        end
    end

    return screens
end

return screen
