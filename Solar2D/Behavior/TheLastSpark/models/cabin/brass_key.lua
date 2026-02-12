-- Brass Key Object Model
-- Used to unlock the chest

local M = {}

function M.create(scale)
    -- Scale factor to convert @4x coordinates to @1x
    scale = scale or 0.25
    return {
        states = {
            hidden = "App/TheLastSpark/assets/images/cabin/brass_key_hidden.png",
            visible = "App/TheLastSpark/assets/images/cabin/brass_key.png",
            collected = "App/TheLastSpark/assets/images/cabin/brass_key_collected.png",
        },
        x = 800 * scale,
        y = 850 * scale,
        width = 50 * scale,
        height = 50 * scale,
        currentState = "hidden",
        visible = false,
        collected = false,
        usedOnChest = false
    }
end

return M
