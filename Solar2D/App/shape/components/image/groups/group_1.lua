local props = {
  name       = "group_1",
  members   = {
    "snowman",
    "hat",
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
