local dir = ...
local parent = dir:match("(.-)[^%.]+$")
local root = parent:sub(1, parent:len()-1):match("(.-)[^%.]+$")

local M = {}

M.new = function(mediatorName)
    print(mediatorName)
    local Class = {}
	print()
    -- Class.name = mediatorName:gsub("mediators.", ""):gsub("Mediator", "")
    Class.name = mediatorName:match("[^.]+$"):gsub("Mediator", "")
    --
    local appDir = mediatorName:match('(App%.%a+%.)')
    print(appDir, Class.name)
    local scene = require(appDir.."scenes." .. Class.name..".index")
    Class.events = scene:getEvents()
    --
    function Class:new()
        local mediator = {}
        mediator.events = self.events
        mediator.name = self.name
        --
        function mediator:onRegister()
            local scene = self.viewInstance
            for k, eventName in pairs(self.events) do
                scene:addEventListener(eventName, self)
            end
        end
        --
        function mediator:onRemove()
            local scene = self.viewInstance
            for k, eventName in pairs(self.events) do
                scene:removeEventListener(eventName, self)
            end
        end
        --
        print("mediator")
        for k, eventName in pairs(self.events) do
			print("", self.name, eventName)
            mediator[eventName] = function(self, event)
                local myself = self
                Runtime:dispatchEvent({
                    name = myself.name .. "." .. eventName,
                    event = event,
                    UI = myself.viewInstance.UI
                })
            end
        end
        --
        return mediator
    end
    --
    return Class
end

return M