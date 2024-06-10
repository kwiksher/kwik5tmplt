local M = {
  name = "",
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

return M