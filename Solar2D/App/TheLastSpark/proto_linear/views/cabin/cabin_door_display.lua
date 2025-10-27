-------------------------------------------------------------------------------
-- Cabin Scene: Door Display Helper
-------------------------------------------------------------------------------
local M = {}

local DEFAULT_IMAGE = "images/door_closed.png"

local function resolveImage(modelData)
    local states = (modelData and modelData.states) or {}
    if modelData and modelData.defaultImage then return modelData.defaultImage end
    return states.closed or states.open or states.broken or DEFAULT_IMAGE
end

function M.create(parent, modelData)
    assert(parent, "Display parent group is required")
    modelData = modelData or {}

    local imagePath = resolveImage(modelData)
    local width = modelData.width or 220
    local height = modelData.height or 320

    local door = display.newImageRect(parent, imagePath, width, height)
    door.x = modelData.x or display.contentCenterX
    door.y = modelData.y or display.contentCenterY
    if modelData.visible ~= nil then door.isVisible = modelData.visible end

    door._states = modelData.states or {}
    door._defaultImage = imagePath

    return door
end

return M
