local M = {
  name = "alphabet",
  class = "sync",
  settings = {
    autoPlay     = true,
    delay        = nil,
    fadeDuration = 1000,
    speakerIcon  = true,
    wordTouch    = true,
  },
  audioProps = {
    filename = "alphabet.mp3",
    channel = 2,
    volume      = 10,
    folder = nil,
  },
  textProps = {
    -- folder       = nil,
    font         = nil1,
    fontColor   = { 1,1,1 },
    fontColorHi = { 1, 1, 0 },
    fontSize    = 36,
    language    = nil,
    padding     = 10,
    readDir     = "leftToRight",
    sentenceDir = "alphabet", -- wordTouch
  }
}

M.line = {
  { start =  0, out = 1000, dur = 0, name = "A", file = "a.mp3", action = "onComplete"},
  { start =  1000, out = 2000, dur = 0, name = "B", file = "b.mp3", action = "onComplete"},
  { start =  2000, out = 3000, dur = 0, name = "C", file = "c.mp3", action = "onComplete"},
}

-- M.x            = 39
-- M.y            = 300
-- M.layer        = "alphabet"

return M