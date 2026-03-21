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
  referencePoint = "TopRight",
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
  target = "rect_0",
  autoPlay = false,
  delay    = 1000,
  duration = 2000,
  loop     = 1,
  reverse  = nil,
  resetAtEnd  = nil,
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
  xSwipe   = nil,
  ySwipe   = nil,
  useLang  = false
}
--
M.from = {
  x     = 184,
  y     = 137.5,
  --
  alpha = 1,
  yScale   = 1,
  xScale   = 1,
  rotation = 0,
}
--
M.to = {
  x     = 253,
  y     = 135.5,
  --
  alpha = 1,
  yScale   = 1.5,
  xScale   = 1,
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
