local AC = require("commands.kwik.actionCommand")
--
local command = function (params)
	local UI    = params.UI
  print("actionCommand.delete")

  if UI.editor.selections then
    for i, obj in next, UI.editor.selections do
      print("", obj.index, obj.command)
    end
  end

--
end
--
local instance = AC.new(command)
return instance
