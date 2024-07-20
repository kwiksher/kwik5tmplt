system.activate("multitouch")

local trialCnt    = 1 -- set 0 for production

-- Create library
local lib = {}
-----------------------------------------------
local App = require("controller.Application")
package.loaded["Application"] = App

local common = {commands = {"myEvent"}, components = {"keyboardNavigation", "bookstoreNavigation"}}

function lib.bootstrap(Props)
    local app = App.new{
        appName     = Props.name,
        systemDir   = system.ResourceDirectory,
        imgDir      = "App/"..Props.name.."/assets/images/",
        spriteDir   = "App/"..Props.name.."/assets/sprites/",
        thumbDir    = "App/"..Props.name.."/assets/thumbnails/",
        audioDir    = "App/"..Props.name.."/assets/audios/",
        videoDir    = "App/"..Props.name.."/assets/videos/",
        particleDir = "App/"..Props.name.."/assets/particles/",
        trans       = {},
        gt          = {},
        timerStash  = {},
        allAudios   = {kAutoPlay = 5},
        kBidi       = false,
        goPage      = Props.goPage, -- sceneIndex,
        scenes       = require("App."..Props.name..".index"),
        kAutoPlay   = 0,
        lang        = "en",
        position    = Props.position,
        --stage       = display.getCurrentStage(),
        randomAction = {},
        randomAnim   = {},
        DocumentsDir = system.DocumentsDirectory,
        common       = Props.common
    }
    App.gtween      = require("extlib.gtween")
    App.btween      = require("extlib.btween")
    App.Gesture     = require("extlib.dmc_gesture")
    App.MultiTouch  = require("extlib.dmc_multitouch")
    App.syncSound   = require("extlib.syncSound")
    App.currentName = Props.name
    app:init()
    common = Props.common or common

--
end

--
local function onError(e)
    print("--- unhandledError ---")
    print(e)
    return true
end
--
Runtime:addEventListener("unhandledError", onError)
--timer.performWithDelay(100, startThisMug)
--
local composer = require("composer")

local function resetPacakges()
     package.loaded["extlib.syncSound"] = nil
     package.loaded["extlib.kNavi"] = nil
     package.loaded["commands.kwik.pageAction"] = nil
     package.loaded["commands.kwik.animationAction"] = nil
     package.loaded["commands.kwik.actionCommand"] = nil
     package.loaded["commands.kwik.languageAction"] = nil
     -- bookstore UI
     -- this has a reference to App.TOC or bookXX, so need to unload it?
     package.loaded["components.bookstore.controller.pageCommand"] = nil
     package.loaded["editor.bookstore.controller.pageCommand"] = nil

end


Runtime:addEventListener("changeThisMug", function(event)
  print("---------- changeThisMug -------------")
  local app = App.get()
  print (event.appName, event.page, app.props.appName, app.currentViewName)
  --local goPage = "components." .. app.props.scenes[self.props.goPage]..".index"
  if event.appName == app.props.appName and event.page == app.props.goPage then
    print("not changeThisMug")
  else
    composer.gotoScene("components.bookstore.view.page_cutscene")
    composer.removeHidden(false)
    resetPacakges()
    lib.bootstrap({name=event.appName, sceneIndex = event.page or 1, position = {x=0, y=0}, common=common}) -- scenes.index
  end
end)
-- Return library instance
return lib
