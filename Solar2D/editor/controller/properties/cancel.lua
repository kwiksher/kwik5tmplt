local AC = require("commands.kwik.actionCommand")
local json = require("json")
local util = require("lib.util")
local App = require("controller.Application")

local propsButtons = require("editor.parts.propsButtons")
local propsTable = require("editor.parts.propsTable")
--
--
local command = function (params)
	local UI    = params.UI
  print("props.cancel")

  propsButtons:hide()
  propsTable:hide()
  UI.editor.currentTool = nil
--
end
--
local instance = AC.new(command)
return instance
