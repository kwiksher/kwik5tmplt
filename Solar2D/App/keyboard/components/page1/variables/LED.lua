local props = {
  name     = "LED",
  properties = {
    isAfter  = false,
    isLocal  = true, -- or local
    type     = "string", -- table
    isSave   = true,
    value    = "332211"
  }
}

return require("components.kwik.page_variable").set(props)
