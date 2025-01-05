local M = {}
function M:create(UI)
  local ellipse_1 = UI.sceneGroup["ellipse_1"]
  local rect_1 = UI.sceneGroup["rect_1"]
  self.name = "ellipse_1_rect_1_gear"
  self.class ="joint"
  self.properties = {
    bodyA = "ellipse_1",
    bodyB = "rect_1",
    type = "gear", --pistoin, distance, pulle, + defaultSet
    joint1="rect_0_ellipse_1_pivot",
    joint2="rect_0_rect_1_piston",
    ratio  = -1*40/80,
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
