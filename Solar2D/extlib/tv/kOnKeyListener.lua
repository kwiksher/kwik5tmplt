local _M = {}
---------------------------------------
---------------------------------------
_M.controllerSetupPage = "views.page04Scene"
-- _M.activefillColor        = { (55/255)+(0.3), (68/255)+(0.3), (77/255)+(0.3), 1 }
_M.activefillColor        = { 1, 1 ,1 , 1 }
_M.inactivefillColor      = { (55/255)+(0.15), (68/255)+(0.15), (77/255)+(0.15), 1 }

local platformName   = system.getInfo("platformName")
local audioFileFormat = "ogg"
if ( platformName == "iPhone OS" or platformName == "tvOS" ) then
	audioFileFormat = "aac"
end
---------------------------------------
---------------------------------------
local composer            = require( "composer" )
local buttonGroup         = {}

_M.strokeColor       = nil

local 	sndClickHandle = audio.loadSound( "extlib/tv/click." .. audioFileFormat )

function _M:setReadmeSentence(b_name, b_word)
  table.insert(buttonGroup, b_name)
	if b_word then
	  for i=1, #b_name.text do         -- speak words
	    table.insert(buttonGroup, b_name.text[i])
	  end
	end
end

function _M:setButton(b)
	table.insert(buttonGroup,b)
end

function _M:getGroup()
	return buttonGroup
end

function _M:initGroup()
	buttonGroup = {}
	_M.focusIndex = 1
end

local function getEventDevice( event )
  -- print("device: "..event.device)
  -- print("descriptor: "..event.device.descriptor)
	return event.device and event.device.descriptor or "Keyboard"
end

local function getNiceDeviceName( event )
	if event.device then
    print("displayName: "..event.device.displayName)
		return event.device.displayName
	else
		return "Keyboard"
	end
end

function _M:updateMenuSelection()
	if buttonGroup then
		for i=1,#buttonGroup do
			local child = buttonGroup[i]
			if i == _M.focusIndex then
				if _M.strokeColor then
					child:setStrokeColor( unpack(_M.strokeColor) )
					child.strokeWidth = 5
				else
					child:setFillColor( unpack( _M.activefillColor ) )
					child.strokeWidth = 5
				end
				local mappedEvent = { name = "touch", phase="began" }
				buttonGroup[_M.focusIndex]:dispatchEvent( mappedEvent )
			else
				if _M.strokeColor then
					child.strokeWidth = 0
				else
					child:setFillColor( unpack( _M.inactivefillColor ) )
					child.strokeWidth = 0
				end
				local mappedEvent = { name = "touch", phase="ended" }
				buttonGroup[i].isKey = false
				buttonGroup[i]:dispatchEvent( mappedEvent )
			end
		end
	end
end

local function handleSceneButton(device, index)
	composer.setVariable( "userDevice", device )
	if buttonGroup[index].on then
		print("on func")
		buttonGroup[index]:on()
	else
		print("fire tap")
		local target = buttonGroup[index]
		local mappedEvent = { name = "tap", target = target }
    target:dispatchEvent( mappedEvent )
	end
	return true
end

function _M.onKeyEvent( event )
	print("onKeyEvent", event.keyName)
	if event.phase ~= "down" then
		return false
	end
	-- Let Android/tvOS exit here rather than closing the app mid-handling.
	if event.keyName == "back" or event.keyName == "menu" then
		return false
	end
	local controls = composer.getVariable("controls")
	local device   = getEventDevice( event )
	if controls[device] == nil then
		print("not configured deivce:"..device)
		composer.setVariable( "userDevice", device )
		controls[device] = {name = getNiceDeviceName( event )}
		timer.performWithDelay( 1, function ()
			composer.gotoScene( _M.controllerSetupPage, { effect="slideDown", time=600, params={editKey = true }} )
		end)
	else
		if controls[device]["fire"] == event.keyName then
			print("fire")
			if _M.focusIndex>0 then
				timer.performWithDelay( 1, function ()
					audio.play( sndClickHandle, {channel=16} )
					-- print(buttonGroup[_M.focusIndex].on)
					if buttonGroup[_M.focusIndex] then
						buttonGroup[_M.focusIndex].isKey = true
					else
						print("fire without button assignment")
					end
					handleSceneButton(device, _M.focusIndex )
				end)
			end
		elseif controls[device]["up"] == event.keyName then
			_M.focusIndex = math.clamp( _M.focusIndex - 1, 1, #buttonGroup)
		elseif controls[device]["down"] == event.keyName then
			_M.focusIndex = math.clamp( _M.focusIndex + 1, 1, #buttonGroup )
		end
		if _M.listeners and _M.listeners[event.keyName] ~=nil then -- start button for navigation
				_M.listeners[event.keyName]({isKey = true})
		end
		_M.updateMenuSelection()
	end
end


function _M.onAxisEvent( event )
	 print("onAxisEvent")
	local device   = getEventDevice( event )
	local controls = composer.getVariable( "controls" )
	local axisName = ""
	local accuracy = 0.6

	if event.normalizedValue > 0 then
		axisName = event.axis.type .. "+"
	else
		axisName = event.axis.type .. "-"
	end

	if math.abs(event.normalizedValue) > 0.6 then
		if controls[device] == nil then
			-- not configured device --
			composer.setVariable( "userDevice", device )
			controls[device] = {name=getNiceDeviceName( event )}
			timer.performWithDelay( 1, function ()
				composer.gotoScene( _M.controllerSetupPage, { effect="slideDown", time=600, params={editKey = true } } )
			end)
		else
			if controls[device]["fire"] == axisName then
				if _M.focusIndex>0 then
					timer.performWithDelay( 1, function ()
						audio.play( sndClickHandle )
						handleSceneButton(device, _M.focusIndex)
					end)
				end
			elseif controls[device]["up"] == axisName then
				_M.focusIndex = math.clamp( _M.focusIndex - 1, 1, #buttonGroup )
				Runtime:removeEventListener( "axis", _M.onAxisEvent )
				timer.performWithDelay( 300, function()
					Runtime:addEventListener( "axis", _M.onAxisEvent )
				end )
			elseif controls[device]["down"] == axisName then
				_M.focusIndex = math.clamp( _M.focusIndex + 1, 1, #buttonGroup )
				Runtime:removeEventListener( "axis", _M.onAxisEvent )
				timer.performWithDelay( 300, function()
					Runtime:addEventListener( "axis", _M.onAxisEvent )
				end )
			end
			_M.updateMenuSelection()
		end
	end
end

return _M