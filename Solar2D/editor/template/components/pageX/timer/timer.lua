local props = {
  actionName    = "{{actionName}}",
  delay     = {{delay}},
  iterations = {{iterations}},
  name     = "{{name}}",
}

return require("components.kwik.page_timer").set(props)
