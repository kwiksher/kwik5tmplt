local physics = require("physics")

local M = {
  name = NIL, -- must be a layer name
  properties = {
    bounce = 0,
    density = 0,
    friction = 0,
    gravityScale = NIL,
    isSensor = false,
    radius = NIL,
    shape   = "circle", -- rect,  path
    type = "static",
  },
  dataPath = "", -- physicsEdtior(CodeAndWeb)
  dataShape = {}
}
--

function M:didShow(UI)
  local sceneGroup  = UI.sceneGroup
  local layer       = UI.layer
  local curPage = UI.curPage
  local props = self.properties

  local obj = sceneGroup[self.name]
  --
  -- print("@@@@", props.shape)
  if props.shape == "circle" then
    physics.addBody(obj, props.type, {density=props.density, friction=props.friction, bounce=props.bounce, radius=props.radius })
  elseif props.shape == "rect" then
    physics.addBody(obj, props.type, {density=props.density, friction=props.friction, bounce=props.bounce })
  elseif props.shape == "path" then
    physics.addBody(obj, props.type, {density=props.density, friction=props.friction, bounce=props.bounce, shape=self.dataShape })
  else -- physicsEditor data
    if self.dataPath ~= NIL then
      local physicsData = require(self.dataPath).physicsData(1.0)
      physics.addBody(obj, physicsData:get(self.name))
    end
  end
  --
  if obj then
    obj.isSensor = props.isSensor
    --
    if props.gravityScale then
        obj.gravityScale = props.gravityScale
    end
  end
end
--
M.set = function(model)
  return setmetatable( model, {__index=M})
end

return M