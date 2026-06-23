local logger = {}

function logger.status(text)
    io.stderr:write("STATUS: " .. text .. "\n")
end

function logger.warning(text)
    io.stderr:write("WARNING: " .. text .. "\n")
end

function logger.error(text)
    io.stderr:write("ERROR: " .. text .. "\n")
end


return logger
