local AC = require("commands.kwik.actionCommand")
--
local command = function (params)
	local UI    = params.UI
  print("actionCommand.cancel")
  UI.editor.actionEditor:hideCommandPropsTable(true)
--
end
--
local instance = AC.new(command)
return instance
