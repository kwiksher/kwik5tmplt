local _M = {}
----------------------------------------
----------------------------------------
_M.defaultStrokeColor = { 1, 1, 0, 1 }
_M.defaultExitNaviKey = "start"
-- _M.defaultExitNaviKey = "space"
----------------------------------------
----------------------------------------
local composer       = require("composer")
local mykey          = require("extlib.tv.kOnKeyListener")
local presetControls = require("extlib.tv.presetcontrols")
local platformName   = system.getInfo("platformName")

local controls             = {}
local listeners            = {}

-- create a specific group of buttons by kwik. ach button
-- each button func will be called according to the button id
local strokeColor   = nil
local activefillColor   = mykey.activefillColor
local inactivefillColor = mykey.inactivefillColor

function _M:resetStrokeColor()
	mykey.strokeColor = nil
end

function _M:setStrokeColor(c)
	mykey.strokeColor = c
end

local function getEventDevice( event )
	return event.device and event.device.descriptor or "Keyboard"
end

local function getNiceDeviceName( event )
	if event.device then
		return event.device.displayName
	else
		return "Keyboard"
	end
end

function _M:addEventListener( eventName, listener )
	listeners[eventName] = listener
	mykey.listeners = listeners
end

function _M:removeEventListener( eventName )
	listeners[eventName] = null
	mykey.listeners = null
end

function math.clamp(n, low, high) return math.min(math.max(n, low), high) end

local function onInputDeviceStatusChanged( event )
	print("onInputDeviceStatusChanged")
	if event.connectionStateChanged and event.device then
		if controls[getEventDevice(event)] == nil then
			print("not configured yet")
			controls[getEventDevice(event)] = presetControls.presetForDevice( event.device )
		end
		if event.device.isConnected == true then
			print("updateControlsTable true")
		elseif event.device.isConnected == false then
			print("updateControlsTable false")
		end
	end
end

local _previousGroup = nill

function _M:setReadmeSentence(b_name, b_word)
	mykey:setReadmeSentence(b_name, b_word)
end

function _M:setButton(b)
	mykey:setButton(b)
end

function _M:initGroup()
	mykey:initGroup()
end

function _M:setNaviGroup(g)
	_previousGroup = mykey:getGroup()
	mykey:initGroup()
	for i=1, g.numChildren do
		mykey:setButton(g[i])
	end
end

function _M:setPreviousGroup()
	mykey:initGroup()
	for i=1, #_previousGroup do
		mykey:setButton(_previousGroup[i])
	end
end

function _M:willShow()
	controls = composer.getVariable( "controls")
	if controls == nil then
		controls = {}
		if ( platformName == "Win" or platformName == "Mac OS X" ) then
			controls.Keyboard = presetControls.presetForKeyboard()
			print("---- keyboard kInputDevice ----")
			for k, v in pairs(controls.Keyboard) do print(k, v) end
			composer.setVariable("userDevice", "Keyboard")
		else
		  local inputDevices = system.getInputDevices()
		  for i = 1,#inputDevices do
		  	local device = inputDevices[i]
		  	controls[device.descriptor] = presetControls.presetForDevice( device )
		  end
		end
	    composer.setVariable( "controls", controls )
		mykey.focusIndex = 0
		mykey.updateMenuSelection()
	end
end

function _M:didShow()
		Runtime:addEventListener( "key", mykey.onKeyEvent )
		Runtime:addEventListener( "axis", mykey.onAxisEvent )
		Runtime:addEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )
		system.activate("controllerUserInteraction")
end

function _M:willHide()
	Runtime:removeEventListener( "key", mykey.onKeyEvent )
	Runtime:removeEventListener( "axis", mykey.onAxisEvent )
	Runtime:removeEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )
end

function _M:didHide()
	print("didHide")
	mykey:initGroup()
	system.deactivate("controllerUserInteraction")
end

return _M