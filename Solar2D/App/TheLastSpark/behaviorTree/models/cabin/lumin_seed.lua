local M = {}

function M.create()
    return {
        states = {
            normal = "App/TheLastSpark/assets/images/cabin/lumin_seed_normal.png",
            glowing = "App/TheLastSpark/assets/images/cabin/lumin_seed_glowing.png",
            dim = "App/TheLastSpark/assets/images/cabin/lumin_seed_dim.png",
            pulsing = "App/TheLastSpark/assets/images/cabin/lumin_seed_pulsing.png",
            collected = "App/TheLastSpark/assets/images/cabin/lumin_seed_collected.png",
        },
        x = 640,
        y = 400,
        width = 100,
        height = 100,
        currentState = "glowing",
        visible = false
    }
end

return M
