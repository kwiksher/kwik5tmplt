-- Lumin Seed Object Model
-- Data structure for lumin seed object

local M = {}

function M.create()
    return {
        states = {
            normal = "images/lumin_seed.png",
            glowing = "images/lumin_seed_glowing.png",
        },
        x = 500,
        y = 300,
        width = 150,
        height = 150,
        currentState = "normal",
        visible = false
    }
end

return M