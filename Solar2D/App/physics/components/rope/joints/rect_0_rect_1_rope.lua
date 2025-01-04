local M = {}
function M:create(UI)
  local rect_0 = UI.sceneGroup["rect_0"]
  local rect_1 = UI.sceneGroup["rect_1"]
  self.name = "rect_0_rect_1_rope"
  self.class ="joint"
  self.properties = {
    bodyA = "rect_0",
    bodyB = "rect_1",
    type = "rope", --pistoin, distance, pulle, + defaultSet
    offsetA_x= 25,
    offsetA_y= 25,
    offsetB_x = 25,
    offsetB_y = 25,
    maxLength = 200
  }
  self:_create(UI)
  --[[
  local circleA = display.newCircle(self.properties.anchorA_x, self.properties.anchorA_y, 10)
  circleA:setFillColor(1, 0, 0)
  UI.sceneGroup:insert(circleA)
  local B = display.newCircle(self.properties.anchorB_x, self.properties.anchorB_y, 10)
  B:setFillColor(1, 1, 0)
  UI.sceneGroup:insert(B)
  local circle = display.newCircle(self.properties.anchor_x, self.properties.anchor_y, 10)
  circle:setFillColor(1, 0, 0)
  UI.sceneGroup:insert(circle)
  --]]
end
return require("components.kwik.page_physicsJoint").set(M)
