-- Code created by Kwik - Copyright: kwiksher.com 2016, 2017, 2018
-- Version: 4.3.1
-- Project: Canvas
--
local dir = ...
local parent = dir:match("(.-)[^%.]+$")

require("extlib.index")
require("extlib.Deferred")
require("extlib.Callbacks")
local AppContext = require("controller.ApplicationContext")
local composer = require("composer")
------------------------------------------------------
------------------------------------------------------
local M = {apps = {}}
--
function M:orientation(event) end
--
function M:whichViewToShowBasedOnOrientation()
    local t = self.lastKnownOrientation
    if t == "landscapeLeft" or t == "landscapeRight" then
    else
    end
end
--
function M:cancelAllTweens()
    local k, v
    for k, v in pairs(self.gt) do
        v:pause();
        v = nil;
        k = nil
    end
    self.gt = nil
    self.gt = {}
end
--
function M:cancelAllTimers()
    local k, v
    for k, v in pairs(self.timerStash) do
        timer.cancel(v)
        v = nil;
        k = nil
    end
    self.timerStash = nil
    self.timerStash = {}
end
--
function M:cancelAllTransitions()
    local k, v
    for k, v in pairs(self.trans) do
        transition.cancel(v)
        v = nil;
        k = nil
    end
    self.trans = nil
    self.trans = {}
end
--
function M.getPosition(x, y)
    local mX = x and display.contentWidth / 2 + (x * 0.25 - 480 * 0.5) or 0
    local mY = y and display.contentHeight / 2 + (y * 0.25 - 320 * 0.5) or 0
    return mX, mY
end

function M.parseValue (value, newValue)
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

function M.get(index)
  return M.apps[index]
end

function M.new(Props)
    local app = display.newGroup()
    app.classType = "App."..Props.appName..".scenes.index"
    app.currentView = nil
    app.currentViewName = nil
    app.props = Props
    M.apps[#M.apps+1] = app

--
    function app:showView(viewName, _options)
        print("showView", viewName, ", currentViewName:", self.currentViewName)
        self.currentViewName = viewName
        local scene = self.context.Router[viewName]
        local options = _options or {}
        options.params = options.params or {}
        options.params.sceneProps = {app =scene.app, classType = scene.classType, UI = scene.UI, model=scene.model, getEvents = scene.getEvents}
        composer.gotoScene("App."..self.props.appName.."."..viewName, options)
    end
    --
    function app:trigger(viewName, params)
        if viewName == self.currentViewName then
            print("same scene")
            return true
        end
        self.currentViewName = viewName
        print("trigger", viewName)
        local scene = self.context.Router[viewName]
        scene:dispatchEvent({name="init"})
        scene:dispatchEvent({name="create"})
        scene:dispatchEvent({name="show", phase = "will"})
        scene:dispatchEvent({name="show", phase = "did"})
        scene:dispatchEvent({name="transition", params = self.props.position})
    end

    function app:init()
        -- app:addEventListener("onRobotlegsViewCreated", function(e) print("test") end)
        self.context = AppContext.new(self)
        self.context:init(app.props.scenes, app.props)

        self.startSceneName = "scenes." .. self.props.scenes[self.props.goPage]..".index"
        --
        self:dispatchEvent({name = "app.variables", event = "init"})
        self:dispatchEvent({name = "app.loadLib", event = "init"})
        self:dispatchEvent({name = "app.statsuBar", event = "init"})
        self:dispatchEvent({name = "app.versionCheck", event = "init"})
        self:dispatchEvent({name = "app.expDir", event = "init"})
        self:dispatchEvent({name = "app.lang", event = "init"})
        self:dispatchEvent({name = "app.droidHWKey", event = "init"})
        self:dispatchEvent({name = "app.kwkVar", event = "init", appProps = self.props})
        self:dispatchEvent({
            name = "app.bookmark",
            event = "init",
            bookmark = false,
            appProps = self.props
        })
        --
        -- ApplicationMediator.onRegister shows the top page
        --
        self.useTrigger = false -- true app:trigger, false:app:showView (composer.gotoScene)
        self:dispatchEvent({name = "onRobotlegsViewCreated", target = self}) -- self == app, this sets mediator's viewInstance as app
    end

    return app
end
--
return M
