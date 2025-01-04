local M = {}
function M:create(UI)
  local rect_0 = UI.sceneGroup["rect_0"]
  local rect_1 = UI.sceneGroup["rect_1"]
  self.name = "rect_0_rect_1_pulley"
  self.class ="joint"
  self.properties = {
    bodyA = "rect_0",
    bodyB = "rect_1",
    type = "pulley", --pistoin, distance, pulle, + defaultSet
    statA_x= rect_0.x+rect_0.width/2,
    statA_y= rect_0.y+rect_0.height/2 - 100,
    statB_x= rect_1.x+rect_1.width/2,
    statB_y= rect_0.y+rect_0.height/2 -100,
    bodyA_x= rect_0.x+rect_0.width/2,
    bodyA_y= rect_0.y+rect_0.height/2,
    bodyB_x= rect_1.x+rect_1.width/2,
    bodyB_y= rect_1.y+rect_1.height/2,
    ratio  = 1,
  }
  self:_create(UI)

  -- local circleA = display.newCircle(self.properties.bodyA_x, self.properties.bodyA_y, 10)
  -- circleA:setFillColor(1, 0, 0)
  -- UI.sceneGroup:insert(circleA)
  -- local B = display.newCircle(self.properties.bodyB_x, self.properties.bodyB_y, 10)
  -- B:setFillColor(1, 1, 0)
  -- UI.sceneGroup:insert(B)

  -- local circleAS = display.newCircle(self.properties.statA_x, self.properties.statA_y, 10)
  -- circleAS:setFillColor(1, 0, 0)
  -- UI.sceneGroup:insert(circleAS)

  -- local BS = display.newCircle(self.properties.statB_x, self.properties.statB_y, 10)
  -- BS:setFillColor(1, 1, 0)
  -- UI.sceneGroup:insert(BS)

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
