local parent,root, M = newModule(...)
local M = {
  name = "hat",
  --
  class = "path",
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
  -- "BottomCenter"
  -- "BottomRight"
  -- for text
  deltaX         = -5,
  deltaY         = 10,
}
-- animationProps
M.properties = {
  type    = "", -- group, page, sprite
  target = "hat",
  autoPlay = true,
  delay    = 1000,
  duration = 2000,
  loop     = 1,
  reverse  = false,
  resetAtEnd  = false,
  --
  easing   = "inQuad",
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
  -- 'inCircular'
  -- 'outCircular'
  -- 'inElastic'
  -- 'outElastic'
  -- 'inOutElastic'
  -- 'inBack'
  -- 'outBack'
  -- 'inOutBack'
  ------------
  -- flip
  xSwipe   = false,
  ySwipe   = false,
  useLang  = false
}
--
M.from = {
  x     = nil,
  y     = nil,
  --
  alpha = 1,
  yScale   = 1,
  xScale   = 1,
  rotation = 0,
}
--
M.to = {
  x     = nil,
  y     = nil,
  --
  alpha = 1,
  yScale   = 1,
  xScale   = 1,
  rotation = 0,
}
-- more option
-- action at the end of animation
M.actions = { onComplete = "" }

M.breadcrumbs = {
    enable  = true,
    dispose = false,
    shape = "circle",
    color = {0, 0, 0, 0.2},
    interval = 30,
    time = 1000,
    width = 10,
    height = 10
  }


M.path = {
  filename = "Path1_open.json",
  newAngle = nil,
  closed = false,
  pause = true,
  autoTurn = true
}
---------------------------------------
--
local function onEndHandler (UI)
  if M.actionName and M.actionName:len() > 0  then
    Runtime:dispatchEvent({name=UI.page..M.actionName, event={}, UI=UI})
  end
end
--
function M:create(UI)
  if UI.langClassDelegate and useLang then
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
  UI.animations[self.name.."_"..self.class] = self.animation
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
