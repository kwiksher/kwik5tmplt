-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
require("extlib.Deferred")
require("extlib.Callbacks")
_W = display.contentWidth
_H = display.contentHeight


function requireKwik(mod)
    if _G and _G.appName then
        return require("App.".._G.appName.."."..mod)
    else
        return require(mod)
    end
end

local AppContext  = require("contexts.ApplicationContext")
local composer = require("composer")
------------------------------------------------------
------------------------------------------------------
local Application = {
	{{#use.expDir}}
	imgDir      = "assets/images/",
	spriteDir   = "assets/sprites/",
	thumbDir    = "assets/thumbnails/",
	audioDir    =  "assets/audios/",
	videoDir    =  "assets/videos/",
	{{/use.expDir}}
	{{^use.expDir}}
	imgDir      = "assets/",
	spriteDir   = "assets/",
	audioDir    =  "assets/",
	videoDir    =  "assets/",
	thumbDir    = "assets/thumbnails/",
	{{/use.expDir}}
	particleDir = "assets/particles/",
	systemDir   = system.ResourceDirectory,
	trans       = {},
	gt          = {},
	timerStash   = {},
	allAudios    = {kAutoPlay = 5},
	gtween      = require("extlib.gtween"),
	btween      = require("extlib.btween"),
	Gesture     = require("extlib.dmc_gesture"),
	MultiTouch  = require("extlib.dmc_multitouch"),
	syncSound   = require("extlib.syncSound"),
	kBidi       = false,
	layer      = {},
	-- _K.stage       = display.getCurrentStage(),
	randomAction  = {},
	randomAnim  = {},
	kwikDir      = "{{kwikDir}}",
	DocumentsDir = system.DocumentsDirectory,
	asmModel = {
	  sandboxPath = system.pathForFile( nil, system.DocumentsDirectory ),
	  projPath    = _K.kwikDir,
	  APNG        = {},
	  AGIF        = {}
	},
	muteVideos = {},
	states     = {},
	numOfPages = {{numOfPages}}
}

-- Calculates anchor points
Application.repositionAnchor = function( object, newAnchorX, newAnchorY )
     local origX = object.x; local origY = object.y
     if object.repositionDone == nil then
	     	object.repositionDone = true;
	     if newAnchorX ~= 0.5 or newAnchorY ~= 0.5 then
	         local width = object.width; local height = object.height
	         local xCoord = width * (newAnchorX - .5)
	         local yCoord = height * (newAnchorY - .5)
	         object.x = origX + xCoord; object.y = origY + yCoord
	         object.oriX = object.x; object.oriY = object.y
	     end
	   end
end

--
function Application:new(appName)
	local application = display.newGroup()
	application.classType       = "Application"
	application.currentView     = nil
	application.currentViewName = nil
	application.appDir          = appName
	self.appName                = appName,
	self.appDir                 = appName,

	--
	function application:init()
		local options = {
			numOfPages = self.numOfPages
		}
		{{if(options.use.lang)}}
			options.lang = true
		{{/if}}
		self.context = AppContext:new(options)
		self.context:init()
		--
    Runtime:dispatchEvent({name="app.variables", event="init"})
		--
    Runtime:dispatchEvent({name="app.loadLib", event="init"})
		--
    Runtime:dispatchEvent({name="app.statsuBar", event="init"})
		{{if(options.use.coronaViewer)}}
		-- please disable for commercial release --
    Runtime:dispatchEvent({name="app.coronaViewer", event="init"})
		{{/if}}
		--
		{{if(options.use.ads)}}
    Runtime:dispatchEvent({name="app.Ads", event="init"})
		{{/if}}
		--
    Runtime:dispatchEvent({name="app.versionCheck", event="init"})
		--
    Runtime:dispatchEvent({name="app.expDir", event="init"})
		--
		{{if(options.use.lang)}}
	  Runtime:dispatchEvent({name="app.lang", event="init"})
		{{/if}}
		--
	  Runtime:dispatchEvent({name="app.droidHWKey", event="init"})
		--
	  Runtime:dispatchEvent({name="app.kwkVar", event="init"})
		--
	  Runtime:dispatchEvent({name="app.bookmark", event="init", bookmark ={{use.bookmark}} })
		--
		{{if(options.use.suspend)}}
	  Runtime:dispatchEvent({name="app.suspend", event="init"})
		{{/if}}
		--
		{{if(options.use.memoryTrack)}}
	  Runtime:dispatchEvent({name="app.memoryCheck", event="init"})
		{{/if}}

		{{if(options.use.extCode)}}--
	  Runtime:dispatchEvent({name="app.extCodes", event="init"})
		{{/if}}		--
		-- ApplicationMediator.onRegister shows the top page
		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})
	end
	--
	function application:orientation(event)
	end
	--
	function application:whichViewToShowBasedOnOrientation()
		local t = self.lastKnownOrientation
		if t == "landscapeLeft" or t == "landscapeRight" then
		else
		end
	end
	--
	function application:showView(name, params)
		print("Application::name:", name, ", currentViewName:", self.currentViewName)
		if name == self.currentViewName then
			print("same scene")
			-- return true
		end
		self.currentViewName = name
        composer.gotoScene(self.appDir..name, {params = params})
    end
    --
    function application:destroy()
        self.context:destroy()
    end
    	--
	function application:trigger(url, params)
		self.currentViewName = self.context.Router[url]
		if self.currentViewName == nil then
			print("### error "..url.." not routed ###")
		else
			composer.gotoScene(self.currentViewName, params)
		end
	end
	--
	application:init()
	--
	return application
