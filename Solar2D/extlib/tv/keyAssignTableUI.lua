local _M = {}
local platformName = system.getInfo( "platformName" )
local mykey        = require("extlib.tv.kOnKeyListenerForEdit")
local composer     = require( "composer" )
-------------------------------------------------
-------------------------------------------------
local _headerColor     = { 0.42, 0.42, 0.42, 0.9 }
local _headerLabel     = "current controllers"
local _backgroundColor = { 0.8, 0.8, 0.8, 0.3 }
local _rowColor        = { 1, 1, 1, 0.05 }
local _fontSize        = 15*768/320*2
local _rowHeight       = 28*768/320

local presetControls             = require("extlib.tv.presetcontrols")
local controls                   = {}
local onInputDeviceStatusChanged = nil

local controlButtons =  { "left", "right", "up", "down", "fire", "start" }

local tableObjects = {
	labels = { "move left", "move right", "move up", "move down", "fire", "start game" },
	rects = {},
	valuesObjects = {}
}

local _font = nil
if ( "Win" == platformName or "Android" == platformName ) then
	_font = native.systemFont
else
	_font = "HelveticaNeue-Light"
end

-------------------------------------------------
-------------------------------------------------
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

local function initControls()
	print("initControlsTable keyAssignTable")
	controls = composer.getVariable( "controls")
	if controls == nil then
		print("reset")
		controls = {}
		local inputDevices = system.getInputDevices()
		for i = 1,#inputDevices do
			local device = inputDevices[i]
			controls[device.descriptor] = presetControls.presetForDevice( device )
		end
		if ( platformName == "Win" or platformName == "Mac OS X" ) then
			print("---- keyboard ----")
			controls.Keyboard = presetControls.presetForKeyboard()
		end
		composer.setVariable( "controls", controls )
	end
end

function _M:init(sceneGroup, _x, _y, _w, _h)
	Runtime:addEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )
	initControls()
  local device = composer.getVariable( "userDevice" ) -- from kOnKeyListener
	print("######## keyAssignTable ########")
	for k, v in pairs(controls) do print(k, v) end
	print(device)
	local _deviceName = "unknown device"
	local currentSetting = ""
	if device and controls[device] then
		_deviceName = controls[device].name
	end

	local setupGroup = display.newGroup()
	local _rowHeight = _fontSize + 4
	-- local topRect    = display.newRect( setupGroup, 0, 0, _w, _h )
	-- topRect:setFillColor( 0.52 )
	local titleText = display.newText( setupGroup, _deviceName, 0, _h/2-300, _font, _fontSize )
	--
	for i = 1,#tableObjects["labels"] do
		local controlRectLeft = display.newRect( setupGroup, -_w/2, -_h/2+(i-1)*_rowHeight, _w*0.6, _fontSize +1)
		controlRectLeft:setFillColor( 0.32 )
		controlRectLeft.anchorX = 0
		controlRectLeft.anchorY = 0

		local controlLabel = display.newText( setupGroup, tableObjects["labels"][i] .." ", controlRectLeft.contentBounds.xMax, controlRectLeft.y, _font, _fontSize )
		controlLabel:setFillColor( 0.9 )
		controlLabel.anchorX = 1
		controlLabel.anchorY = 0

		local controlRectRight = display.newRect( setupGroup, -_w/2 + controlRectLeft.width, -_h/2 + (i-1)*_rowHeight,_w*0.4, _fontSize + 1 )
		tableObjects["rects"][i] = controlRectRight
		controlRectRight.anchorX = 0
		controlRectRight.anchorY = 0
		controlRectRight:setFillColor( 0.4 )

		if device and controls[device] then
			currentSetting = controls[device][controlButtons[i]] or ""
		end

		local controlValue = display.newText( setupGroup, " "..currentSetting, controlRectRight.x, controlRectRight.y, _font, _fontSize )
		tableObjects["valuesObjects"][i] = controlValue
		controlValue.anchorX = 0
		controlValue.anchorY = 0
	end
	setupGroup.x = _x
	setupGroup.y = _y

	mykey.tableObjects = tableObjects
	mykey.titleText    = titleText
	-- sceneGroup:insert( titleText )
	sceneGroup:insert( setupGroup )
	if string.len(currentSetting) > 0 then
		return false
	else
		if device == nil then
			device ="unknown"
		end
		print("unknown device:"..device)
		controls[device] = {}
		controls[device].name = _deviceName
		composer.setVariable( "controls", controls )
		return true
	end
end

onInputDeviceStatusChanged = function( event )
	print("onInputDeviceStatusChanged")
	if event.connectionStateChanged and event.device then
		if controls[getEventDevice(event)] == nil then
			print("not configured yet")
			controls[getEventDevice(event)] = presetControls.presetForDevice( event.device )
		end
		if event.device.isConnected == true then
			print("updateControlsTable true")
		elseif event.device.isConnected == false then
		end
	end
end

function _M:willShow()
	controls = composer.getVariable( "controls")
	if controls == nil then
		controls = {}
	  local inputDevices = system.getInputDevices()
	  for i = 1,#inputDevices do
	  	local device = inputDevices[i]
	  	controls[device.descriptor] = presetControls.presetForDevice( device )
	  end
	  composer.setVariable( "controls", controls )
	end
end

function _M:didShow()
	print("didShow")
		Runtime:addEventListener( "key", mykey.onKeyEvent )
		Runtime:addEventListener( "axis", mykey.onAxisEvent )
		Runtime:addEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )
		-- system.activate("controllerUserInteraction")

end

function _M:willHide()
	Runtime:removeEventListener( "key", mykey.onKeyEvent )
	Runtime:removeEventListener( "axis", mykey.onAxisEvent )
	Runtime:removeEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )
end

function _M:didHide()
	-- system.deactivate("controllerUserInteraction")
end

return _M