local parent,root, M = newModule(...)
local layerMod = require(M.layerMod)
--
local infinity = require("components.kwik.layer_image_infinity")
--
M.properties = {
  blendMode = "",
  height    = nil,
  width     = nil ,
  kind      = "",
  name      = "tree",
  type      = "",
  x         = nil,
  y         = nil,
  alpha     = nil,
  --
  align       = "",
  randXStart  = nil,
  randXEnd    = nil,
  randYStart  = nil,
  randYEnd    = nil,
  --,
  xScale     = nil,
  yScale     = nil,
  rotation   = nil,
  --,
  layerAsBg     = false,
  isSharedAsset = true,
  ---
  ---
  infinity = {
    enabled = false,
    speed = 1,
    distance = 0,
    direction = "right",
  },
---
}
M.properties.imagePath   = "page1/tree.png"
--
function M:init(UI)
  -- overwrite layerMod properties by M.properties one by one if not nil
  for k, v in pairs(M.properties) do
    if v ~= nil and v ~= "" and k ~="name" then
      layerMod[k] = v
    end
  end
end
--
function M:create(UI)
  local obj = UI.sceneGroup[layerMod.name]
  self.obj = obj
  --
  --
  -- obj.imagePath = self.imagePath
  local props = self.properties
  -- obj.x         = props.x/4
  -- obj.y         = props.y/4
  -- obj.height    = props.height/4
  -- obj.width     = props.width/4
  if props.alpha then
    obj.alpha     = props.alpha
  end
  -- obj.oldAlpha  = props.oriAlpha
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
  if props.randXStart and props.randXStart > 0 then
    obj.x = math.random( props.randXStart, props.randXEnd)
  end
  if props.randYStart and props.randYStart > 0  then
    obj.y = math.random( props.randYStart, props.randYEnd)
  end
  if props.xScale then
    obj.xScale = props.xScale
  end
  if props.yScale then
    obj.yScale = props.yScale
  end
  if props.rotation then
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
  --
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
