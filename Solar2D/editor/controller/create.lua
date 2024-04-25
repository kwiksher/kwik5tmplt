local name = ...
local parent, root = newModule(name)
local toolbar = require("editor.parts.toolbar")

local instance =
  require("commands.kwik.baseCommand").new(
  function(params)
    local UI = params.UI
    print(name)
    if UI.useClassEditorProps then
      local props = UI.useClassEditorProps()
      for k, v in pairs(props) do
        print("", k, v)
      end
    end
    toolbar:toogleToolMap()
    --
  end
)
--
return instance
