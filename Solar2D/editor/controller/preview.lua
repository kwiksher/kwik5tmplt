local name = ...
local parent, root = newModule(name)
local Animation = require("components.kwik.layer_animation")

local instance =
  require("commands.kwik.baseCommand").new(
  function(params)
    local UI = params.UI
    print(name, params.props.layer, params.class)
    local props = params.props
    --print(props.class)
    for k, v in pairs(props.to) do
      print("", k, v)
    end

    if params.class == "animation" then
      local player = Animation.set(props)
      --
      local function onEndHandler(UI)
        if props.actions.onComplete then
          UI.scene.app:dispatchEvent {
            name = props.actions.onComplete,
            event = {UI = UI},
            UI = UI
          }
        -- Runtime:dispatchEvent({name = UI.page .. props.actions.onComplete, event = {}, UI = UI})
        end
      end
      --
      local sceneGroup = UI.sceneGroup
      player:initAnimation(UI, sceneGroup[props.layer], onEndHandler)
      player.tweenFrom, player.tweenTo = player:buildAnim(UI)
      -- player.tween:pause()
      player:init()
      player.tweenFrom:play()
      -- player.tweenTo:play()
    end
  end
)
--
return instance
