local parent,root, M = newModule(...)
M.class = "linear"
-- "dissolve"
-- "path"
-- "linear"
-- "pulse"
-- "rotation"
-- "tremble"
-- "bounce"
-- "blink"
M.layerOptions = {
  --
  referencePoint = "BottomCenter",
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
  deltaX         = 0,
  deltaY         = 0,
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
  rotation = -10,
}
-- more option
-- action at the end of animation
M.actions = { onComplete = "" }
M.breadcrumbs = {
  enable  = false,
  dispose  = true,
  shape    = "",
  color    =  { 16581375, 0, 0, 0.2 },
  interval = 50,
  time     = 1000,
  width  = 30,
  height = 30,
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
  local target = self.properties.target
  if UI.langClassDelegate and useLang then
    local t = target:split("/")
    target = t[1].."/".. UI.lang
  end
  --
  if self.properties.type == "group" then
    self.obj = require(parent..self.properties.target).group
  else
    self.obj = UI.sceneGroup[target]
  end
  self:initAnimation(UI, self.obj, onEndHandler)
  self.animation = self:buildAnim(UI)
  UI.animations[target.."_"..self.class..self.suffix] = self.animation
end
--
function M:didShow(UI)
  local sceneGroup = UI.sceneGroup
  if self.properties.autoPlay then
    if self.animation.to then
      --self.animation.to:toBeginning()
      self.animation.to:play()
    end
  end
end
--
function M:didHide(UI)
  if self.animation.to then
    self.animation.to:pause()
    -- self.animation.to:toBeginning()
  end
end
--
return require("components.kwik.layer_animation").set(M)
