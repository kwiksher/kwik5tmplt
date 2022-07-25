--
local _M = {}

local _K = require("Application")
local composer = require("composer")
local _Delay = 0 -- Kwik3 was 1000

local props = {
  xScale = nil,
  yScale = nil,
  alpha = nil,
  bookmark = tonumber(_K.kBookmark) == 1,
  autoplay = tonumber(_K.kAutoPlay) > 0
}

--
function _M:init(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  -- Page properties
  if props.xScale then
    sceneGroup.xScale =  props.xScale
    sceneGroup.yScale =  props.yScale
    sceneGroup.alpha = props.alpha
  end
end
--
function _M:create(UI)
  local sceneGroup = UI.scene.view
end
--
function _M:didShow(UI)
  local sceneGroup = UI.scene.view
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
     if props.bookmark  then
        local path = system.pathForFile(_K.appName.. "book.txt", _K.DocumentsDir )
        local file = io.open( path, "w+" )
        file:write ( curPage.."\n1" )
        io.close( file )
     end

      -- Check for for auto play settings
     if props.autoplay then
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

    if propps.preload then
       -- Preloads next scene. Must be off to use page curl
       if not _K.exportCurrent then
         _K.timerStash.timer_pl = timer.performWithDelay( 5000, function()
           composer.loadScene( "views.page0{{nextScene}}Scene")
           end)
       end
     end
end
--
function _M:didHide(UI)
  local sceneGroup = UI.scene.view
--
function  _M:destory()
end
--
return _M
