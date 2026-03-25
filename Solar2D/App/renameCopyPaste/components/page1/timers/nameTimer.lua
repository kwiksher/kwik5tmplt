local props = {
  name     = "nameTimer",
  properties = {
    delay     = 3000,
    iterations = 1,
  },
  actions = {
    onComplete    = "nameAct",
  }
}
return require("components.kwik.page_timer").set(props)
