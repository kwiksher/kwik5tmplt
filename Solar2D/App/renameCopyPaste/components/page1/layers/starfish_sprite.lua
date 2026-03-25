local name = ...
local parent,root = newModule(name)
local json = require("json")

local M = {
  name ="",
  class = "sprite", -- spritesheet
  -- sheet = _sheet,
  properties = {
    filename = "sprites/slots.png",
    sheetInfo = "sprites/slots.lua",
    sheetContentWidth  = 376/4,
    sheetContentHeight = 188/4,
    numFrames          = 2,
    width              = 188/4,
    height             = 188/4,
    sheetType  = "TexturePacker", -- uniform-sized TexturePacker, Animate
  },
  book = "book"
}

M.layerProps = require(parent.."starfish")

M.sequenceData = {
  { name = "default",
    start = 1,
    count = 16,
    time = 1000,
    loopCount = 0,
    loopDirection = "forward",
  },
  { name = "test",
    frames = { 1,2 },
    time = 1000,
    loopCount = 0,
    loopDirection = "forward",
  },
}
--
local options = nil
if M.properties.sheetType == "TexturePacker" then
  --
  local path = "App."..M.book..".assets."..M.properties.sheetInfo
  path = path:gsub("/", ".")
  path = path:gsub(".lua", "")
  M.newSheetInfo = require(path)
  options = M.newSheetInfo.sheet
  --
elseif M.properties.sheetType == "Animate" then
  --
  local function newSheetInfo()
    local sheetInfo = {}
    sheetInfo.frames = {}
    local jsonFile = function(filename )
      local path = system.pathForFile( "App/"..M.book.."/assets/"..filename, system.ResourceDirectory )
      local contents
      local file = io.open( path, "r" )
      if file then
        contents = file:read("*a")
        io.close(file)
        file = nil
      end
      return contents
    end
    --
    local animateJson = json.decode( jsonFile(M.properties.sheetInfo) )
    --print (sheetInfo, #animateJson.frames)
    for i=1, #animateJson.frames do
      local frame = animateJson.frames[i].frame
      local spriteSourceSize = animateJson.frames[i].spriteSourceSize
      sheetInfo.frames[i] = {x=frame.x, y=frame.y, width=frame.w, height= frame.h, sourceX = spriteSourceSize.x, sourceY = spriteSourceSize.y, sourceWidth = spriteSourceSize.w, sourceHeight = spriteSourceSize.h}
    end
    sheetInfo.sheetContentWidth = animateJson.meta.size.w
    sheetInfo.sheetContentHeight = animateJson.meta.size.h
    return sheetInfo
  end
  --
  options = newSheetInfo()
else
  options = {
    width              = M.properties.width,
    height             = M.properties.height,
    numFrames          = M.properties.numFrames,
    sheetContentWidth  = M.properties.sheetContentWidth,
    sheetContentHeight = M.properties.sheetContentHeight
  }
  M.imageWidth = options.width
  M.imageHeight = options.height
end
---
M.sheet = graphics.newImageSheet( "App/"..M.book.."/assets/"..M.properties.filename, system.ResourceDirectory, options )
--
return require("components.kwik.layer_spritesheet").new(M)
