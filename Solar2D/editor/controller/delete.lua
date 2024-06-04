local name = ...
local parent, root = newModule(name)

local types = {"page", "timer", "group", "variables", "layer"}

local instance =
  require("commands.kwik.baseCommand").new(
  function(params)
    local UI = params.UI
    print(name)
    if UI.editor.selections then
      for i, obj in next, UI.editor.selections do
        if obj.page then
          print("", obj.page)
        elseif obj.layer then
          print("", obj.layer, obj.class)
        end
      end
    end
  end
)
--
return instance
