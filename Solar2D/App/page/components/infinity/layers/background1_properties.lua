local M = {}
--
local infinity = require("components.kwik.layer_image_infinity")
--
M.properties = {
  blendMode = "normal",
  height    = 200,
  width     = 2280 ,
  kind      = NIL,
  name      = "background1",
  type      = "png",
  x         = 960,
  y         = 1131,
  alpha     = 1,
  --
  align       = "",
  randXStart  = NIL,
  randXEnd    = NIL,
  randYStart  = NIL,
  randYEnd    = NIL,
  --,
  xScale     = NIL,
  yScale     = NIL,
  rotation   = NIL,
  --,
  layerAsBg     = false,
  isSharedAsset = false,
  ---
  ---
  infinity = {
    enabled = true,
    speed = 4,
    distance = 0,
    direction = "right",
  },
---
}

function M:init(UI)

end
--
function M:create(UI)
  local obj = UI.sceneGroup[self.properties.name]
  self.obj = obj
  --
  -- obj.imagePath = self.imagePath
  local props = self.properties
  ---[[
  -- obj.x         = props.x/4
  -- obj.y         = props.y/4
  -- obj.height    = props.height/4
  -- obj.width     = props.width/4
  obj.alpha     = props.alpha
  obj.oldAlpha  = props.oriAlpha
  obj.blendMode = props.blendMode
  --
  obj.layerAsBg = props.layerAsBg
  obj.isSharedAsset = props.isSharedAsset
  ---
  -- obj.shapedWith = props.layerProps.shapedWith
  obj.randXStart  = props.randXStart
  obj.randXEnd    = props.randXEnd
  obj.randYStart  = props.randYStart
  obj.randYEnd    = props.randYEnd
  -- obj.type        = props.layerProps.type
  -- obj.kind        = props.layerProps.kind

  --
  if type(props.randXStart) == "number" and props.randXStart > 0 then
     obj.x = math.random( props.randXStart, props.randXEnd)
  end
  if type(props.randYStart) == "number" and props.randYStart > 0  then
     obj.y = math.random( props.randYStart, props.randYEnd)
  end
  if type(props.xScale) == "number" then
    obj.xScale = props.xScale
  end
  if type(props.yScale) == "number" then
    obj.yScale = props.yScale
  end
  if type(props.rotation) == "number" then
    obj:rotate( props.rotation )
  end
  --
  obj.oriX = obj.x
  obj.oriY = obj.y
  obj.oriXs = obj.xScale
  obj.oriYs = obj.yScale
  -- obj.name = self.name
  -- obj.type = "image"
  --
  -- sceneGroup[self.name] = obj
  -- print("@@@@", self.name, obj)
  --
  if props.layerAsBg then
    UI.sceneGroup:insert( 1, obj)
  else
    UI.sceneGroup:insert( obj)
  end
--]]

  if self.properties.infinity then
    infinity.createInfinityImage(UI, self.obj, self.properties.infinity)
  end

end
--
function M:didShow(UI)
  if self.properties.infinity.enabled then
    infinity.addEventListener(self.obj)
  end
end
--
function M:didHide(UI)
  if self.properties.infinity.enabled then
    infinity.removeEventListener(self.obj)
  end
end
--
function  M:destroy(UI)
end

--
return M
