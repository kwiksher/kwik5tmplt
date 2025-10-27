-------------------------------------------------------------------------------
-- Cabin Scene: Chest Display Helper
-------------------------------------------------------------------------------
local M = {}

local DEFAULT_IMAGE = "images/chest_locked.png"

local function resolveImage(modelData)
    local states = (modelData and modelData.states) or {}
    if modelData and modelData.defaultImage then return modelData.defaultImage end
    return states.locked or states.unlocked or states.open or states.empty or DEFAULT_IMAGE
end

function M.create(parent, modelData)
    assert(parent, "Display parent group is required")
    modelData = modelData or {}

    local imagePath = resolveImage(modelData)
    local width = modelData.width or 170
    local height = modelData.height or 130

    local chest = display.newImageRect(parent, imagePath, width, height)
    chest.x = modelData.x or display.contentCenterX
    chest.y = modelData.y or display.contentCenterY
    if modelData.visible ~= nil then chest.isVisible = modelData.visible end

    chest._states = modelData.states or {}
    chest._defaultImage = imagePath

    return chest
end

return M
