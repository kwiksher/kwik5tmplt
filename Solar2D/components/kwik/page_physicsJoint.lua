local physics = require("physics")
local app    = require "controller.Application"

local M = {
  name = NIL,
  properties = {
    anchor_x = 0,
    anchor_y = 0,
    bodyA = "",
    bodyB = "",
    type = "", --pistoin, distance, pulle, + defaultSet
  },
  pivot = {
    isMotorEnabled=false,
    maxMotorTorque = nil,
    motorForce = nil,
    motorSpeed = nil,
    isLimitEnabled = true,
    rotationX = 0,
    rotationY = 0
  },
  piston = {
    anchor_x = 0,
    anchor_y = 0,
    isMotorEnabled=false,
    maxMotorTorque = nil,
    motorForce = nil,
    motorSpeed = nil,
    axisX = 0,
    axisY = 0,
  },
  wheel = {
    anchor_x = 0,
    anchor_y = 0,
    axisX = 0,
    axisY = 0,
  },
  distance = {
    anchorA_x = 0,
    anchorA_y = 0,
    anchorB_x=0,
    anchorB_y=0
  },
  pulley = {statA_x=0, statA_y=0, statB_x=0, statB_y=0, bodyA_x=0, bodyA_y=0, bodyB_x=0, bodyB_y=0, ratio=1.0},
  rope = {offsetA_x=0, offsetA_y=0, offsetB_x=0, offsetB_y=0},
  gear = {joint1="", joint2="", ratio=1},
}


function M:create(UI)
  local sceneGroup  = UI.sceneGroup
  local layer       = UI.layer
  local bodyA         = sceneGroup[self.properties.bodyA]
  local bodyB       = sceneGroup[self.properties.bodyB]
  local body

  if self.properties.body then
    body = sceneGroup[self.properties.body] -- for touch
  end

  if (bodyA == nil or bodyB== nil) and body==nil then
    print("Error no body")
    return
  end

  local defaultSet = table:mySet{
    "friction",
    "weld",
    "touch",
  }

  local obj
  -- local props = self[props.type] or self.properties
  local props = self.properties
  local anchor_x, anchor_y= app.getPosition(props.anchor_x, props.anchor_y)

  if props.type == "piston" or props.type == "wheel" then
    local axisX, axisY = app.getPosition(props.axisX, props.axisY)
    obj = physics.newJoint(props.type, bodyB, bodyA, anchor_x, anchor_y, axisX, axisY)
  elseif props.type == "distance" then
    local anchorA_x, anchorA_y= app.getPosition(props.anchorA_x, props.anchorA_y)
    local anchorB_x, anchorB_y= app.getPosition(props.anchorB_x, props.anchorB_y)

    if UI.props.editing  then
      anchorA_x = anchorA_x + UI.sceneGroup.x/2
      anchorA_y = anchorA_y + UI.sceneGroup.y/2
      anchorB_x = anchorB_x + UI.sceneGroup.x/2
      anchorB_y = anchorB_y + UI.sceneGroup.y/2

    end
    obj = physics.newJoint(props.type, bodyA, bodyB, anchorA_x, anchorA_y, anchorB_x, anchorB_y)
  elseif props.type == "pulley" then
    local statA_x, statA_y = app.getPosition(props.statA_x, props.statA_y)
    local statB_x, statB_y = app.getPosition(props.statB_x, props.statB_y)
    local bodyA_x, bodyA_y = app.getPosition(props.bodyA_x, props.bodyA_y)
    local bodyB_x, bodyB_y = app.getPosition(props.bodyB_x, props.bodyB_y)
    obj = physics.newJoint(props.type, bodyB, bodyA, statA_x, statA_y, statB_x, statB_y, bodyA_x, bodyA_y, bodyB_x, bodyB_y, self.pulley.ratio)
  elseif props.type == "rope" then
    local offsetA_x, offsetA_y = app.getPosition(props.offsetA_x, props.offsetA_y)
    local offsetB_x, offsetB_y = app.getPosition(props.offseA_x, props.offsetB_y)
    obj = physics.newJoint( "rope", bodyA, bodyB, offsetA_x, offsetA_y, offsetB_x, offsetB_y )
  elseif props.type == "gear" then
    obj = physics.newJoint( "gear", bodyA, bodyB, props.joint1, props.joint2, props.ratio )
  elseif props.type == "touch" then
    obj = physics.newJoint(props.type, bodyA, anchor_x, anchor_y)
  else -- pivot
    -- print(props.type, bodyA, bodyB, anchor_x, anchor_y)

    if UI.props.editing  then
      -- UI.sceneGroup.x = display.contentCenterX
      -- UI.sceneGroup.y = display.contentCenterY
      -- UI.sceneGroup.anchorX = .5
      -- UI.sceneGroup.anchorY = .5
      obj = physics.newJoint(props.type, bodyA, bodyB, anchor_x + UI.sceneGroup.x/2, anchor_y + UI.sceneGroup.y/2)
    else
      obj = physics.newJoint(props.type, bodyA, bodyB, anchor_x, anchor_y)
    end

  end

  if obj == nil then
    print("## Error creating a joint")
    return
  end
  --
  if props.type == "pivot" then
    if props.rotationX or props.rotationY then
      local rotX, rotY =app.getPosition( props.rotationX, props.rotationY)
      obj.isLimitEnabled = true
      obj:setRotationLimits(rotX, rotY)
    end
  end
  --
  if props.type == "pivot" or props.tyope == "pistion" then
    if props.isMotorEnabled then
      obj.isMotorEnabled = props.isMotorEnabled
      obj.motorSpeed = props.motorSpeed
      obj.motorForce = props.motorForce
      obj.maxMotorTorque = props.maxMotorTorque
    end
  end
end

M._create = M.create

--
function M:didShow(UI)
end

M.set = function(instance)
  return setmetatable(instance, {__index=M})
end
--
return M