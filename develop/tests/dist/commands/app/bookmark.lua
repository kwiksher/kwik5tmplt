-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _Command = {}
-----------------------------
-----------------------------
function _Command:new()
	local command = {}
	--
	function command:execute(params)
		local event         = params.event
		local bookmark      = params.bookmark
		local appProps = params.appProps

		if event=="init" then
			-- Bookmark function
	    if bookmark  then
	        appProps.kBookmark = 1
					local path = system.pathForFile(appProps.appName.. "book.txt", appProps.DocumentsDir )
					local file = io.open( path, "r" )
					if file then
					   appProps.goPage = file:read("*l")
					   appProps.kBookmark = file:read("*l")
					   io.close(file)
					else
					    local file = io.open( path, "w+" )
			        file:write( appProps.goPage.."\n1" )
			        appProps.kBookmark = 1
					    io.close(file)
					end
	    else
	        appProps.kBookmark = 0
					local path = system.pathForFile(appProps.appName.. "book.txt",  appProps.DocumentsDir  )
					local file = io.open( path, "r" )
					if file then
					   io.close(file)
					else
				    local file = io.open( path, "w+" )
		        file:write( appProps.goPage.."\n0" )
				    io.close(file)
					end
	    end
		end
	end
	return command
end
--
return _Command