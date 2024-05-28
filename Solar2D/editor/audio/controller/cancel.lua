local name = ...
local editor = require("editor.audio.index")
local instance = require("commands.kwik.baseCommand").new(
  function (params)
    local UI    = params.UI
    print(name)
    editor:hide(true)
  end
)
--
return instance