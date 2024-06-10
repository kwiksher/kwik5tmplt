local M = {
  name = NIL,
  class="force",
  properties = {
    event = "{{event}}",
    isInitail = {{isInitail}},
    isImpluse = {{isImpluse}},
    type = "{{type}}", -- push, none
    xForce = {{xforce}},
    yForce = {{yForce}},
  }
}

return require("components.kwik.layer_physicsForce").set(M)
