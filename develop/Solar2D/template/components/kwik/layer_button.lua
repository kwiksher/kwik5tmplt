-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _Class = {}
--
function _Class:addEventListenerForTap(UI, model)
   function model.obj:tap(event)
    event.UI = UI
    if model.enabled or model.enabled == nil then
      if model.btaps and event.numTaps then
        if event.numTaps == model.btaps then
            UI.scene:dispatchEvent({name=model.eventName, event = event})
        end
      else
            UI.scene:dispatchEvent({name=model.eventName, event = event})
      end
    end
  end
  model.obj:addEventListener("tap", model.obj)
end
--
function _Class:removeEventListenerForTap(UI, model)
  self.UI = UI
  model.obj:removeEventListener("tap", model.obj)
end
---------------------
---------------------
_Class.new = function(scene)
  local uiModel =  {}
  uiModel.scene = scene
  return  setmetatable( uiModel, {__index=_Class})
end
--
return _Class