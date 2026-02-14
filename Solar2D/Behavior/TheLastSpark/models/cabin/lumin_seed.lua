local M = {}

function M.create(scale)
    -- Scale factor to convert @4x coordinates to @1x
    scale = scale or 0.25
    return {
        states = {
            normal = "App/TheLastSpark/assets/images/cabin/lumin_seed_normal.png",
            glowing = "App/TheLastSpark/assets/images/cabin/lumin_seed_glowing.png",
            dim = "App/TheLastSpark/assets/images/cabin/lumin_seed_dim.png",
            pulsing = "App/TheLastSpark/assets/images/cabin/lumin_seed_pulsing.png",
            collected = "App/TheLastSpark/assets/images/cabin/lumin_seed_collected.png",
        },
        x = 960 * scale,
        y = 540 * scale,
        width = 100 * scale,
        height = 100 * scale,
        currentState = "glowing",
        visible = false
    }
end

return M
