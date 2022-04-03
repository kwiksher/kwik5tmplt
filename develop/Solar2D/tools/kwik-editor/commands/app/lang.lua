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
		if event=="init" then
			-- Set table with languages for auto selection
			local langTable = {
				{{#langArr}}
			    "{{langID}}",
				{{/langArr}}
			}
			local defLang = system.getPreference("ui","language")
			app.lang = "{{lang_0}}"

			-- Auto select a language based on the device language
			for k,v in pairs(langTable) do
			    if defLang == v then app.lang = v break end
			end
			if defLang == "pt-BR" then
    			app.lang = "pt"
			end
		end
	end
	return command
end
--
return _Command