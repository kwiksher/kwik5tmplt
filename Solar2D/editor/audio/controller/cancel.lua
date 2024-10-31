local name = ...
local tool = require("editor.audio.index")
--
local instance = require("commands.kwik.baseCommand").new(
  function (params)
    local UI    = params.UI
    print(name)
    tool:hide(true)
  end
)
--
return instance