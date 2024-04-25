local AC = require("commands.kwik.actionCommand")
--
local command = function (params)
	local UI    = params.UI
  print("action.cancel")
  UI.editor.actionEditor:hide(true)
--
end
--
local instance = AC.new(command)
return instance
