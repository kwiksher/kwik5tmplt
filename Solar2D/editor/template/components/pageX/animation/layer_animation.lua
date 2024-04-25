local M = {
  name = "{{name}}",
  --
  class = "{{class}}",
    -- "Dissolve"
    -- "Path"
    -- "Linear"
    -- "Pulse"
    -- "Rotation"
    -- "Shake"
    -- "Bounce"
    -- "Blink"
  --
  obj = require(parent.."{{layer}}").obj
}

{{#layerOptions}}
M.layerOptions = {
  -- layerProps
  isGroup = {{isGroup}},
  isSceneGroup = {{isSceneGroup}},
  isSpritesheet = {{isSpritesheet}},
  --
  referencePoint = "{{referencePoint}}",
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
  deltaX         = {{deltaX}},
  deltaY         = {{deltaY}},
}
{{/layerOptions}}
-- animationProps
M.settings = {
{{#settings}}
  autoPlay = {{autoPlay}},
  delay    = {{delay}},
  duration = {{duration}},
  loop     = {{loop}},
  reverse  = {{reverse}},
  resetAtEnd  = {{resetAtEnd}},
  --
  easing   = "{{easing}}",
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
  xSwipe   = {{xSwipe}},
  ySwipe   = {{ySwipe}},
}
{{/settings}}
  --

{{#to}}
M.to = {
  x     = {{x}},
  y     = {{y}},
  --
  alpha = {{alpha}},

  yScale   = {{yScale}},
  xScale   = {{xScale}},
  rotation = {{rotation}},
}
{{/to}}
  -- more option

  -- action at the end of animation
M.actions = { onComplete = "{{actionName}}" }


{{#breadcrumb}}
M.breadcrumbs = {
    dispose  = {{dispose}},
    shape    = {{shape}},
    Color    = {{color}},
    interval = {{bInterval}},
    time     = {{time}},
    width  = {{width}},
    height = {{height}},
}
{{/breadcrumb}}

{{#path}}
if M.animation.Class == "Path" then
	M.pathProps = {
    curve = 	{{pathCurve}},
    angle = {{angle}},
    newAngle = {{newAngle}},
  }
end
{{/path}}
---------------------------------------
--
local function onEndHandler (UI)
  if M.actionName:len() > 0  then
    Runtime:dispatchEvent({name=UI.page..M.actionName, event={}, UI=UI})
  end
end
--
function M:create(UI)
  self:init(UI, onEndHandler)
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