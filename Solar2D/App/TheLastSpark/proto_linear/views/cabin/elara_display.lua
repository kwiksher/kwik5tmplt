-------------------------------------------------------------------------------
-- Cabin Scene: Elara Display Helper
-------------------------------------------------------------------------------
local M = {}

local DEFAULT_IMAGE = "images/elara_neutral.png"

local function resolveImage(modelData)
    local states = (modelData and modelData.states) or {}
    if modelData and modelData.defaultImage then return modelData.defaultImage end
    return states.neutral or states.normal or DEFAULT_IMAGE
end

function M.create(parent, modelData)
    assert(parent, "Display parent group is required")
    modelData = modelData or {}

    local imagePath = resolveImage(modelData)
    local width = modelData.width or (modelData.size and modelData.size.width) or 300
    local height = modelData.height or (modelData.size and modelData.size.height) or 500

    local sprite = display.newImageRect(parent, imagePath, width, height)
    sprite.x = modelData.x or display.contentCenterX
    sprite.y = modelData.y or display.contentCenterY
    if modelData.visible ~= nil then sprite.isVisible = modelData.visible end

    sprite._states = modelData.states or {}
    sprite._defaultImage = imagePath

    return sprite
end

return M
