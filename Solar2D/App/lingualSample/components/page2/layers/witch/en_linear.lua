local parent,root = newModule(...)

local M = {
  name = "witch/en",
  --
  class = "linear",
-- "Dissolve"
-- "Path"
-- "Linear"
-- "Pulse"
-- "Rotation"
-- "Tremble"
-- "Bounce"
-- "Blink"
--
}

M.obj = require(parent.."en").obj

M.layerOptions = {
  --
  referencePoint = "Center",
  -- "Center"
  -- "TopLeft"
  -- "TopCenter"
  -- "TopRight"
  -- "CenterLeft"
  -- "CenterRight"
  -- "BottomLeft"
  -- "BottomLeft"
  -- "BottomRight"
  -- for text
  deltaX         = 0,
  deltaY         = 0,
}
-- animationProps
M.properties = {
  type    = "", -- group, page, sprite
  target = "witch/en",
  autoPlay = true,
  delay    = 0,
  duration = 2000,
  loop     = 1,
  reverse  = false,
  resetAtEnd  = false,
  --
  easing   = "inCircular",
  -- 'Linear'
  -- 'inOutExpo'
  -- 'inOutQuad'
  -- 'outExpo'
  -- 'outQuad'
  -- 'inExpo'
  -- 'inQuad'
  -- 'inBounce'
  -- 'outBounce'
  -- 'inOutBounce'
  -- 'inElastic'
  -- 'outElastic'
  -- 'inOutElastic'
  -- 'inBack'
  -- 'outBack'
  -- 'inOutBack'
  ------------
  -- flip
  xSwipe   = nil,
  ySwipe   = nil,
}
--

M.to = {
  x     = -180,
  y     = -100,
  --
  alpha = 1,

  yScale   = 1.5,
  xScale   = 1.5,
  rotation = 30,
}
-- more option

-- action at the end of animation
M.actions = { onComplete = "" }



---------------------------------------
--
local function onEndHandler (UI)
  if M.actionName and M.actionName:len() > 0  then
    Runtime:dispatchEvent({name=UI.page..M.actionName, event={}, UI=UI})
  end
end
--
function M:create(UI)
  if UI.langClassDelegate then
    local t = self.name:split("/")
    self.name = t[1].."/".. UI.lang
  end
  --
  if self.properties.type == "group" then
    self.obj = require(parent..self.properties.target).group
  else
    self.obj = UI.sceneGroup[self.name]
  end
  self:initAnimation(UI, self.obj, onEndHandler)
  self.animation = self:buildAnim(UI)
end
--
function M:didShow(UI)
  local sceneGroup = UI.sceneGroup
  if self.properties.autoPlay then
    if self.animation.from then
      --self.animation.from:toBeginning()
      -- transition.to(obj, {x = obj.x + 100})
      -- local obj = sceneGroup["cat_face1"]
      self.animation.from:play()
      -- self.animation.from:pause()

    else
      --self.animation.to:toBeginning()
      self.animation.to:play()
    end
  end
end
--
function M:didHide(UI)
  if self.animation.from then
    self.animation.from:pause()
    -- self.animation.from:toBeginning()
   end
  if self.animation.to then
    self.animation.to:pause()
    -- self.animation.to:toBeginning()
  end
end
--
return require("components.kwik.layer_animation").set(M)
