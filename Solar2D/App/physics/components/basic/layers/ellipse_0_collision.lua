local name = ...
local parent, root = newModule(name)
local M = {
  name = "ellipse_0",
  class="collision",
  properties = {
    body          = "ellipse_0",
    isRemoveOther = false,
    isRemoveSelf = false,
    others  =  "hitGroup"
  },
  actions = {
    onCollision="testPhysics"
  },
}
return require("components.kwik.layer_physicsCollision").set(M)
