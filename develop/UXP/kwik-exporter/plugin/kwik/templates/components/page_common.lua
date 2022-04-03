-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
local _K = require("Application")
local composer = require("composer")
local _Delay = 0 -- Kwik3 was 1000
---------------------
local props = require("models.page01.components.page_common")

_M = setmetatable( _M, {__index=props})

-- _M.xScale = {{xScale}}
-- _M.yScale = {{yScale}}
-- _M.alpha  = {{alpha}}
-- _M.preload = {{preload}}

---------------------
function _M:localPos(UI)
    local sceneGroup  = UI.scene.view
    local layer       = UI.layer
  -- Page properties
  if self.xScale and self.yScale then 
    sceneGroup.xScale = self.xScale
    sceneGroup.yScale = self.yScale
    sceneGroup.alpha = self.alpha
  end
end
--
function _M:allListeners(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  local curPage     = UI.curPage
  local numPages    = UI.numPages
  local allAudios   = UI.allAudios
    -- purges previous and next scenes
    local __prevScene = composer.getSceneName( "previous" )
    if nil~= __prevScene then
      composer.removeScene(__prevScene, true)
    end
      -- Check for previous bookmarks
     if (tonumber(_K.kBookmark) == 1) then
        local path = system.pathForFile( "book.txt", system.DocumentsDirectory )
        local file = io.open( path, "w+" )
        file:write ( curPage.."\n1" )
        io.close( file )
     end

      -- Check for for auto play settings
     if (tonumber(_K.kAutoPlay) > 0) then
       local function act_autoPlay(event)
         if(curPage < numPages) then
            if nil~= composer.getScene( "views.page0"..(curPage+1).."Scene") then composer.removeScene( "views.page0"..(curPage+1).."Scene", true) end
            if(_K.kBidi == false) then
              composer.gotoScene( "views.page0"..(curPage+1).."Scene", { effect = "fromRight"} )
            else
              composer.gotoScene( "views.page0"..(curPage-1).."Scene", { effect = "fromLeft"} )
            end
         end
       end
       if (UI.allAudios.kAutoPlay > _K.kAutoPlay*1000) then
           _K.timerStash.timer_AP = timer.performWithDelay(
             UI.allAudios.kAutoPlay + _Delay, act_autoPlay, 1 )
       else
           _K.timerStash.timer_AP = timer.performWithDelay( _K.kAutoPlay*1000, act_autoPlay, 1 )
       end
     end

    if self.preload then
       -- Preloads next scene. Must be off to use page curl
      if not _K.exportCurrent then
       _K.timerStash.timer_pl = timer.performWithDelay( 5000, function()
          composer.loadScene( "views.page0{{nextScene}}Scene")
       end)
       end
    end

end
--
function _M:toDispose()
  _K.test = nil
  _K.cancelAllTimers();
end

function _M:willHide()
end

--
function _M:localVars()
end
--
return _M