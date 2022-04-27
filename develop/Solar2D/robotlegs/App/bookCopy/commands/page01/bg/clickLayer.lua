local path = ...
local AC = require("commands.kwik.actionCommand")
local json = require("json")
local util = require("lib.util")
--
local command = function (params)
	local e     = params.event
	local UI    = e.UI
	print("2:", path)
end
--
local instance = AC.new(command)
return instance
