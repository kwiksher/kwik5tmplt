local M = {
  name     = "Crickets",
  type     = "", -- "global", "recorded"
  properties = {
    autoPlay = false,
    channel  = 1,
    delay    = 0,
    fadein   = false,
    filename = "Crickets.wav",
    folder   = "short",
    loops    = 0, -- 1 + 3 = 4 times
    volume   = 8
  }
}
  -- name        = ,
  -- type        = ,
  -- language    = nil  -- or {"en", "jp"},
  -- filename    = "",
  -- folder      = nil
  -- autoPlay    = ,
  -- deplay      = ,
  -- volume      = ,
  -- channel     =
  -- loops       = ,
  -- fadein      = ,
  -- retain      =
M.actions = { onComplete = "" }
-- you can play it with UI.audios[self.name]:play()
return require("components.kwik.page_audio").set(M)