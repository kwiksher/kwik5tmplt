local props = {
  name     = "Tranquility",
  properties = {
    type     = "long",
    autoPlay = false,
    channel  = NIL,
    delay    = 0,
    filename = "Tranquility.mp3",
    folder   = "long",
    loops    = 0, -- 1 + 3 = 4 times
  },
  actions = {onComplete=NIL}
}

local M = {
  -- name        = {{aname}},
  -- type        = {{atype}},
  -- language    = nil  -- or {"en", "jp"},
  -- filename    = "{{fileName}}",
  -- folder      = nil
  -- allowRepeat = false,
  -- autoPlay    = {{aplay}},
  -- deplay      = {{adelay}},
  -- volume      = {{avol}},
  -- channel     = {{achannel}}
  -- loops       = {{aloop}},
  -- fadein      = {{tofade}},
  -- retain      = {{akeep}}
}

-- you can play it with UI.audios[self.name]:play()

return require("components.kwik.page_audio").set(props)