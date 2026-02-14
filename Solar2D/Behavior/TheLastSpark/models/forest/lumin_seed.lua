-- Lumin Seed Object Model
-- Data structure for lumin seed object

local M = {}

function M.create(scale)
    -- Scale factor to convert @4x coordinates to @1x
    scale = scale or 0.25
    return {
        states = {
            normal = "App/TheLastSpark/assets/images/forest/lumin_seed.png",
            glowing = "App/TheLastSpark/assets/images/forest/lumin_seed_glowing.png",
        },
        x = 240*4 * scale,  -- 480 (center of 960 width screen)
        y = 160*4 * scale,  -- 295 (center of 590 height screen)
        width = 150 * scale,
        height = 150 * scale,
        currentState = "normal",
        visible = false
    }
end

return M