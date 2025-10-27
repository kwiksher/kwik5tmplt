local M = {}

function M.create()
    return {
        states = {
            normal = "images/item_lumin_seed.png",
            glowing = "images/item_lumin_seed_glowing.png",
        },
        x = 640,
        y = 400,
        width = 100,
        height = 100,
    }
end

return M
