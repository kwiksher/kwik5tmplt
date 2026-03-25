local props = {
  name     = "myText",
  properties = {
    isAfter  = false,
    isLocal  = true, -- or local
    isSave   = true,
    value    = "Miki Kamekai",
    valueType     = "string", -- table
  }
}
return require("components.kwik.page_variable").set(props)
