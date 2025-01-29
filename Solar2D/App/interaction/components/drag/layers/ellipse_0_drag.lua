local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps
local MultiTouch = require("extlib.dmc_multitouch")
local M = {
  name ="ellipse_0",
  -- commonAsset = "",
  -- class = "drag", -- button, drag, canvas ...
  --
  -- dragProps
  properties = {
    target = "ellipse_0",
    type  = "",
    constrainAngle = NIL,
    boundaries = {xMin=0, xMax=1920, yMin=0, yMax=1080},
    isActive = true,
    isFocus = true,
    isPage = false,
    --
    isFlip = true,
    flipInitialDirection  = "right", -- "left", "bottom", "top"
    -- flipAxis = "x", -- "y",
    -- flipValue      = 0,
    -- flipScale = 1, -- -1
    -- --
    isDrop = true,
    dropArea = "rect_0",
    dropMargin = 10,
    --
    -- dropBound = {xMin=0, xMax=0, yMin = 0, yMax=0},
    --
    rock = 1, -- 0,
    backToOrigin = true,
  }
}
M.layerProps = layerProps
M.actions={
  onDropped = "",
  onReleased ="",
  onMoved=""
}
function M:create(UI)
  self.UI = UI
end
function M:didShow(UI)
  self.UI = UI
  -- self:addEventListener(self.obj)
  local sceneGroup = UI.sceneGroup
  local layerName  = self.properties.target
  self.obj        = sceneGroup[layerName]
  if self.isPage then
    self.obj = sceneGroup
  end
  --
  self.obj.dropArea = sceneGroup[self.properties.dropArea]
  -- printKeys(self.obj)
  self.obj.oriX, self.obj.oriY = self.obj.x, self.obj.y
  self:activate(self.obj)
end
function M:didHide(UI)
  -- self:removeEventListener(self.obj)
  self:deactivate(self.obj)
end
return require("components.kwik.layer_drag").set(M)
