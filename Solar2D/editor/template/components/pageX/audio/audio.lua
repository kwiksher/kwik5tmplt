local props = {
  autoPlay = {{autoPlay}},
  channel  = {{channel}},
  delay    = {{delay}},
  filename = "{{filename}}",
  folder   = "{{folder}}",
  loops    = {{loops}}, -- 1 + 3 = 4 times
  name     = "{{name}}",
  type     = "{{type}}",
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