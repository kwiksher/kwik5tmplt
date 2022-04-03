-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _Command = {}
-----------------------------
-----------------------------
 local app            = require "Application"
 function _Command:new()
	local command = {}
	--
	function command:execute(params)
		local event         = params.event
		local expDir        = params.expDir
		if event=="init" then
			if expDir then
			app.imgDir    = "assets/images/"
			app.audioDir  = "assets/audio/"
			app.videoDir  = "assets/videos/"
			app.spriteDir = "assets/sprites/"
			app.thumbDir  = "assets/thumbnails/"
			else
				app.imgDir    = "assets/"
				app.audioDir  = "assets/"
				app.videoDir  = "assets/"
				app.spriteDir = "assets/"
				app.thumbDir  = "assets/"
			end
		end
	end
	return command
end
--
return _Command