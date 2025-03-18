local M = {
  name     = "Crickets",
  type     = "",
  properties = {
    autoPlay = false,
    channel  = 0,
    delay    = 0,
    fadein   = 0,
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
-- allowRepeat = false,
-- autoPlay    = ,
-- deplay      = ,
-- volume      = ,
-- channel     =
-- loops       = ,
-- fadein      = ,
-- retain      =
M.actions = { onComplete = "ThunderEnded" }
-- you can play it with UI.audios[self.name]:play()
return require("components.kwik.page_audio").set(M)
