local M = {}
function M:create(UI)
  local rect_0 = UI.sceneGroup["rect_0"]
  local ellipse_1 = UI.sceneGroup["ellipse_1"]
  self.name = "rect_0_ellipse_1_wheel"
  self.class ="joint"
  self.properties = {
    bodyA = "rect_0",
    bodyB = "ellipse_1",
    type = "wheel", --pistoin, distance, pulle, + defaultSet
    anchor_x = ellipse_1.x, -- + ellipse_1.width* kwikGlobal.scale * 0.5,
    anchor_y = ellipse_1.y, -- + ellipse_1.height* kwikGlobal.scale * 0.5,
    axisX = 0,
    axisY = 1,
    springFrequency = 10,
    springDampingRatio = 1
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
