-- Brass Key Object Model
-- Used to unlock the chest

local M = {}

function M.create()
    return {
        states = {
            hidden = "App/TheLastSpark/assets/images/cabin/brass_key_hidden.png",
            visible = "App/TheLastSpark/assets/images/cabin/brass_key.png",
            collected = "App/TheLastSpark/assets/images/cabin/brass_key_collected.png",
        },
        x = 450,
        y = 200,
        width = 50,
        height = 80,
        currentState = "hidden",
        visible = false,
        collected = false,
        usedOnChest = false
    }
end

return M
