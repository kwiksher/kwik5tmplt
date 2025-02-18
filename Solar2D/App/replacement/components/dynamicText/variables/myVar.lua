local props = {
  name     = "myVar",
  properties = {
    isAfter  = false,
    isLocal  = true, -- or local
    type     = "string", -- table
    isSave   = true,
    value    = 'Hello Dynamic Text'
  }
}
return require("components.kwik.page_variable").set(props)
