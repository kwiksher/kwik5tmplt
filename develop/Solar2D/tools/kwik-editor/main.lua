require("controller.index").start("core", 1)

--[[

local App = require "Application"

local function bootstrap()
	App.appName     = ""
	App.imgDir      = "assets/images/"
	App.spriteDir   = "assets/sprites/"
	App.thumbDir    = "assets/thumbnails/"
	App.audioDir    = "assets/audios/"
	App.videoDir    = "assets/videos/"
	App.particleDir = "assets/particles/"
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
	App.scenes       = require("scenes.index")
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
local function onError(e)
    print("--- unhandledError ---")
    print(e)
    return true
end
--
Runtime:addEventListener("unhandledError", onError)
--
bootstrap()

--]]

-------------------------------------------------
-- build.settings neverStripDebugInfo
-------------------------------------------------
--[[
local log = require("extlib.log")
local path = system.pathForFile("log.db", system.DocumentsDirectory)
db = sqlite3.open(path)
log:set(db, "support@kwiksher.com")
]]
