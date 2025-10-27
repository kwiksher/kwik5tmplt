local M = {}

function M.create()
    return {
        states = {
            aggro = "images/corrupted_wolf_aggro.png",
            calm = "images/corrupted_wolf_calm.png",
        },
        x = 900,
        y = 450,
        width = 400,
        height = 300,
    }
end

return M
