-- Cabin Scene Next Button Condition
-- Uses BaseButtonCondition for consistent button handling across scenes
-- This condition is always true when evaluated, allowing the behavior tree to proceed
-- The manual controller only ticks when the button is pressed, so this effectively
-- gates progression to button clicks

local BaseButtonCondition = require("conditions.BaseButtonCondition")

-- Create next button condition using base class
return BaseButtonCondition.create("next button", "clicked")
