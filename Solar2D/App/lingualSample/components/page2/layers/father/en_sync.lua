local name = ...
local parent,root = newModule(name)

local M = {
  name = "father/en", -- en
  layer = "en",
  class = "sync",
  folder = "sync",
  properties = {
    target       = "father/en",
    autoPlay     = true,
    delay        = 0,
    fadeDuration = 1000,
    speakerIcon = true,
    wordTouch   = true,
  },
  audioProps = {
    filename    = "en/my_father_is_nice.mp3",
    channel      = 2,
    volume      = 10,
  },
  textProps = {
    folder       = nil,
    font         = "",
    fontColor   = { 1,0,1 },
    fontColorHi = { 1,1,0 },
    fontSize    = 36,
    language    = "",
    padding     = 0,
    readDir     = "leftToRight",
    sentenceDir = "en/my_father_is_nice", -- wordTouch
  },
  actions = {onComplete = ""},

}

M.line = {
  {
    name = "My",
    out = 0.543,
    start = 0.245,
    file = "",
    action = "",
    dur = 0
  },
  {
    name = "father",
    out = 0.983,
    start = 0.543,
    file = "",
    action = "",
    dur = 0
  },
  {
    name = "is",
    out = 1.174,
    start = 0.983,
    file = "",
    action = "",
    dur = 0
  },
  {
    name = "nice.",
    out = 1.727,
    start = 1.174,
    file = "",
    action = "",
    dur = 0
  },
}
--
return require("components.kwik.layer_sync").set(M)

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
