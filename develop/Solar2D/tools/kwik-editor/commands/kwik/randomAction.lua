-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
local app            = require "Application"

function _M:playRandom(id, actions, playRand, params)
		local trigger
		-- print("randomAction")
		if actions and #actions > 0 then
			if playRand then
		    local ran = math.random(1,#actions)
				trigger = actions[ran]
		  else
				if  app.randomAction[id] == nil then
				  app.randomAction[id] = 0
				end
				app.randomAction[id] = app.randomAction[id] + 1
				if app.randomAction[id] > #actions then
					app.randomAction[id] = 1
				end
				trigger = actions[app.randomAction[id]]
			end
			params.event.UI = params.UI
	    Runtime:dispatchEvent({name=trigger, event=params.event, UI=params.UI})
	  end
end
--
function _M:playRandomAnimation(id, actions, playOnce, params)
		-- trigger()
		-- print("randomAnimation")
		if  app.randomAnim[id] == nil then
			 app.randomAnim[id] = {}
			 for i=1, #actions do
			 	app.randomAnim[id][i] =  {actions[i], false}
			 end
		end
		if #app.randomAnim[id] > 0 then
	    local ran = math.random(1,#app.randomAnim[id])
			local trigger = app.randomAnim[id][ran][1]
			table.remove(app.randomAnim[id], ran)
			-- print(trigger)
			params.event.phase = "play"
			params.event.UI = params.UI
	    Runtime:dispatchEvent({name=trigger, event=params.event})
	  end
end
--
return _M