local M = {
  name = "rect_0",
  class="force",
  properties = {
    event = "touch",
    isInitial = false,
    isImpluse = true,
    type = "", -- push, none
    xForce = 20,
    yForce = 10,
  }
}
return require("components.kwik.layer_physicsForce").set(M)
