-- Forest Scene Player Choice Conditions
-- Uses BasePlayerChoiceCondition for consistent behavior across scenes
-- Handles fight, calm, and retreat choices

local BasePlayerChoiceCondition = require("conditions.BasePlayerChoiceCondition")

-- Create forest-specific player choice condition using base class
return BasePlayerChoiceCondition.create("player choice", {
    CALM = "calm",
    FIGHT = "fight",
    RETREAT = "retreat"
})