local props = {
  name     = "myvar1",
  properties = {
    isAfter  = false,
    isLocal  = true, -- or local
    valueType     = "function", -- table
    isSave   = true,
    value    = print
  }
}
return require("components.kwik.page_variable").set(props)
