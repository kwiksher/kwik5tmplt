-------------------------------------------------------------------------------
-- Shared display utilities for proto_linear scenes
-------------------------------------------------------------------------------
local widget = require("widget")

local M = {}

local function deepCopy(value)
    if type(value) ~= "table" then
        return value
    end

    local copy = {}
    for k, v in pairs(value) do
        copy[k] = deepCopy(v)
    end
    return copy
end

local function withDefaults(params, defaults)
    local merged = deepCopy(defaults or {})
    if params then
        for k, v in pairs(params) do
            merged[k] = v
        end
    end
    return merged
end

local function ensureColorComponents(color, default)
    color = color or default
    local r = color[1] or default[1]
    local g = color[2] or default[2]
    local b = color[3] or default[3]
    local a = color[4] or default[4]
    return r, g, b, a
end

-- Create and insert the display layers used by each scene
function M.createSceneLayers(parentGroup)
    local background = display.newGroup()
    local characters = display.newGroup()
    local ui = display.newGroup()

    parentGroup:insert(background)
    parentGroup:insert(characters)
    parentGroup:insert(ui)

    return {
        background = background,
        characters = characters,
        ui = ui,
    }
end

-- Build a background image (optional) and vignette overlay
function M.createBackgroundLayer(group, params)
    local defaultWidth = display.actualContentWidth or display.contentWidth or 1280
    local defaultHeight = display.actualContentHeight or display.contentHeight or 720
    local centerX = display.contentCenterX or (defaultWidth * 0.5)
    local centerY = display.contentCenterY or (defaultHeight * 0.5)

    local defaults = {
        width = defaultWidth,
        height = defaultHeight,
        x = centerX,
        y = centerY,
        vignette = true,
        vignetteX = centerX,
        vignetteY = centerY,
        vignetteWidth = defaultWidth,
        vignetteHeight = defaultHeight,
        vignetteColor = {0, 0, 0, 0.3},
    }

    local opts = withDefaults(params, defaults)

    local width = opts.width
    local height = opts.height
    local bgImage

    if opts.image then
        bgImage = display.newImageRect(group, opts.image, width, height)
        bgImage.x = opts.x
        bgImage.y = opts.y
    end

    local vignette
    if opts.vignette ~= false then
        local vx = opts.vignetteX or opts.x
        local vy = opts.vignetteY or opts.y
        local vw = opts.vignetteWidth or width
        local vh = opts.vignetteHeight or height
        vignette = display.newRect(group, vx, vy, vw, vh)
        local r, g, b, a = ensureColorComponents(opts.vignetteColor, defaults.vignetteColor)
        vignette:setFillColor(r, g, b, a)
    end

    return {
        background = bgImage,
        vignette = vignette,
    }
end

-- Create the dialogue UI elements (box, text, and next button)
function M.createDialogueInterface(uiGroup, params)
    local contentWidth = display.actualContentWidth or display.contentWidth or 1280
    local contentHeight = display.actualContentHeight or display.contentHeight or 720
    local centerX = display.contentCenterX or (contentWidth * 0.5)

    local defaults = {
        width = 1000,
        height = 120,
        x = centerX,
        y = contentHeight - 120,
        cornerRadius = 10,
        fillColor = {0, 0, 0, 0.8},
        strokeWidth = 2,
        strokeColor = {0.5, 0.3, 0.1, 1},
        initialText = "",
        font = native.systemFont,
        fontSize = 24,
        align = "center",
        textColor = {1, 1, 1, 1},
        buttonLabel = "Next",
        buttonShape = "roundedRect",
        buttonWidth = 120,
        buttonHeight = 50,
        buttonCornerRadius = 10,
        buttonFillColor = { default = {0.2, 0.5, 0.2, 1}, over = {0.3, 0.6, 0.3, 1} },
        buttonLabelColor = { default = {1, 1, 1}, over = {0.8, 0.8, 0.8} },
        onRelease = function() end,
        buttonX = contentWidth - 100,
        buttonY = contentHeight - 60,
        buttonVisible = false,
    }

    local opts = withDefaults(params, defaults)

    local boxWidth = opts.width
    local boxHeight = opts.height
    local box = display.newRoundedRect(
        uiGroup,
        opts.x,
        opts.y,
        boxWidth,
        boxHeight,
        opts.cornerRadius
    )
    local fr, fg, fb, fa = ensureColorComponents(opts.fillColor, defaults.fillColor)
    box:setFillColor(fr, fg, fb, fa)

    box.strokeWidth = opts.strokeWidth
    if box.strokeWidth > 0 then
        local sr, sg, sb, sa = ensureColorComponents(opts.strokeColor, defaults.strokeColor)
        box:setStrokeColor(sr, sg, sb, sa)
    end

    local text = display.newText({
        parent = uiGroup,
        text = opts.initialText,
        x = opts.textX or box.x,
        y = opts.textY or box.y,
        width = opts.textWidth or (boxWidth - 100),
        height = opts.textHeight or (boxHeight - 20),
        font = opts.font,
        fontSize = opts.fontSize,
        align = opts.align,
    })
    local tr, tg, tb, ta = ensureColorComponents(opts.textColor, defaults.textColor)
    text:setFillColor(tr, tg, tb, ta)

    local button = widget.newButton({
        label = opts.buttonLabel,
        shape = opts.buttonShape,
        width = opts.buttonWidth,
        height = opts.buttonHeight,
        cornerRadius = opts.buttonCornerRadius,
        fillColor = opts.buttonFillColor,
        labelColor = opts.buttonLabelColor,
        onRelease = opts.onRelease,
    })
    button.x = opts.buttonX
    button.y = opts.buttonY
    uiGroup:insert(button)
    button.isVisible = opts.buttonVisible

    return {
        container = box,
        dialogueText = text,
        nextButton = button,
    }
end

return M
