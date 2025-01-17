local M = {
  name = "rect_0",
  class="body",
  dataPath = NIL, -- physicsEdtior(CodeAndWeb)
  dataShape ={}
}
function M:create(UI)
  local rect_0 = UI.sceneGroup["rect_0"]
  self.properties = {
    bounce = nil,
    density = nil,
    friction = nill,
    gravityScale = nil,
    isFixedRotation = true,
    isSensor = false,
    radius = NIL, -- NIL means use object width/2
    shape   ="rectangle", -- "circle", -- rectangle,  path
    type = "dynamic", -- kinematic, static, dynamic
  }
  self:_create(UI)

end
return require("components.kwik.layer_physicsBody").set(M)
