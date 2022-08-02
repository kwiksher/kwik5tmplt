local instance = require("commands.kwik.baseCommand").new(
  function (params)
    local e     = params.event
    local UI    = e.UI
    print("commands.myEvents.testhander")

    UI.scene:dispatchEvent({
      name = "myAction",
      UI = UI
    })

  end
)
--
return instance