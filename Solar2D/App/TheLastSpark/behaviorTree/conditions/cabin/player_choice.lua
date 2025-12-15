-- Cabin Scene Player Choice Conditions
-- Uses BasePlayerChoiceCondition for consistent behavior across scenes
-- Handles force_door, window, and markings choices

local BasePlayerChoiceCondition = require("conditions.BasePlayerChoiceCondition")

-- Create cabin-specific player choice condition using base class
return BasePlayerChoiceCondition.create("player choice", {
    FORCE_DOOR = "force_door",
    WINDOW = "window",
    MARKINGS = "markings"
})
