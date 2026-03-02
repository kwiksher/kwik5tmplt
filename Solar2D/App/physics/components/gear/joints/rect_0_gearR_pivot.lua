local M = {}
function M:create(UI)
  local rect_0 = UI.sceneGroup["rect_0"]
  local gearR = UI.sceneGroup["gearR"]
  self.name = "rect_0_gearR_pivot"
  self.class ="joint"
  self.properties = {
    bodyA = "rect_0",
    bodyB = "gearR",
    type = "pivot", --pistoin, distance, pulle, + defaultSet
    -- anchor_x = gearR.x+gearR.width/2,
    -- anchor_y = gearR.y+gearR.height/2,
    anchor_x = gearR.x,
    anchor_y = gearR.y,
    isMotorEnabled= false,
    maxMotorTorque = 1000,
    motorForce = 1,
    motorSpeed = 10,
    isLimitEnabled = false,
    rotationX = 0,
    rotationY = 0
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
