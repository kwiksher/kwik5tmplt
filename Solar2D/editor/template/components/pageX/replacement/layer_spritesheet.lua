local name = ...
local parent,root = newModule(name)

local layerProps = require(parent.."{{layer}}")

local M = {
  name ="{{name}}",
  class = "{{class}}", -- spritesheet
  type  = "{{type}}", -- uniform-sized, texturePacker, Aniamte
  -- sheet = {{name}}_sheet,
  properties = {
    filename = "{{filename}}",
    sheetInfo = "{{sheetInfo}}",
    sheetContentWidth  = {{sheetWidth}}/4,
    sheetContentHeight = {{sheetHeight}}/4,
    numFrames          = {{autoFrames}},
    width              = {{frameWidth}}/4,
    height             = {{frameHeight}}/4,
  }
}

M.sequenceData  = {
  {{#sequences}}
      {{^count}}
          { name = "{{name}}",
            frames = {{{frames}}},
      {{/count}}
      {{#count}}
          { name = "{{name}}",
            start = {{start}},
            count = {{count}},
      {{/count}}
            time = {{length}},
            loopCount = {{loopCount}},
            loopDirection = "{{loopDirection}}",
          },
  {{/sequences}}
}
--
local options = nil
if M.type == "TexturePacker" then
  --
  M.newSheetInfo = require(M.sheetInfo)
  options = M.newSheetInfo().sheet
  --
elseif M.type == "Animate" then
  --
  M.newSheetInfo = function()
    local sheetInfo = {}
    sheetInfo.frames = {}
    local jsonFile = function(filename )
        local path = system.pathForFile(_K.spriteDir..filename, _K.systemDir )
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
    local animateJson = json.decode( jsonFile(M.sheetInfo) )
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
  options = M.newSheetInfo()
else
  options = {
      width              = M.width,
      height             = M.height,
      numFrames          = M.numFrames,
      sheetContentWidth  = M.sheetContentWidth,
      sheetContentHeight = M.sheetContentHeight
  }
  M.imageWidth = options.width
  M.imageHeight = options.height
end
---
M.sheet = graphics.newImageSheet( _K.spriteDir.. M.filename, _K.systemDir, options )
--
return require("components.kwik.layer_spritsheet").new(M)