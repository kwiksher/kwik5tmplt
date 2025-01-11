local name = ...
local parent, root = newModule(name)
local M = {
  name = "ellipse_0",
  class="collision",
  properties = {
    body          = "ellipse_0",
    isRemoveOther = true,
    isRemoveSelf = true,
    others  =  "hitGroup"
  },
  actions = {
    onCollision="testPhysics"
  },
}
return require("components.kwik.layer_physicsCollision").set(M)
