-- Template Version 2020.0018
-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
system.activate("multitouch")
display.setDefault("background", 1,1,1)
display.setStatusBar(display.HiddenStatusBar)

local function startThisMug()
	local _K = require "Application"
	local function bootstrap()
		--
		--
		_K.goPage      = {{curPage}}
		_K.lang        ="{{use.lang}}"
		_K.kAutoPlay   = 0
		_K.appInstance = _K:new("{{appName}}")
		--
		--
		if "tvOS" == system.getInfo("platform") then
			system.setIdleTimer( false )
			_K.DocumentsDir = system.CachesDirectory
		  end	  
	end
	--
	bootstrap()
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
-- there are events dispached in Application:new to init the modules, no deffered & promises so just watit for 100 ms
--
timer.performWithDelay(100, startThisMug)
--
-------------------------------------------------
-- build.settings neverStripDebugInfo
-------------------------------------------------
--[[
local log = require("extlib.log")
local path = system.pathForFile("log.db", system.DocumentsDirectory)
db = sqlite3.open(path)
log:set(db, "support@kwiksher.com")
]]

d = {}
d.print = function(num)
	local _num = num or 1
	-- for k, v in pairs(debug.getinfo(1)) do print(k, v) end
	local t = debug.getinfo(2)
	print( t.short_src..":("..t.currentline..")", t.name)
end

d.printT = function()
	print(debug.traceback(""))
end
