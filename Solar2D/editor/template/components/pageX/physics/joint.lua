local M = {
  name = NIL,
  properties = {
    anchor_x = {{anchor_x}},
    anchor_y = {{anchor_y}},
    bodyA = "{{bodyA1}}",
    bodyB = "{{bodyB}}",
    type = "{{type}}", --pistoin, distance, pulle, + defaultSet
  },
  pivot = {
    isMotorEnabled= {{isMotorEnabled}},
    maxMotorTorque = {{maxMotorTorque}},
    motorForce = {{motorForce}},
    motorSpeed = {{motorSpeed}},
    isLimitEnabled = {{isLimitEnabled}},
    rotationX = {{rotationX}},
    rotationY = {{rorationY}}
  },
  piston = {
    anchor_x = {{anchor_x}},
    anchor_y = {{anchor_y}},
    isMotorEnabled= {{isMotorEnabled}},
    maxMotorTorque = {{maxMotorTorque}},
    motorForce = {{motorForce}},
    motorSpeed = {{motorSpeed}},
    axisX = {{axisX}},
    axisY = {{axisY}},
  },
  wheel = {
    anchor_x = {{anchor_x}},
    anchor_y = {{anchor_y}},
    axisX = {{axisX}},
    axisY = {{axisY}},
  },
  distance = {
    anchorA_x = {{anchorA_x}},
    anchorA_y = {{anchorA_y}},
    anchorB_x = {{anchorB_x}},
    anchorB_y = {{anchorB_y}},
  },
  pulley = {
    statA_x= {{statA_x}},
    statA_y= {{statA_y}},
    statB_x= {{statB_x}},
    statB_y= {{statB_y}},
    bodyA_x= {{bodyA_x}},
    bodyA_y= {{bodyA_y}},
    bodyB_x= {{bodyB_x}},
    bodyB_y= {{bodyB_y}},
    ratio  = {{ratio}},
  },
  rope = {
    offsetA_x= {{offsetA_x}},
    offsetA_y= {{offsetA_y}},
    offsetB_x = {{offsetB_x}},
    offsetB_y = {{offsetB_y}},
  },
  gear = {
    joint1="{{joint1}}",
    joint2="{{joint2}}",
    ratio  = {{ratio}},
  },

}

return require("components.kwik.layer_physicsJoint").set(M)
