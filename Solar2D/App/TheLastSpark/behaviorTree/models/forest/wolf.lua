-- Wolf Character Model
-- Data structure for wolf character

local M = {}

function M.create()
    return {
        states = {
            normal = "images/wolf_normal.png",
            aggressive = "images/wolf_aggressive.png",
            calm = "images/wolf_calm.png",
            retreating = "images/wolf_retreating.png",
        },
        x = 800,
        y = 400,
        width = 400,
        height = 300,
        currentState = "normal",
        visible = false
    }
end

return M