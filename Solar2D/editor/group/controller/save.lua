local name = ...
local instance = require("commands.kwik.baseCommand").new(
  function (params)
    local UI    = params.UI
    print(name)
    UI.editor.currentTool = nil

  end
)
--
return instance