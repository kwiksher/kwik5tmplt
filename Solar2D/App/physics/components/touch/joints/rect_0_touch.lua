local M = {}
function M:create(UI)
  local rect_0 = UI.sceneGroup["rect_0"]
  self.name = "rect_0_touch"
  self.class ="joint"
  self.properties = {
    bodyA = "",
    bodyB = "",
    type = "touch", --pistoin, distance, pulle, + defaultSet
    body     = "rect_0",
    anchor_x = rect_0.x+rect_0.width* kwikGlobal.scale * 0.5,
    anchor_y = rect_0.y+rect_0.height* kwikGlobal.scale * 0.5,
    frequency = 0.8,
    dampingRatio = 0.2,
    maxForce = 1000,
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

  timer.performWithDelay(2000, function()
    local rect_1 = UI.sceneGroup["rect_1"]
     self.joint:setTarget( rect_1.x , rect_1.y )
  end)

end
return require("components.kwik.page_physicsJoint").set(M)
