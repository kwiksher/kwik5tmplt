local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps
-- layerProps
-- local layerProps = {
--   blendMode = "",
--   height    =   - ,
--   width     =  -  ,
--   kind      = ,
--   name      = "bigCandice",
--   type      = "png",
--   x         =  + ( -)/2,
--   y         =  + ( - )/2,
--   alpha     = /100,
-- }
local M = {
  name = "bigCandice",
  -- commonAsset = "",
  -- class = "canvas", -- button, drag, canvas ...
  --
  -- canvasProps
  properties = {
    autoSave   = true,
    brushSize  = 10,
    brushColor = {0, 0, 1, 1},
    canvasColor      = {1, 1, 1, 1},
    outline    = true,
  },
  --
  actions= nil,
  --
  layerProps = layerProps
}
function M:create(UI)
  self.UI = UI
  local sceneGroup = UI.sceneGroup
  local layerName  = self.layerProps.name
  self.obj        = sceneGroup[layerName]
  if self.isPage then
    sefl.obj = sceneGroup
  end
  --
  self:setCanvas(self.obj)
end
return require("components.kwik.layer_canvas").set(M)