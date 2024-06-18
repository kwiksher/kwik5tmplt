local current = ...
local parent,  root, M = newModule(current)

local spritesheet = require("components.kwik.layer_spritesheet")

M.x = display.contentCenterX + 340
M.y = display.contentCenterY + 20

function M:hide()

  if self.instance then
    self.instance:destory{sceneGroup = self.group}
    self.instance = nil
    self.group:removeSelf()
  end
end

function M:show(UI, props)
  props.layerProps = {x= self.x, y = self.y}

  if self.instance then
    self.instance:destroy()
  end

  -- props = {
  --   name ="{{name}}",
  --   class = "{{class}}", -- spritesheet
  --   type  = "{{type}}", -- uniform-sized, texturePacker, Aniamte
  --   -- sheet = {{name}}_sheet,
  --   properties = {
  --     filename = "{{filename}}",
  --     sheetInfo = "{{sheetInfo}}",
  --     sheetContentWidth  = {{sheetWidth}}/4,
  --     sheetContentHeight = {{sheetHeight}}/4,
  --     numFrames          = {{autoFrames}},
  --     width              = {{frameWidth}}/4,
  --     height             = {{frameHeight}}/4,
  --   }
  -- }
  --
  -- props.sequenceData = {
  --   {{#sequences}}
  --       {{^count}}
  --           { name = "{{name}}",
  --             frames = {{{frames}}},
  --       {{/count}}
  --       {{#count}}
  --           { name = "{{name}}",
  --             start = {{start}},
  --             count = {{count}},
  --       {{/count}}
  --             time = {{length}},
  --             loopCount = {{loopCount}},
  --             loopDirection = "{{loopDirection}}",
  --           },
  --   {{/sequences}}
  -- }

  local options = nil
  if props.type == "TexturePacker" then
    --
    props.newSheetInfo = require(props.sheetInfo)
    options = props.newSheetInfo().sheet
    --
  elseif props.type == "Animate" then
    --
    props.newSheetInfo = function()
      local sheetInfo = {}
      sheetInfo.frames = {}
      local jsonFile = function(filename )
          local path = systeprops.pathForFile(_K.spriteDir..filename, _K.systemDir )
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
      local animateJson = json.decode( jsonFile(props.sheetInfo) )
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
    options = props.newSheetInfo()
  else
    options = {
        width              = props.properties._width,
        height             = props.properties._height,
        numFrames          = props.properties.numFrames,
        sheetContentWidth  = props.properties.sheetContentWidth,
        sheetContentHeight = props.properties.sheetContentHeight
    }
    props.imageWidth = options.width
    props.imageHeight = options.height
  end
  ---
  props.sheet = graphics.newImageSheet( "App/"..UI.book.."/assets/"..props.properties._filename, system.ResourceDirectory, options )
  --
  self.instance = spritesheet.new(props)
  self.group = display.newGroup()
  self.instance:create{sceneGroup = self.group}

end

return M