-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _Command = {}
-----------------------------
-----------------------------
 local _K            = require "Application"
 function _Command:new()
	local command = {}
	--
	function command:execute(params)
		local event         = params.event
		local expDir        = params.expDir
		if event=="init" then
			if expDir then
			_K.imgDir    = "assets/images/"
			_K.audioDir  = "assets/audio/"
			_K.videoDir  = "assets/videos/"
			_K.spriteDir = "assets/sprites/"
			_K.thumbDir  = "assets/thumbnails/"
			else
				_K.imgDir    = "assets/"
				_K.audioDir  = "assets/"
				_K.videoDir  = "assets/"
				_K.spriteDir = "assets/"
				_K.thumbDir  = "assets/"
			end
		end
	end
	return command
end
--
return _Command