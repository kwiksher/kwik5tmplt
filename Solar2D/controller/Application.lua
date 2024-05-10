-- Code created by Kwik - Copyright: kwiksher.com 2016, 2017, 2018
-- Version: 4.3.1
-- Project: Canvas
--
local dir = ...
local parent = dir:match("(.-)[^%.]+$")

require("extlib.index")
require("extlib.Deferred")
require("extlib.Callbacks")

string.split = function(str, sep)
  local out = {}
  for m in string.gmatch(str, "[^" .. sep .. "]+") do
    out[#out + 1] = m
  end
  return out
end

local function newInstance(M, props, _layerProps)
  -- print(props.name)
  local instance = {}
  if props.name then
    instance.name = props.name
  end
  --
  -- if props.parent then
  --   if props.layerProps then
  --     instance.layerProps = props.layerProps
  --     instance.layerProps.name =  props.parent..".".._layerProps.name
  --   else
  --     instance.layerProps = {name = props.parent..".".._layerProps.name}
  --   end
  -- else
    if props.layerProps then
      instance.layerProps = props.layerProps
    -- elseif props.name then
    else
      instance.layerProps = {name = props.name}
    end
  -- end
  --
  -- print("$$$$$$$$$$$$$$$$")
  for k, v in pairs(_layerProps) do
    if instance.layerProps[k] == nil then
      -- print(k, v)
      instance.layerProps[k] = v
    end
  end
  return setmetatable(instance, {__index = M})
end

function newModule(name)
  local M = {}
  local parent = name:match("(.-)[^%.]+$")
  local root = parent:sub(1, parent:len()-1):match("(.-)[^%.]+$")
  M.name = name:sub(root:len()+1)
  local isLayers = M.name:find("layers.")
  if isLayers then
    M.name = M.name:sub(8)
  end
  M.newInstance = newInstance
  return parent, root, M
end

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
    local mX = x and (x * 0.25 - 480 * 0.5) or 0
    local mY = y and (y * 0.25 - 320 * 0.5) or 0
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

function M.getByName(name)
  for i=1, #M.apps do
    if M.apps[i].props.appName ==  name then
      return M.apps[i]
    end
  end
  return nil
end

function M.get(index)
  if index then
      return M.apps[index]
  else
    return M.getByName(M.currentName)
  end
end

function M.getProps()
  return M.getByName(M.currentName).props
end

function M.new(Props)
    local app = display.newGroup()
    app.classType = "App."..Props.appName..".index"
    app.currentView = nil
    app.currentViewName = nil
    app.props = Props
    app.name = Props.appName
    M.apps[#M.apps+1] = app

--
    function app:showView(viewName, _options)
        -- print(debug.traceback())
        print("-------------- showView ------------------", self.props.appName.."."..viewName, ", currentViewName:", self.currentViewName)
        self.currentViewName = viewName
        local scene = self.context.Router[viewName]
        if scene == ni then
          print("ERROR showView ", viewName )
          for k, v in pairs(self.context.Router) do print("", k) end
          return
        end
        -- scene.app.currentViewName = viewName
        local options = _options or {}
        options.params = options.params or {time=0}
        scene.UI.page = scene.model.page
        scene.UI.book = app.name
        options.params.sceneProps = {app =scene.app, classType = scene.classType, UI = scene.UI, model=scene.model, getCommands = scene.getCommands}
        composer.gotoScene("App."..self.props.appName.."."..viewName, options)
    end
    --
    function app:showOverlay(viewName, _options)
      print("showView", viewName, ", currentViewName:", self.currentViewName)
      self.currentViewName = viewName
      local scene = self.context.Router[viewName]
      local options = _options or {}
      options.params = options.params or {}
      options.params.sceneProps = {app =scene.app, classType = scene.classType, UI = scene.UI, model=scene.model, getCommands = scene.getCommands}
      composer.showOverlay("App."..self.props.appName.."."..viewName, options)
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
        scene.UI.page = scene.model.page
        -- if scene.view == nil then
          scene:dispatchEvent({name="init"})
          scene:dispatchEvent({name="create"})
        -- end
        scene:dispatchEvent({name="show", phase = "will"})
        scene:dispatchEvent({name="show", phase = "did"})
        scene:dispatchEvent({name="transition", params = self.props.position})
    end

    function app:init()
        -- app:addEventListener("onRobotlegsViewCreated", function(e) print("test") end)
        self.context = AppContext.new(self)
        self.context:init(app.props.scenes, app.props)

        if #self.props.scenes > 0 then
          self.startSceneName = "components." .. self.props.scenes[self.props.goPage]..".index"
          --
          self:dispatchEvent({name = "app.statsuBar", event = "init"})
          self:dispatchEvent({name = "app.droidHWKey", event = "init"})
          self:dispatchEvent({name = "app.memoryCheck", event = "init"})
          self:dispatchEvent({name = "app.statusBar", event = "init"})
          self:dispatchEvent({name = "app.suspend", event = "init"})
          --
          -- ApplicationMediator.onRegister shows the top page
          --
          self.useTrigger = false -- true app:trigger, false:app:showView (composer.gotoScene)
          self:dispatchEvent({name = "onRobotlegsViewCreated", target = self}) -- self == app, this sets mediator's viewInstance as app
        end
    end

    return app
end
--
return M
