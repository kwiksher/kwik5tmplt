
local ApplicationMediator = {}
--
--  viewInstance is an instance of Application
--
function ApplicationMediator:new()
	local mediator = {}
	mediator.session = nil
	--
	function mediator:onRegister()
		Runtime:addEventListener("onTrigger", self)
		self.viewInstance:showView(self.viewInstance.startSceneName, {})
	end
	--
	function mediator:onTrigger(event)
		self.viewInstance:trigger(event.url)
	end
	--
	return mediator
end
--
return ApplicationMediator