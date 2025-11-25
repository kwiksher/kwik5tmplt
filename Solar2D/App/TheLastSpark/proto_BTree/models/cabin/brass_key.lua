-- Brass Key Object Model
-- Used to unlock the chest

local M = {}

function M.create()
    return {
        states = {
            hidden = "images/brass_key_hidden.png",
            visible = "images/brass_key.png",
            collected = "images/brass_key_collected.png",
        },
        x = 450,
        y = 620,
        width = 50,
        height = 80,
        currentState = "hidden",
        visible = false,
        collected = false
    }
end

return M
