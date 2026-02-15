-- Wait Action
-- Returns RUNNING to pause tree execution until clearWait is called
-- Uses BaseWaitAction for common functionality

local BaseWaitAction = require("Behavior.base_wait_action")

-- Create module using base class
return BaseWaitAction.new()
