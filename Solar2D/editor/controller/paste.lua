local name = ...
local parent, root = newModule(name)

local instance =
  require("commands.kwik.baseCommand").new(
  function(params)
    local UI = params.UI
    print(name)
  end
)
--
return instance
