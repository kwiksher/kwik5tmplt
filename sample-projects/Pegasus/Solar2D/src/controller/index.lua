system.activate("multitouch")

local trialCnt    = 1 -- set 0 for production
local kprint = function(a, b)
    print(a, b)
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
    --
    timer.performWithDelay(loadingTime, startThisMug)
end
-----------------------------------------------
--[[

    local function myrequire(name, i)
        local M = require("App.".._G.appName..string.format(name, i))
        M.appName = "App.".._G.appName.."."
        return M
    end

    local function myunload(name, i)
        kprint("App.".._G.appName..string.format(name, i))
        package.loaded["App.".._G.appName..string.format(name, i)] = nil
    end
--]]

local composer = require("composer")
-----------------------------------------------
startThisMug = function()
    if master.isEmbedded then
        kprint("############## startThisMg ##############", _G.appName)
        --[[
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
        --]]
    end
    ---
    local App = require("App.".._G.appName..".Application")
    local appDir   = "App/".._G.appName.."/"
    _G.App = App
    package.loaded["Application"] = App
    package.loaded["contexts.mediator"] = require("App.".._G.appName..".contexts.mediator")
    package.loaded["contexts.ApplicationUI"] = require("App.".._G.appName..".contexts.ApplicationUI")
    package.loaded["contexts.scene"] = require("App.".._G.appName..".contexts.scene")


    local function bootstrap()
        App.appName     = ""
        App.systemDir   = system.ResourceDirectory
        App.imgDir      = "App/".._G.appName.."/assets/images/"
        App.spriteDir   = "App/".._G.appName.."/assets/sprites/"
        App.thumbDir    = "App/".._G.appName.."/assets/thumbnails/"
        App.audioDir    = "App/".._G.appName.."/assets/audios/"
        App.videoDir    = "App/".._G.appName.."/assets/videos/"
        App.particleDir = "App/".._G.appName.."/assets/particles/"
        App.trans       = {}
        App.gt          = {}
        App.timerStash  = {}
        App.allAudios   = {kAutoPlay = 5}
        App.gtween      = require("extlib.gtween")
        App.btween      = require("extlib.btween")
        App.Gesture     = require("extlib.dmc_gesture")
        App.MultiTouch  = require("extlib.dmc_multitouch")
        App.syncSound   = require("extlib.syncSound")
        App.kBidi       = false
        App.goPage      = 1
        App.scenes       = require("App.".._G.appName..".scenes.index")
        App.kAutoPlay   = 0
        App.lang        = "en"
    -- App.stage       = display.getCurrentStage()
        system.activate("multitouch")
        App.randomAction = {}
        App.randomAnim   = {}
        App.DocumentsDir = system.DocumentsDirectory
    --
        App.appInstance  = App.new()
    end
    --
    bootstrap()
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
