
-- From Norman Ramsey on StackOverflow
-- raw=false removes ALL newlines, alongside whitespace from start and end
function os.capture(cmd, raw)
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', ' ')
    return s
end

-- Adds a system user if one does not exist and does nothing otherwise
function os.makeUser(username)
    if not os.execute("id " .. username .. " > /dev/null 2>&1") then
        os.execute("sudo useradd --system --comment \"mserver system user\" --shell /usr/bin/nologin "  .. username)
    end
end

return os
