-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _Command = {}
-----------------------------
-----------------------------
function _Command:new()
	local command = {}
	local _K              = require("Application")
	--
	function command:execute(params)
		local event         = params.event
		if event=="init" then
			local json = require("json")
			-- Json code for external variable loading
			local jsonFile = function(filename )
			   local path = system.pathForFile(filename, _K.DocumentsDir )
			   local contents
			   local file = io.open( path, "r" )
			   if file then
			      contents = file:read("*a")
			      io.close(file)
			      file = nil
			   end
			   return contents
			end
			-- Variable saving function
			local path = system.pathForFile(_K.appName.. "kwkVars.json", _K.DocumentsDir )
			local file = io.open( path, "r" )
			if file == nil then
			   local file = io.open( path, "w+" )
			   file:write("{{}}")
			   io.close(file)
			   file = nil
			else
				io.close(file)
				file = nil
			end
			-- Loads vars
			kwkVar = json.decode( jsonFile(_K.appName.."kwkVars.json") )
			-- Check for saved variables
			function kwkVarCheck(variable)
			   kwkVar = json.decode( jsonFile(_K.appName.."kwkVars.json") )
			   local found = nil
			   if kwkVar ~= nil then
			      for i = 1, #kwkVar do
			         if (variable == kwkVar[i].name) then
			            found = kwkVar[i].value; break
			         end
			      end
			   end
			   return (found)
			end
		end
	end
	return command
end
--
return _Command