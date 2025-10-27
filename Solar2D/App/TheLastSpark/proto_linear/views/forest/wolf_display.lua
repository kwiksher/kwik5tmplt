-------------------------------------------------------------------------------
-- Forest Scene: Wolf Display Helper
-------------------------------------------------------------------------------
local M = {}

local DEFAULT_IMAGE = "images/corrupted_wolf_aggro.png"

local function resolveImage(modelData)
    local states = (modelData and modelData.states) or {}
    if modelData and modelData.defaultImage then return modelData.defaultImage end
    return states.aggro or states.calm or DEFAULT_IMAGE
end

function M.create(parent, modelData)
    assert(parent, "Display parent group is required")
    modelData = modelData or {}

    local imagePath = resolveImage(modelData)
    local width = modelData.width or 400
    local height = modelData.height or 300

    local wolf = display.newImageRect(parent, imagePath, width, height)
    wolf.x = modelData.x or display.contentCenterX
    wolf.y = modelData.y or display.contentCenterY
    if modelData.visible ~= nil then wolf.isVisible = modelData.visible end

    wolf._states = modelData.states or {}
    wolf._defaultImage = imagePath

    return wolf
end

return M
