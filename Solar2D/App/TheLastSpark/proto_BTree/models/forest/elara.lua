-- Elara Character Model
-- Data structure for Elara character

local M = {}

function M.create()
    return {
        states = {
            neutral = "images/elara_neutral.png",
            scared = "images/elara_scared.png",
            determined = "images/elara_determined.png",
            happy = "images/elara_happy.png",
        },
        x = 300,
        y = 500,
        width = 300,
        height = 500,
        currentState = "neutral",
        visible = false
    }
end

return M