local AC = require("commands.kwik.actionCommand")
--
local command = function (params)
	local UI    = params.UI
  print("action.delete", params.action)
  if UI.editor.selections then
    for i, obj in next, UI.editor.selections do
      if obj.command then
        print("", obj.index, obj.action)
      else
        if type(obj.action) == "table" then
          print("", obj.index, obj.action.command)
        else
          print("", obj.action)
        end
      end
    end
  end

--
end
--
local instance = AC.new(command)
return instance
