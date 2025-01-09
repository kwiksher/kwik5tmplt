local M = {
  name = "gearL",
  class="body",
  dataPath = NIL, -- physicsEdtior(CodeAndWeb)
  dataShape ={}
}
function M:create(UI)
  local gearL = UI.sceneGroup["gearL"]
  self.properties = {
    bounce = 1,
    density = 1,
    friction = 1,
    gravityScale = 1,
    isFixedRotation = false,
    isSensor = false,
    radius = 0, -- 0 means use object width/2 if cirlce is selected
    shape   ="circle", -- "circle", -- rectangle,  path
    type = "dynamic", -- kinematic, static, dynamic
  }
  self:_create(UI)

end
return require("components.kwik.layer_physicsBody").set(M)
