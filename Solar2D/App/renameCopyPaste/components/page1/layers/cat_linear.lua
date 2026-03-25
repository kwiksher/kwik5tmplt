local parent,root = newModule(...)

local M = {
  name = "cat",
  --
  class = "linear",
  -- "Dissolve"
  -- "Path"
  -- "Linear"
  -- "Pulse"
  -- "Rotation"
  -- "Shake"
  -- "Bounce"
  -- "Blink"
  --
  obj = require(parent.."cat").obj
}

M.layerOptions = {
  -- layerProps
  isGroup = false,
  isSceneGroup = false,
  isSpritesheet = false,
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
  autoPlay = true,
  delay    = 0,
  duration = 10,
  loop     = 10,
  reverse  = true,
  resetAtEnd  = false,
  --
  easing   = "Linear",
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
  x     = nil,
  y     = nil,
  --
  alpha = 1,

  yScale   = 1.05,
  xScale   = 1.05,
  rotation = nil,
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
  -- for k, v in pairs(UI.sceneGroup) do print("", k, v) end
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
