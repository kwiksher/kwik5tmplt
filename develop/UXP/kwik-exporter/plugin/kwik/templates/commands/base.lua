local AC = require("commands.kwik.actionCommand")
AC.name = ...
--
local command = function (params)
	local e     = params.event
	local UI    = params.UI
	print("command", AC.name)
end
--
local instance = AC.new(command)
return instance
