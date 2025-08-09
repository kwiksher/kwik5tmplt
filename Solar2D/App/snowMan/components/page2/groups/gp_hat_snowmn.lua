local props = {
  name       = "gp_hat_snowmn",
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
  },
  layerProps = {name = "gp_hat_snowmn"}
}
return require("components.kwik.page_group").set(props)
