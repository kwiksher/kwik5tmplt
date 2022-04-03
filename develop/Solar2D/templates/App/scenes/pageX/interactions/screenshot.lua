-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local json    = require('json')
local _M = {}
local _K = require("Application")
_K.screenshot = _M

local needle = "Storage"
-- Helper function that determines if a value is inside of a given table.
local function isValueInTable( haystack, needle )
    assert( type(haystack) == "table", "isValueInTable() : First parameter must be a table." )
    assert( needle ~= nil, "isValueInTable() : Second parameter must be not be nil." )
    for key, value in pairs( haystack ) do
        if ( value == needle ) then
            return true
        end
    end
    return false
end

-- Called when the user has granted or denied the requested permissions.
local function permissionsListener( event, deferred )
    -- Print out granted/denied permissions.
    print( "permissionsListener( " .. json.prettify( event or {} ) .. " )" )
    -- Check again for camera (and storage) access.
    local grantedPermissions = system.getInfo("grantedAppPermissions")
    if ( grantedPermissions ) then
        if ( not isValueInTable( grantedPermissions, needle ) ) then
            print( "Lacking storage permission!" )
            deferred:reject()
        else
            deferred:resolve()
        end
    end
end

function checkPermissions()
    local deferred = Deferred()
    if ( system.getInfo( "platform" ) == "android" and system.getInfo( "androidApiLevel" ) >= 23 ) then
        local grantedPermissions = system.getInfo("grantedAppPermissions")
        if ( grantedPermissions ) then
            if ( not isValueInTable( grantedPermissions, needle ) ) then
                print( "Lacking storage permission!" )
                native.showPopup( "requestAppPermission", { appPermission={needle}, listener = function(event) permissionListener(event, deferred) end} )
            else
                deferred:resolve()
            end
        end
    else
        if  media.hasSource( media.PhotoLibrary ) then
            deferred:resolve()
        else
            deferred:reject()
        end
    end
    return deferred:promise()
end

---------------------
function _M:localPos(UI)
	if _K.allAudios.cam_shutter == nil then
	  _K.allAudios.cam_shutter = audio.loadSound(_K.audioDir.."shutter.mp3", _K.systemDir )
	end
end
--
function _M:didShow(UI)
	_M.layer = UI.layer
end
--
function _M:takeScreenShot(ptit, pmsg, shutter, buttonArr)
	checkPermissions()
    :done(function()
        if shutter then
            audio.play(_K.allAudios.cam_shutter, {channel=31})
        end
        if buttonArr then
            for i=1, #buttonArr do
              local myLayer = _M.layer[buttonArr[i]]
              myLayer.alphaBeforeScreenshot = myLayer.alpha
              myLayer.alpha = 0
            end
        end
            --
        local screenCap = display.captureScreen( true )
        local alert = native.showAlert(ptit, pmsg, { "OK" } )
        screenCap:removeSelf()
        if buttonArr then
            for i=1, #buttonArr do
              local myLayer = _M.layer[buttonArr[i]]
              myLayer.alpha = myLayer.alphaBeforeScreenshot
            end
        end
    end)
	:fail(function()
	    print("fail")
	    native.showAlert( "Corona", "Request permission is not granted on "..system.getInfo("model"), { "OK" } )
    end)
end
--
function _M:toDispose(UI)
	if _K.allAudios.cam_shutter then
		audio.stop(31)
	end
end
--
function _M:toDestroy(UI)
		audio.dispose(_K.allAudios.cam_shutter)
		_K.allAudios.cam_shutter = nil
end
--
function _M:willHide(UI)
end
--
function _M:localVars(UI)
end
--
return _M
