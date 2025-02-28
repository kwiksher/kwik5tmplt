local M = {
  name = "rect_0",
  class="force",
  properties = {
    body = "rect_0",
    event = "touch",
    isInitial = false,
    isImpluse = true,
    type = "", -- push, none
    xForce = 20,
    yForce = 10,
  }
}
return require("components.kwik.layer_physicsForce").set(M)
