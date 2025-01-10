local M = {
  name = NIL,
  class="force",
  properties = {
    event = "touch",
    isInitial = false,
    isImpluse = true,
    type = "", -- push, none
    xForce = 10,
    yForce = 10,
  }
}
return require("components.kwik.layer_physicsForce").set(M)
