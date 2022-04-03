-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _Command = {}
local app = require "Application"
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
	        app.kBookmark = 1
					local path = system.pathForFile(app.appName.. "book.txt", app.DocumentsDir )
					local file = io.open( path, "r" )
					if file then
					   app.goPage = file:read("*l")
					   app.kBookmark = file:read("*l")
					   io.close(file)
					else
					    local file = io.open( path, "w+" )
			        file:write( app.goPage.."\n1" )
			        app.kBookmark = 1
					    io.close(file)
					end
	    else
	        app.kBookmark = 0
					local path = system.pathForFile(app.appName.. "book.txt",  app.DocumentsDir  )
					local file = io.open( path, "r" )
					if file then
					   io.close(file)
					else
				    local file = io.open( path, "w+" )
		        file:write( app.goPage.."\n0" )
				    io.close(file)
					end
	    end
		end
	end
	return command
end
--
return _Command