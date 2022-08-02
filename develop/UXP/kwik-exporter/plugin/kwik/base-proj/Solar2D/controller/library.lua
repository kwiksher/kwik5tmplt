system.activate("multitouch")

local trialCnt    = 1 -- set 0 for production
local kprint = function(a, b)
    --print(a, b)
end

-- Create library
local lib = {}

_G  = {}
local master   = {isEmbedded = true}
local startThisMug
local loadingTime = 500
--
lib.start = function(appName, goPage, time)
    loadingTime = time or 500
    _G.appName = appName
    _G.goPage  = goPage
    _G.appInstance= nil

    timer.performWithDelay(100, startThisMug)
end
-----------------------------------------------
local function myrequire(name, i)
    local M = require("App.".._G.appName..string.format(name, i))
    M.appName = "App.".._G.appName.."."
    return M
end

local function myunload(name, i)
    kprint("App.".._G.appName..string.format(name, i))
    package.loaded["App.".._G.appName..string.format(name, i)] = nil
end

local composer = require("composer")
-----------------------------------------------
startThisMug = function()
    if master.isEmbedded then
        kprint("############## startThisMg ##############", _G.appName)
        local model = require("App.".._G.appName..".model")
        --------------------------------
        -- package.loaded["components.kwik.layerUI"] = require("KwikShelf.components.kwik.layerUI")
        _G.pageNum = model.pageNum
        kprint("## PageNum ", _G.pageNum)
        for i=1, model.pageNum do
            package.loaded["contexts.page0"..i.."Context"] = myrequire(".contexts.page0%sContext",i)
        end
        package.loaded["contexts.ApplicationContext"]      = require("KwikShelf.contexts.ApplicationContext")
        package.loaded["Application"]                      = require("KwikShelf.Application")
        for i=1, model.pageNum do
            package.loaded["mediators.page0"..i.."Mediator"] = myrequire(".mediators.page0%sMediator",i)
            package.loaded["vo.page0"..i.."VO"]               = myrequire(".vo.page0%sVO",i)
            package.loaded["components.page0"..i.."UI"]       = myrequire(".components.page0%sUI",i)
            package.loaded["views.page0"..i.."Scene"]         = myrequire(".views.page0%sScene",i)
        end
        package.loaded["mediators.ApplicationMediator"] = require("KwikShelf.mediators.ApplicationMediator")
        package.loaded["model"] = require("KwikShelf.model")

    end
    ---
    local function bootstrap(appName)
        kprint("bootstrap for "..appName)
        local _K       = require ("App."..appName..".Application")
        local appDir   = "App/"..appName.."/"
        _K.appName     = appName
        _K.appDir      = "App."..appName.."."
        _K.imgDir      = appDir.."assets/images/"
        _K.spriteDir   = appDir.."assets/sprites/"
        _K.thumbDir    = appDir.."assets/thumbnails/"
        _K.audioDir    = appDir.."assets/audios/"
        _K.videoDir    = appDir.."assets/videos/"
        _K.particleDir = appDir.."assets/particles/"
        _K.systemDir   = system.ResourceDirectory
        if master.isEmbedded then
            local model = require("App."..appName..".model")
            for k, v in pairs (model) do kprint(k, v) end
            if model.isDownloadable then
                kprint("######### dwonloadable #########")
                    _K.systemDir = system.ApplicationSupportDirectory
                    _K.imgDir      = appName.."/images/"
                    _K.spriteDir   = appName.."/sprites/"
                    _K.thumbDir    = appName.."/thumbnails/"
                    _K.audioDir    = appName.."/audios/"
                    _K.videoDir    = appName.."/videos/"
                    _K.particleDir = appName.."/particles/"
            end
        end
         _K.trans       = {}
        _K.gt          = {}
        _K.timerStash  = {}
        _K.allAudios   = {kAutoPlay = 5}
        _K.gtween      = require("extlib.gtween")
        _K.btween      = require("extlib.btween")
        _K.Gesture     = require("extlib.dmc_gesture")
        _K.MultiTouch  = require("extlib.dmc_multitouch")
        _K.syncSound   = require("extlib.syncSound")
        _K.kBidi       = false
        _K.goPage      = _G.goPage
        _K.kAutoPlay   = 0
        _K.lang        = require("App.TOC.Application").lang or ""
        -- _K.stage       = display.getCurrentStage()
        _K.randomAction = {}
        _K.randomAnim   = {}
        _K.kwikDir      = ""
        _K.asmModel     = {}
        _K.muteVideos  = {}
        _K.appInstance  = _K:new(_K.appDir)
        _G.appInstance = _K.appInstance
      --  _K.appInstance:init()
    end
    --
    bootstrap(_G.appName)
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
