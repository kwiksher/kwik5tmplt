local M = {}

function M.create()
    return {
        states = {
            normal = "images/lumin_seed_normal.png",
            glowing = "images/lumin_seed_glowing.png",
            dim = "images/lumin_seed_dim.png",
            pulsing = "images/lumin_seed_pulsing.png",
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
