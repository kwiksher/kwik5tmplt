local instance = require("commands.kwik.baseCommand").new(
  function (params)
    local e     = params.event
    local UI    = e.UI
    print("commands.myAction")
  end
)
--
return instance
