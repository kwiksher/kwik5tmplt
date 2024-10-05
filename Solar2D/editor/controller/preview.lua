local name = ...
local parent, root = newModule(name)
local Animation = require("components.kwik.layer_animation")
local Filter = require("components.kwik.layer_filter")


local instance =
  require("commands.kwik.baseCommand").new(
  function(params)
    local UI = params.UI
    print(name, params.props.layer, params.class)
    local props = params.props
    --print(props.class)
    if props.to.color1 then
      for k, v in pairs(props.to.color1) do
        print("", k, v)
      end
    end

    if params.tool == "animation" then
      props.class = params.class
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
      if params.class == "filter" then
        local player = Filter.set(props)
        props.properties.autoPlay = true
        player:create(UI)
        player:didShow(UI)
      else
        local sceneGroup = UI.sceneGroup
        player:initAnimation(UI, sceneGroup[props.layer], onEndHandler)
        player.tween = player:buildAnim(UI)
        -- player.tween:pause()
        player:init()
        if player.tween.from then
          player.tween.from:play()
        else
          player.tween.to:play()
        end
      end
    end
  end
)
--
return instance
