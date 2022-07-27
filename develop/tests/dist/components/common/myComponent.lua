-- $weight=-1
--
local _M = {}
local App = require("controller.Application")

--
function _M:init(UI)
end

local function onKeyEvent( event )

  -- Print which key was pressed down/up
  local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
  print( message )

  local app = App.get(1)
  local scenes = app.props.scenes

  print("onKeyEvent", app.currentViewName)
  if event.keyrName =="a" then
    local getPrevious = function ()
      for i=1, #scenes do
        local sceneName = "scenes." .. scenes[i]..".index"
        if sceneName == app.currentViewName then
          if i==1 then return "scenes." .. scenes[#scenes]..".index" end
          return "scenes." .. scenes[i-1]..".index"
        end
      end
      return app.currentViewName
    end
    app:showView(getPrevious())

  elseif event.keyName =="d" then
    local getNext = function ()
      for i=1, #scenes do
        local sceneName = "scenes." .. scenes[i]..".index"
        if sceneName == app.currentViewName then
          if i==#scenes then return "scenes." .. scenes[1]..".index" end
          return "scenes." .. scenes[i+1]..".index"
        end
      end
      return app.currentViewName
    end
    app:showView(getNext())
  end

  -- If the "back" key was pressed on Android, prevent it from backing out of the app
  if ( event.keyName == "back" ) then
      if ( system.getInfo("platform") == "android" ) then
          return true
      end
  end

  -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
  -- This lets the operating system execute its default handling of the key
  return false
end

--
function _M:create(UI)
  local sceneGroup = UI.scene.view
  local obj = display.newCircle( sceneGroup, display.contentCenterX, display.contentCenterY-400, 50 )
  obj:setFillColor(0.2,0.8,0.8);
end
--
function _M:didShow(UI)
  local sceneGroup = UI.scene.view
  print ("------------")
  for k, v in pairs(UI.layers) do print(k, v) end
  local bg = UI.layers[#UI.layers]
  bg:addEventListener("tap", function(event)
      print("bg is tapped")
  end)


-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )

end
--
function _M:didHide(UI)
  local sceneGroup = UI.scene.view

  Runtime:removeEventListener( "key", onKeyEvent )

end
--
function  _M:destory()
end
--
return _M