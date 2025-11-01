-- Cabin Object Model
-- Data structure for cabin object

local M = {}

function M.create()
    return {
        states = {
            exterior = "images/cabin_exterior.png",
            interior = "images/cabin_interior.png",
        },
        x = 200,
        y = 200,
        width = 600,
        height = 400,
        currentState = "exterior",
        visible = false
    }
end

return M