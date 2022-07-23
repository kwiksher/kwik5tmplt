local _M = {}
local baseCommand = {}
--
function baseCommand:run(params, modName, cmdName)
    local mod = require("commands.page0." .. modName)
    mod[cmdName](params)
end

function baseCommand.new(_execute)
    local instance = {}
    instance.execute = _execute
	--
    function instance:new()
        local command = {}
        command.execute = function(self, params)
            instance.execute(params)
        end
        return command
    end
    return instance
end

--
return setmetatable(_M, {__index = baseCommand})
