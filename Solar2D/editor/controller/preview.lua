local name = ...
local parent, root = newModule(name)
local Animation = require("components.kwik.layer_animation")

local instance =
  require("commands.kwik.baseCommand").new(
  function(params)
    local UI = params.UI
    print(name)
    local props = params.props
    --print(props.class)
    for k, v in pairs(props.to) do
      print("", k, v)
    end

    if params.class =="animation" then
      local player = Animation.new(props)
      --
      local function onEndHandler(UI)
        if props.actionName:len() > 0 then
          Runtime:dispatchEvent({name = UI.page .. props.actionName, event = {}, UI = UI})
        end
      end
      --
      local rootGroup = UI.rootGroup
      player:initAnimation(UI, rootGroup[props.name], onEndHandler)
      player.tween = player:buildAnim(UI)
      -- player.tween:pause()
      player.tween:play()
    end
  end
)
--
return instance
