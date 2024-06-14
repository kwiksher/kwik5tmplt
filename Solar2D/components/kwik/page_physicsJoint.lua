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
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  local bodyA         = sceneGroup[self.properties.bodyA]
  local bodyB       = sceneGroup[self.properties.bodyB]
  local body = sceneGroup[self.properties.body] -- for touch

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
  local anchor_x, anchor_y= app.getPosition(params.anchor_x, props.anchor_y)
  -- local params = self[props.type] or self.properties
  local params = self.properties

  if props.type == "pistion" or props.type == "wheel" then
    local axisX, axisY = app.getPosition(params.axisX, params.axisY)
    obj = physics.newJoint(props.type, bodyB, bodyA, anchor_x, anchor_y, axisX, axisY)
  elseif props.type == "distance" then
    local anchorA_x, anchorA_y= app.getPosition(params.anchorA_x, params.anchorA_y)
    local anchorB_x, anchorB_y= app.getPosition(params.anchorB_x, params.anchorB_y)
    obj = physics.newJoint(props.type, bodyA, bodyB, anchorA_x, anchorA_y, anchorB_x, anchorB_y)
  elseif props.type == "pulley" then
    local statA_x, statA_y = app.getPosition(params.statA_x, params.statA_y)
    local statB_x, statB_y = app.getPosition(params.statB_x, params.statB_y)
    local bodyA_x, bodyA_y = app.getPosition(params.bodyA_x, params.bodyA_y)
    local bodyB_x, bodyB_y = app.getPosition(params.bodyB_x, params.bodyB_y)
    obj = physics.newJoint(props.type, bodyB, bodyA, statA_x, statA_y, statB_x, statB_y, bodyA_x, bodyA_y, bodyB_x, bodyB_y, self.pulley.ratio)
  elseif props.type == "rope" then
    local offsetA_x, offsetA_y = app.getPosition(params.offsetA_x, params.offsetA_y)
    local offsetB_x, offsetB_y = app.getPosition(params.offseA_x, params.offsetB_y)
    obj = physics.newJoint( "rope", bodyA, bodyB, offsetA_x, offsetA_y, offsetB_x, offsetB_y )
  elseif props.type == "gear" then
    obj = physics.newJoint( "gear", bodyA, bodyB, params.joint1, params.joint2, params.ratio )
  elseif props.type == "touch" then
    obj = physics.newJoint(props.type, bodyA, anchor_x, anchor_y)
  else
    obj = physics.newJoint(props.type, bodyA, bodyB, anchor_x, anchor_y)
  end
  --
  if props.type == "pivot" then
    if props.rotationX or props.rotationY then
      local rotX, rotY =app.getPosition( params.rotationX, params.rotationY)
      obj.isLimitEnabled = true
      obj:setRotationLimits(rotX, rotY)
    end
  end
  --
  if props.type == "pivot" or props.tyope == "pistion" then
    if params.isMotorEnabled then
      obj.isMotorEnabled = params.isMotorEnabled
      obj.motorSpeed = params.motorSpeed
      obj.motorForce = params.motorForce
      obj.maxMotorTorque = params.maxMotorTorque
    end
  end
end
--
function M:didShow(UI)
end

M.set = function(instance)
  return setmetatable(instance, {__index=M})
end
--
return M