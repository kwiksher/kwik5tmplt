local M = {
  name = "switch",
  class="Switch",
  properties = {
    target = NIL,
    autoPlay=true,
    delay=0,
    duration=100,
    to = NIL,
  },
  layerOptions = {
    isGroup = false,
    isSceneGroup = false,
    isSpritesheet = false,
  },
  fillOptions = {
    isGroup = false,
    isSceneGroup = false,
    isSpritesheet = false,
  },

  actions = {onComplete = nil}
}

return M