local parent,root, M = newModule(...)
local M = {
  name = "mytext", -- mytext
  layer = "mytext",
  class = "sync",
  folder = "sync",
  properties = {
    target       = "mytext",
    autoPlay     = true,
    backgroundRectAlpha = 0.4,
    backgroundRectColor = {1, 1, 1},
    delay        = 0,
    fadeDuration = 1000,
    langClassDelegate = false,
    speakerIcon = true,
    speakerIconColor = {0,1,0},
    wordTouch   = false,
  },
  audioProps = {
    filename    = "sync/ohno.mp3",
    channel      = 2,
    volume      = 10,
  },
  textProps = {
    filename    = "sync/ohno.txt",
    folder       = nil,
    font         = "",
    fontColor   = { 0,0,1 },
    fontColorHi = { 1,1,0 },
    fontSize    = 24,
    language    = "",
    padding     = 10,
    readDir     = "leftToRight",
    sentenceDir = "sync/ohno", -- wordTouch
  },
  actions = {onComplete = ""},
}
M.line = {
  {
    name = "Oh",
    out = 0.418,
    start = 0.186,
    file = "",
    action = "",
    dur = 0,
    newline = false
  },
  {
    name = "no",
    out = 0.894,
    start = 0.418,
    file = "",
    action = "",
    dur = 0,
    newline = false
  },
  {
    name = "said",
    out = 1.382,
    start = 1.115,
    file = "",
    action = "",
    dur = 0,
    newline = false
  },
  {
    name = "the",
    out = 1.521,
    start = 1.382,
    file = "",
    action = "",
    dur = 0,
    newline = false
  },
  {
    name = "frozen",
    out = 1.823,
    start = 1.521,
    file = "",
    action = "",
    dur = 0,
    newline = true
  },
  {
    name = "snowman",
    out = 2.531,
    start = 1.823,
    file = "",
    action = "action_sman",
    dur = 0,
    newline = false
  },
  {
    name = "when",
    out = 2.65,
    start = 2.531,
    file = "",
    action = "",
    dur = 0,
    newline = false
  },
  {
    name = "the",
    out = 2.763,
    start = 2.65,
    file = "",
    action = "",
    dur = 0,
    newline = false
  },
  {
    name = "snow",
    out = 3.042,
    start = 2.763,
    file = "",
    action = "",
    dur = 0,
    newline = false
  },
  {
    name = "started",
    out = 3.611,
    start = 3.042,
    file = "",
    action = "",
    dur = 0,
    newline = false
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
