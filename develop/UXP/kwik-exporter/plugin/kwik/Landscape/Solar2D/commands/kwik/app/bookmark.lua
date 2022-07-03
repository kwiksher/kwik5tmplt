-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _Command = {}
local _K = require "Application"
-----------------------------
-----------------------------
function _Command:new()
	local command = {}
	--
	function command:execute(params)
		local event         = params.event
		local bookmark      = params.bookmark
		if event=="init" then
			-- Bookmark function
	    if bookmark  then
	        _K.kBookmark = 1
					local path = system.pathForFile(_K.appName.. "book.txt", _K.DocumentsDir )
					local file = io.open( path, "r" )
					if file then
					   _K.goPage = file:read("*l")
					   _K.kBookmark = file:read("*l")
					   io.close(file)
					else
					    local file = io.open( path, "w+" )
			        file:write( _K.goPage.."\n1" )
			        _K.kBookmark = 1
					    io.close(file)
					end
	    else
	        _K.kBookmark = 0
					local path = system.pathForFile(_K.appName.. "book.txt",  _K.DocumentsDir  )
					local file = io.open( path, "r" )
					if file then
					   io.close(file)
					else
				    local file = io.open( path, "w+" )
		        file:write( _K.goPage.."\n0" )
				    io.close(file)
					end
	    end
		end
	end
	return command
end
--
return _Command