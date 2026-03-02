local M = {}
function M:create(UI)
  local rect_0 = UI.sceneGroup["rect_0"]
  local rect_1 = UI.sceneGroup["rect_1"]
  self.name = "rect_0_rect_1_distance"
  self.class ="joint"
  self.properties = {
    bodyA = "rect_0",
    bodyB = "rect_1",
    type = "distance", --pistoin, distance, pulle, + defaultSet
    anchorA_x = rect_0.x + rect_0.width  * kwikGlobal.scale * 0.5,
    anchorA_y = rect_0.y + rect_0.height * kwikGlobal.scale * 0.5,
    anchorB_x = rect_1.x + rect_1.width  * kwikGlobal.scale * 0.5,
    anchorB_y = rect_1.y + rect_1.height * kwikGlobal.scale * 0.5,
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
