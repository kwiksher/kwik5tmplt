-- Narration Scene Player Choice Conditions
-- Uses BasePlayerChoiceCondition for consistent behavior across scenes
-- Handles reload and continue choices

local BasePlayerChoiceCondition = require("conditions.BasePlayerChoiceCondition")

-- Create narration-specific player choice condition using base class
return BasePlayerChoiceCondition.create("player choice", {
    RELOAD = "reload",
    CONTINUE = "continue"
})
