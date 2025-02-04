local props = {
  name       = "group0",
  members   = {
    "rect1",
    "rect2",
    "rect3",
  },
  properties = {
    alpha = 1,
    xScale = 1,
    yScale = 1,
    rotation = 0,
    isLuaTable = false
  }
}
return require("components.kwik.page_group").set(props)
