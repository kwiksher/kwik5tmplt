local M = {
  name = {{name}},
  class = "sync",
  line     = {},
  properties = {
    autoPlay     = {{audotPlay}},
    delay        = {{delay}},
    fadeDuration = {{fadeDuration}},
    speakerIcon = {{speakerIcon}},
    wordTouch   = {{wordlTouch}},
  },
  audioProps = {
    channel      = {{channel}},
    volume      = {{voume}},
  },
  textProps = {
    folder       = nil,
    font         = {{font}},
    fontColor   = { {{fontColor}} },
    fontColorHi = { {fontColorHi}} },
    fontSize    = {{fontSize}}/4,
    language    = nil,
    padding     = {{padding}}/4,
    readDir     = "{{readDir}}",
    sentenceDir = {{sentenceDir}}, -- wordTouch
  }
}
--
local layerProps = require(parent.."{{layer}}")
--
M.x = layerProps.x
M.y = layerProps.y
--
return require("components.kwik.layer_sync").new(M)

--[[
local M = {
  name = "alphabet",
  filename = "alphabet.mp3",
  type = "sync",
  autoPlay = true,
  channel = 2
}

M.line = {
  { start =  0, out = 1000, dur = 0, name = "A", file = "a.mp3", action = "onComplete"},
  { start =  1000, out = 2000, dur = 0, name = "B", file = "b.mp3", action = "onComplete"},
  { start =  2000, out = 3000, dur = 0, name = "C", file = "c.mp3", action = "onComplete"},
}

M.x            = 39
M.y            = 300
M.padding      = 10
-- M.font         = nil
M.fontSize     = 36
M.fontColor    = {1,1,1}
M.fontColorHi  = {1,1,0}
M.fadeDuration = 0
M.wordTouch    = true
M.sentenceDir  = "alphabet" -- wordTouch
M.readDir      = "leftToRight"
M.channel      = 1
M.layer        = "alphabet"
--
-- M.volume = 10
-- M.delay  = nil
--]]
