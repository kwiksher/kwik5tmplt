local props = {
  name     = "numDica",
  properties = {
    isAfter  = false,
    isLocal  = true, -- or local
    type     = "string", -- table
    isSave   = true,
    value    = "112233"
  }
}

return require("components.kwik.page_variable").set(props)
