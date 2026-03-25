local props = {
  name       = "groupCat",
  members   = {
    "cat",
    "cat_face1",
  },
  properties = {
    alpha = NIL,
    xScale = NIL,
    yScale = NIL,
    rotation = NIL,
    isLuaTable = false
  }
}

return require("components.kwik.page_group").set(props)
