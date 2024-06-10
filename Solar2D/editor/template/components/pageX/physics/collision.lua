local M = {
  name = NIL,
  class="collision",
  properties = {
    isRemoveOther = {{isRemoveOther}},
    isRemoveSelf = {{isRemoveSelf}}
  },
  actions = {
    { onCollision="{{onCollision}}" }
  },
  others = {
    {{#others}}
    {{.}},
    {{/others}}
  }
}

return require("components.kwik.layer_physicsCollision").set(M)