end
	--
function Application.cancelAllTweens()
    local k, v
    for k,v in pairs(Application.gt) do
        v:pause();
        v = nil; k = nil
    end
    Application.gt = nil
    Application.gt = {}
end
--
function Application.cancelAllTimers()
    local k, v
    for k,v in pairs(Application.timerStash) do
        timer.cancel( v )
        v = nil; k = nil
    end
    Application.timerStash = nil
    Application.timerStash = {}
end
--
function Application.cancelAllTransitions()
    local k, v
    for k,v in pairs(Application.trans) do
        transition.cancel( v )
        v = nil; k = nil
    end
    Application.trans = nil
    Application.trans = {}
end
--
function Application.ultimatePosition(x,y, align)
{{if(options.ultimate)}}
	{{if(options.use.landscape)}}
	local w, h = 480, 320
	local mX = x and display.contentWidth/2 + (x*0.25 - w*0.5) or 0
	local mY = y and display.contentHeight/2 + (y*0.25 - h*0.5) or 0
    {{/if}}
	{{if(options.use.portrait)}}
	local w, h = 320, 480
	local mX = x and display.contentWidth/2 + (x*0.25 - w*0.5) or 0
	local mY = y and display.contentHeight/2 + (y*0.25 - h*0.5) or 0
	{{/if}}
	if align == "left" then
        mX = mX - (display.safeActualContentWidth - w)/2 
    elseif align == "right" then
        mX = mX + (display.safeActualContentWidth - w)/2 
    elseif align == "top" then
        mY = mY - (display.safeActualContentHeight - h)/2
    elseif align == "bottom" then
        mY = mY + (display.safeActualContentHeight - h)/2 
    elseif align == "topLeft" then
        mX = mX - (display.safeActualContentWidth - w)/2 
        mY = mY - (display.safeActualContentHeight - h)/2 
    elseif align == "topRight" then
        mX = mX + (display.safeActualContentWidth - w)/2 
        mY = mY - (display.safeActualContentHeight - h)/2 
    elseif align == "bottomLeft" then
        mX = mX - (display.safeActualContentWidth - w)/2 
        mY = mY + (display.safeActualContentHeight - h)/2 
    elseif align == "bottomRight" then
        mX = mX + (display.safeActualContentWidth - w)/2 
        mY = mY + (display.safeActualContentHeight - h)/2 
    end
	return mX, mY
{{#else}}
		return x, y
{{/if}}
end
--
function Application.isUltimateConfig()
	{{if(options.ultimate)}}
	return true
	{{#else}}
	return false
	{{/if}}
end

function Application.activateState(obj, setter)
	obj.setter = function(event)
		local model = event.model
		setter(obj, model)
	end
	Runtime:addEeventListener("state_"..obj.name, obj.setter)
end

function Application.deactivateState(obj)
	if obj.setter then
		Runtime:removeEeventListener("state_"..obj.name, obj.setter)
		obj.setter = nil
	end
end

function Application.bindState(group, model)
	local stateGroup = Application.stateGroups[group] or {}
	local events = stateGroup[model.state] or {}
	table.insert(events, {name = "state"..model.name, model = model} )
	stateGroup[model.state] = events
	Application.stateGroups[group] = stateGroup
end

function Application.dispatchStateEvent(group, name)
	local stateGroup = Application.stateGroups[group] or {}
	local events = stateGroup[name] or {}

	-- for each objects
	for i=1, #events do
		local event = events[i]
		Runtime:dispatchEvent(event.name, {model=event.model})
	end
	if  stateGroup.current then
		local events = stateGroup[sateGroup.current] or {}
		for i=1, #events do
			local event = events[i]
			Runtime:dispatchEvent(event.name.."_off", {model=event.model})
		end	
	end
   
	-- for an action of state on/off
	Runtime:dispatchEvent("action_state"_group, {current = name, last = stateGroup.current})

	stateGroup.current = name
end
	--
return Application