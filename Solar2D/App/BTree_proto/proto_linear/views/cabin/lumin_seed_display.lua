-------------------------------------------------------------------------------
-- Cabin Scene: Lumin Seed Display Helper
-------------------------------------------------------------------------------
local M = {}

local DEFAULT_IMAGE = "images/lumin_seed_normal.png"

local function resolveImage(modelData)
    local states = (modelData and modelData.states) or {}
    if modelData and modelData.defaultImage then return modelData.defaultImage end
    return states.normal or states.glowing or DEFAULT_IMAGE
end

function M.create(parent, modelData)
    assert(parent, "Display parent group is required")
    modelData = modelData or {}

    local imagePath = resolveImage(modelData)
    local width = modelData.width or 100
    local height = modelData.height or 100

    local seed = display.newImageRect(parent, imagePath, width, height)
    seed.x = modelData.x or display.contentCenterX
    seed.y = modelData.y or display.contentCenterY
    if modelData.visible ~= nil then seed.isVisible = modelData.visible end

    seed._states = modelData.states or {}
    seed._defaultImage = imagePath

    return seed
end

return M
