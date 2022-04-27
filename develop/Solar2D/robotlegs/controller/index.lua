system.activate("multitouch")

local trialCnt    = 1 -- set 0 for production
local kprint = function(a, b)
    print(a, b)
end

-- Create library
local lib = {}

-----------------------------------------------
local App = require("controller.Application")

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
        gtween      = require("extlib.gtween"),
        btween      = require("extlib.btween"),
        Gesture     = require("extlib.dmc_gesture"),
        MultiTouch  = require("extlib.dmc_multitouch"),
        syncSound   = require("extlib.syncSound"),
        kBidi       = false,
        goPage      = Props.sceneIndex,
        scenes       = require("App."..Props.name..".scenes.index"),
        kAutoPlay   = 0,
        lang        = "en",
        position    = Props.position,
        --stage       = display.getCurrentStage(),
        randomAction = {},
        randomAnim   = {},
        DocumentsDir = system.DocumentsDirectory
    }
    --app:init()
--
end

--
local function onError(e)
    kprint("--- unhandledError ---")
    kprint(e)
    return true
end
--
Runtime:addEventListener("unhandledError", onError)
--timer.performWithDelay(100, startThisMug)
--
local composer = require("composer")

Runtime:addEventListener("changeThisMug",
    function(e)
       composer.gotoScene("extlib.page_cutscene")
       composer.removeHidden(false)
        _G.appInstance:destroy()
        local function resetPacakges()
            package.loaded["model"] = nil
            for i=1, _G.pageNum do
                package.loaded["contexts.page0"..i.."Context"] = nil
                myunload(".contexts.page0%sContext",i)
            end
            package.loaded["contexts.ApplicationContext"]      = nil
            package.loaded["KwikShelf.contexts.ApplicationContext"] = nil
            package.loaded["Application"]                      = nil
            package.loaded["KwikShelf.Application"] = nil
            for i=1, _G.pageNum do
                package.loaded["mediators.page0"..i.."Mediator"] = nil
                myunload(".mediators.page0%sMediator",i)
                package.loaded["vo.page0"..i.."VO"]               = nil
                myunload(".vo.page0%sVO",i)
                package.loaded["components.page0"..i.."UI"]       = nil
                myunload(".components.page0%sUI",i)
                package.loaded["views.page0"..i.."Scene"]         = nil
                myunload(".views.page0%sScene",i)
            end
            package.loaded["mediators.ApplicationMediator"] = nil
            package.loaded["KwikShelf.mediators.ApplicationMediator"] = nil
            package.loaded["components.kwik.layerUI"] = nil
            package.loaded["extlib.syncSound"] = nil
            package.loaded["extlib.kNavi"] = nil
            package.loaded["commands.kwik.pageAction"] = nil
            package.loaded["commands.kwik.animationAction"] = nil
            package.loaded["commands.kwik.actionCommand"] = nil
            package.loaded["commands.kwik.languageAction"] = nil
            -- store UI
            -- this has a reference to App.TOC or bookXX, so need to unload it
            package.loaded["components.store.UI"] = nil



            --package.loaded["extlib.statemap"] = nil
           -- for k, v in pairs(package.loaded) do kprint(string.format("[%50s]", k), v) end
            -- now let's change the app
            _G.appName = e.appName
            if e.page then
                _G.goPage  = e.page
            else
                 _G.goPage = 1
            end
        end
        timer.performWithDelay(loadingTime, function()
            resetPacakges()
            startThisMug()
            end)
    end)

-- Return library instance
return lib
