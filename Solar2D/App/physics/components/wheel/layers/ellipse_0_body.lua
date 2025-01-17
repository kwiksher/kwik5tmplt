local M = {
  name = "ellipse_0",
  class="body",
  dataPath = NIL, -- physicsEdtior(CodeAndWeb)
  dataShape ={}
}
function M:create(UI)
  local ellipse_0 = UI.sceneGroup["ellipse_0"]
  self.properties = {
      bounce = 0,
      density = 1,
      friction = 1,
      gravityScale = 1,
      isFixedRotation = false,
      isSensor = false,
      radius = 30, -- NIL means use object width/2
      shape   ="circle", -- "circle", -- rectangle,  path
      type = "dynamic", -- kinematic, static, dynamic
  }
  self:_create(UI)

  ellipse_0:applyTorque( 20 )

end
return require("components.kwik.layer_physicsBody").set(M)
