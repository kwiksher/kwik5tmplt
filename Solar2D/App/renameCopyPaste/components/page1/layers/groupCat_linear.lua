local parent,root = newModule(...)

local M = {
  name = "",
  --
  class = "",
  -- "Dissolve"
  -- "Path"
  -- "Linear"
  -- "Pulse"
  -- "Rotation"
  -- "Tremble"
  -- "Bounce"
  -- "Blink"
  --
  obj = require(parent.."").obj
}

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
  type    = group, -- group, page, sprite
  autoPlay = true,
  delay    = 0,
  duration = 2000,
  loop     = 1,
  reverse  = false,
  resetAtEnd  = false,
  --
  easing   = "outCirc",
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
  x     = 200,
  y     = 0,
  --
  alpha = 1,

  yScale   = 1.5,
  xScale   = 1.5,
  rotation = 90,
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
  self.obj = UI.sceneGroup[self.name]
  self:initAnimation(UI, self.obj, onEndHandler)
  self.animation = self:buildAnim(UI)
end
--
function M:didShow(UI)
  if self.autoPlay then
    --self.animation;toBeginning()
    self.animation:play()
  end
end
--
function M:didHide(UI)
  self.animation:pause()
end
--
return require("components.kwik.layer_animation").set(M)
