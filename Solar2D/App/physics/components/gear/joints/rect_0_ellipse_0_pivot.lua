local M = {}
function M:create(UI)
  local rect_0 = UI.sceneGroup["rect_0"]
  local ellipse_0 = UI.sceneGroup["ellipse_0"]
  self.name = "rect_0_ellipse_0_pivot"
  self.class ="joint"
  self.properties = {
    bodyA = "rect_0",
    bodyB = "ellipse_0",
    type = "pivot", --pistoin, distance, pulle, + defaultSet
    -- anchor_x = ellipse_0.x,
    -- anchor_y = ellipse_0.y,
    anchor_x = ellipse_0.x+ellipse_0.width/2,
    anchor_y = ellipse_0.y+ellipse_0.height/2,
    isMotorEnabled= true,
    maxMotorTorque = 1000,
    motorForce = 10,
    motorSpeed = 10,
    isLimitEnabled = true,
    rotationX = -90,
    rotationY = 180
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
