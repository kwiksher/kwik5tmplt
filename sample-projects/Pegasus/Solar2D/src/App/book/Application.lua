-- Code created by Kwik - Copyright: kwiksher.com 2016, 2017, 2018
-- Version: 4.3.1
-- Project: Canvas
--
local dir = ...
local parent = dir:match("(.-)[^%.]+$")

require("extlib.index")
require("extlib.Deferred")
require("extlib.Callbacks")
local AppContext = require(parent.."contexts.ApplicationContext")
local composer = require("composer")
------------------------------------------------------
------------------------------------------------------
local Application = {}
--
function Application.new()
    local app = display.newGroup()
    app.classType = "Application"
    app.currentView = nil
    app.currentViewName = nil
    --
    function app:init()
        self.context = AppContext.new()
        self.context:init(Application.scenes)
        self.startSceneName = "scenes." .. Application.scenes[Application.goPage]..".index"
        --
        Runtime:dispatchEvent({name = "app.variables", event = "init"})
        Runtime:dispatchEvent({name = "app.loadLib", event = "init"})
        Runtime:dispatchEvent({name = "app.statsuBar", event = "init"})
        Runtime:dispatchEvent({name = "app.versionCheck", event = "init"})
        Runtime:dispatchEvent({name = "app.expDir", event = "init"})
        Runtime:dispatchEvent({name = "app.lang", event = "init"})
        Runtime:dispatchEvent({name = "app.droidHWKey", event = "init"})
        Runtime:dispatchEvent({name = "app.kwkVar", event = "init"})
        Runtime:dispatchEvent({
            name = "app.bookmark",
            event = "init",
            bookmark = false
        })
        -- ApplicationMediator.onRegister shows the top page
        Runtime:dispatchEvent({name = "onRobotlegsViewCreated", target = self}) -- this sets mediator's viewInstance
    end
    --
    function app:orientation(event) end
    --
    function app:whichViewToShowBasedOnOrientation()
        local t = self.lastKnownOrientation
        if t == "landscapeLeft" or t == "landscapeRight" then
        else
        end
    end
    --
    function app:showView(name, params)
        print("Application::name:", name, ", currentViewName:",
              self.currentViewName)
        if name == self.currentViewName then
            print("same scene")
            -- return true
        end
        self.currentViewName = parent..name
        composer.gotoScene(parent..name, {params = params})
    end
    --
    function app:trigger(url, params)
        self.currentViewName = self.context.Router[url]
        if self.currentViewName == nil then
            print("### error " .. url .. " not routed ###")
        else
            composer.gotoScene(self.currentViewName, params)
        end
    end
    --
    app:init()
    --
    return app
end
--
function Application.cancelAllTweens()
    local k, v
    for k, v in pairs(Application.gt) do
        v:pause();
        v = nil;
        k = nil
    end
    Application.gt = nil
    Application.gt = {}
end
--
function Application.cancelAllTimers()
    local k, v
    for k, v in pairs(Application.timerStash) do
        timer.cancel(v)
        v = nil;
        k = nil
    end
    Application.timerStash = nil
    Application.timerStash = {}
end
--
function Application.cancelAllTransitions()
    local k, v
    for k, v in pairs(Application.trans) do
        transition.cancel(v)
        v = nil;
        k = nil
    end
    Application.trans = nil
    Application.trans = {}
end
--
function Application.getPosition(x, y)
    local mX = x and display.contentWidth / 2 + (x * 0.25 - 480 * 0.5) or 0
    local mY = y and display.contentHeight / 2 + (y * 0.25 - 320 * 0.5) or 0
    return mX, mY
end

function Application.parseValue (value, newValue)
	if newValue then
		if value then
			return newValue
		else
			return nil
		end
	else
		return value
	end
end
---



--

-- function Application.createCommand(scene, model)
-- 	local cmd = require("commands.kwik.actionCommand")
--     local Command = cmd.new()
-- 	--
-- 	function Command:execute(params)
-- 		self:_execute(params)
-- 	end
-- 	return Command
-- end

--
return Application
