local _M = {}
local platformName   = system.getInfo( "platformName" )
-------------------------------------------------
-------------------------------------------------
local _headerColor     = { 0.42, 0.42, 0.42, 0.9 }
local _headerLabel     = "current controllers"
local _backgroundColor = { 0.8, 0.8, 0.8, 0.3 }
local _rowColor        = { 1, 1, 1, 0.05 }
local _fontSize        = 20*768/320*2
local _rowHeight       = 50*768/320
--
local _font            = nil
if ( "Win" == platformName or "Android" == platformName ) then
	_font = native.systemFont
else
	_font = "HelveticaNeue-Light"
end
-------------------------------------------------
-------------------------------------------------
local composer                   = require( "composer" )
local widget                     = require("widget")
local presetControls             = require("extlib.tv.presetcontrols")
local controls                   = {}
local controllersTableView       = nil
local onInputDeviceStatusChanged = nil

--
-- create a specific group of buttons by kwik. ach button
-- each button func will be called according to the button id
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

local function onRowRender( event )
	local row       = event.row
	local rowHeight = row.contentHeight
	local rowWidth  = row.contentWidth
	local color     = event.row.params.color
	local _x        = 0
	local anchorX   = 0
  local deviceText
  if not event.row.isCategory then
    if controls[event.row.params.id] then
    	deviceText = event.row.params.id  .. ' / ' .. controls[event.row.params.id].name
    else
    	deviceText = event.row.params.deviceName .. " (not configured)"
    	color = color*0.6
    end
	else
		deviceText = event.row.params.label
		_x         = rowWidth/2
		anchorX    = 0.5
	end
  local rowTitle = display.newText( row, deviceText, 0, 0, _font, _fontSize )
  rowTitle:setFillColor( color )
	rowTitle.x       = _x
	rowTitle.y       = rowHeight * 0.5
	rowTitle.anchorX = anchorX
end

local function initControls()
	print("initControlsTable")
	local inputDevices = system.getInputDevices()
	for i = 1,#inputDevices do
		local device = inputDevices[i]
		controls[device.descriptor] = presetControls.presetForDevice( device )
	end
	if ( platformName == "Win" or platformName == "Mac OS X" ) then
		controls.Keyboard = presetControls.presetForKeyboard()
	end
end

function _M:init(sceneGroup, _x, _y, _w, _h)
	Runtime:addEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )
	initControls()
	controllersTableView = widget.newTableView{
		x               = _x,
		y               = _y,
		height          = _h,
		width           = _w,
		noLines         = true,
		backgroundColor = _backgroundColor,
		hideScrollBar   = true,
		onRowRender     = onRowRender
	}
	-- Header row
	controllersTableView:insertRow({
		isCategory = true,
		rowHeight  = _rowHeight,
		rowColor   = { default=_headerColor },
		params     = { label=_headerLabel, color=0.75 }
	})
	--	configured
	for i,v in pairs( controls ) do
		print(v.name)
		controllersTableView:insertRow(
		{
			isCategory = false,
			rowHeight  = _rowHeight,
			rowColor   = { default=_rowColor },
			params     = { id=i, color=0.9, deviceName=v.name }
		})
	end
	-- not configured
	local inputDevices = system.getInputDevices()
	for i = 1,#inputDevices do
		local device = inputDevices[i]
		local deviceId = getEventDevice({device=device})
		if controls[deviceId] == nil then
  		print("deviceId: "..deviceId)
			controllersTableView:insertRow({
				isCategory = false,
				rowHeight  = _rowHeight,
				rowColor   = { default=_rowColor },
				params     = { id=deviceId, color=0.9, deviceName=getNiceDeviceName{device=device} }
			})
		end
	end
	sceneGroup:insert( controllersTableView )
end

local function updateControlsTable( device, status, deviceName )
	if status == "connected" then
		local lastRow = controllersTableView:getRowAtIndex( controllersTableView:getNumRows() )
		controllersTableView:insertRow(
		{
			isCategory = false,
			rowHeight  = _rowHeight,
			rowColor   = { default= _rowColor},
			params     = { id=device, color=0.9, deviceName=deviceName }
		})
	elseif status == "disconnected" then
		for i=1,controllersTableView:getNumRows() do
			local row = controllersTableView:getRowAtIndex( i )
			if row ~= nil and row.params.id == device then
				controllersTableView:deleteRows( { i }, { slideLeftTransitionTime=0, slideUpTransitionTime=320 } )
			end
		end
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
			updateControlsTable( getEventDevice(event), "connected", getNiceDeviceName(event) )
		elseif event.device.isConnected == false then
			updateControlsTable( getEventDevice(event), "disconnected", getNiceDeviceName(event) )
		end
	end
end

function _M:setAlpha(alpha)
	controllersTableView.alpha = alpha
end

function _M:close()
	Runtime:removeEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )
end

return _M