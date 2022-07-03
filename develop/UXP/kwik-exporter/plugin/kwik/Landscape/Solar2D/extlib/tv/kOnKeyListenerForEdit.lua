local _M = {}
---------------------------------------
---------------------------------------
_M.controllersListPage = "views.page01Scene"
local updateHighlightColor = { 0.8, 0.2, 0.2 ,0.5 }
local controlButtons = { "left", "right", "up", "down", "fire", "start" }
---------------------------------------
---------------------------------------
local composer            = require( "composer" )
local currentInputIndex   = 0

-- Process the just-pressed key/button/axis
local function updateControlHighlight( )
	-- Highlight current selection box in red
	if currentInputIndex <= #_M.tableObjects["rects"] and currentInputIndex>0 then
		_M.tableObjects["rects"][currentInputIndex]:setFillColor(  unpack(updateHighlightColor ))
	end
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

local function setTitleText(t)
		_M.titleText.alpha = 1
		_M.titleText.text = t
		_M.titleText:setFillColor( 0.8, 0.2, 0.2 )
		-- transition.to( _M.titleText, { time=280, delay=1500, alpha=0, transition=easing.outQuad } )
end

local function processKey( keyName, device )
	print("processKey")
	print(device)
	-- local device = composer.getVariable( "userDevice" )
	-- Do not allow users to set the menu button to the fire button.
	if controlButtons[i] == "fire" and keyName == "menu" then
		setTitleText("invalid fire button")
		return false
	end
  if currentInputIndex == 0 then
  	currentInputIndex = currentInputIndex + 1
  	setTitleText("Press left Key")
	elseif currentInputIndex > 0 then
		local controls = composer.getVariable( "controls" )
		-- Prevent duplicate key selection
		-- Fail if the key has currently been selected
		local keyExists = false
		for i = 1,currentInputIndex-1 do
			if controls[device][controlButtons[i]] == keyName then
				keyExists = true
			end
		end
		-- If fail case, show alert message and return
		if keyExists then
			setTitleText("control already selected")
			return false
		elseif currentInputIndex < #controlButtons then
			setTitleText("Press "..controlButtons[currentInputIndex+1] .." key")
		else
			setTitleText("Press any key to exit")
		end
		-- Set key to current control
		print(#controls)
		print(device, keyName)
		controls[device][controlButtons[currentInputIndex]] = keyName
		_M.tableObjects["rects"][currentInputIndex]:setFillColor( 0.4 )
		_M.tableObjects["valuesObjects"][currentInputIndex].text = keyName
		-- Increment selection index row and update text value
		local newInputIndex = currentInputIndex + 1
		updateControlHighlight()
		timer.performWithDelay( 300, function()
			currentInputIndex = newInputIndex
			updateControlHighlight()
		end )
	end
	return true
end

function _M.onKeyEvent( event )
	print("onKeyEvent edit")
	if event.phase ~= "up" then
		return false
	end

	if  event.keyName == "back" then
		return true
	end

	local device = composer.getVariable( "userDevice" )

	if device == nil then
	  device   = getEventDevice( event )
	  print(device)
	end

	if currentInputIndex > #controlButtons then
		currentInputIndex = 0
		composer.setVariable( "userDevice", nil )
		-- print( require("json").encode(composer.getVariable( "controls" )) )
		composer.gotoScene( _M.controllersListPage, { effect="slideUp", time=600 } )
		return false
	end

	if getEventDevice(event) ~= device then
		print("device not match in kOnKeyListenerForEdit")
		return false
	end

	return processKey( event.keyName, device )
end


function _M.onAxisEvent( event )
	print("onAxisEvent edit")
	local device = composer.getVariable( "userDevice" )

	if device == nil then
	  device   = getEventDevice( event )
	  print(device)
	end

	if getEventDevice(event) ~= device or math.abs( event.normalizedValue ) < math.max( event.axis.accuracy, 0.6 ) then
		return
	end

	if currentInputIndex > #controlButtons then
		currentInputIndex = 0
		composer.setVariable( "userDevice", nil )
		composer.gotoScene( _M.controllersListPage, { effect="slideUp", time=600 } )
		return
	end

	if event.normalizedValue > 0 then
		processKey( event.axis.type .. "+", device )
	else
		processKey( event.axis.type .. "-", device )
	end
end

return _M