local props = {
  name     = "{{name}}",
  isAfter  = {{isAfter}},
  isLocal  = {{isLocal}}, -- or local
  type     = "{{type}}", -- table
  isSave   = {{isSave}},
  value    = {{value}}
}

return require("components.kwik.page_variable").set(props)
