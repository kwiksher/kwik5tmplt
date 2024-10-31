local props = {
  name     = "LED",
  properties = {
    isAfter  = false,
    isLocal  = true, -- or local
    type     = "string", -- table
    isSave   = true,
    value    = ""
  }
}

return require("components.kwik.page_variable").set(props)
