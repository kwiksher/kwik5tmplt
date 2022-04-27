-- Abstract: Transitions
-- Version: 2.0
-- Sample code is MIT licensed; see https://solar2d.com/LICENSE.txt
-- Fish sprite images courtesy of Kenney; see http://kenney.nl/
---------------------------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)
local M = {}
------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require("sampleUI.sampleUI")
sampleUI:newUI({
    theme = "darkgrey",
    title = "Transitions2",
    showBuildNum = false
})

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert(sampleUI.backGroup)
local mainGroup = display.newGroup()
display.getCurrentStage():insert(sampleUI.frontGroup)

----------------------
-- BEGIN SAMPLE CODE
----------------------

local transition = require("transition2")

-- Require libraries/plugins
local widget = require("widget")
widget.setTheme("widget_theme_ios7")

-- Set app font
local appFont = sampleUI.appFont

local transitionMethods = {}

local doNextTransition

local square = display.newRect(0, 0, 100, 100)
square.alpha = 0
local circle = display.newCircle(0, 0, 100)
circle.alpha = 0


---[[

transitionMethods.fallingLeaf = function(square)

    for i = 1, 100 do
        -- local leaf = display.newImageRect("leaf-64px.png", 64, 64)
        local leaf = display.newRect(0, 0, 64, 64)
        leaf.x, leaf.y = math.random(0, display.contentWidth), -50
        leaf.rotation = math.random(0, 360)
        local colors = {{1, 1, 0, 1}, {1, 0.6, 0, 1}}
        leaf:setFillColor(unpack(colors[math.random(1, #colors)]))
        transition.fallingLeaf(leaf, {
            delay = math.random(0, 5000),
            speed = 0.35,
            verticalIntensity = 0.4,
            horizontalIntensity = 0.5,
            rotationIntensity = 0.25,
            horizontalDirection = "random",
            randomness = 0.75,
            zRotateParams = {
                shadingDarknessIntensity = 0.5,
                shadingBrightnessIntensity = 0.25
            },
            cancelWhen = function()
                return (not leaf.y) or (leaf.y > display.contentHeight)
            end,
            onCancel = function(target)
                transition.fadeOut(target, {
                    time = 1000,
                    onComplete = function(target)
                        target:removeSelf()
                    end
                })
            end
        })
    end

    --[[

	transition.fallingLeaf(square, {
        delay = 500, -- Initial delay in ms. Default = 0.
        speed = 0.25, -- A value between 0-1. Default = 0.5.
        verticalIntensity = 0.75, -- A value between 0-1. Default = 0.5.
        horizontalIntensity = 0.75, -- A value between 0-1. Default = 0.5.

        horizontalDirection = "random", -- One of {"alternate", "right", "left", "random" }. Default = "alternate".

        randomness = 0.75, -- A value between 0-1. A larger value means more randomness. Default = 0.5.

        rotate = false, -- Default = true. Applies rotation to the object.
        zRotate = false, -- Default = true. Applies zRotate transition with specified zRotateParams.
        rotationIntensity = 0.75, -- A value between 0-1. Default = 0.5. Applies to both 2d rotation and zRotate.
        zRotateParams = {
            -- The parameters below are the only ones from zRotate that can be customized.
            -- For default values and usage, see zRotate() docs.
            shading = true, -- Default = true
            shadingDarknessIntensity = 0.5,
            shadingBrightnessIntensity = 1,
            perspective = 0.5,
            disableStrokeScaling = true
        },

        tag = "leaf",

        cancelWhen = function()
            return square.y > (display.contentHeight + square.height)
            -- square.y > display.contentHeight + square.height
        end,

        onStart = function(target) print("onStart") end,
        onPause = function(target) print("onComplete") end,
        onResume = function(target) print("onResume") end,
        onCancel = function(target) print("onCancel") end

        -- NOTE! The following params are NOT supported
        -- onComplete
        -- onIterationStart
        -- onIterationComplete
    })
	--]]

end

-- ]]


-- Reference table for easing methods
local easingMethods = {
    {"easing.linear", easing.linear}, {"easing.inSine", easing.inSine},
    {"easing.outSine", easing.outSine}, {"easing.inOutSine", easing.inOutSine},
    {"easing.inQuad", easing.inQuad}, {"easing.outQuad", easing.outQuad},
    {"easing.inOutQuad", easing.inOutQuad},
    {"easing.outInQuad", easing.outInQuad}, {"easing.inCubic", easing.inCubic},
    {"easing.outCubic", easing.outCubic},
    {"easing.inOutCubic", easing.inOutCubic},
    {"easing.outInCubic", easing.outInCubic},
    {"easing.inQuart", easing.inQuart}, {"easing.outQuart", easing.outQuart},
    {"easing.inOutQuart", easing.inOutQuart},
    {"easing.outInQuart", easing.outInQuart},
    {"easing.inQuint", easing.inQuint}, {"easing.outQuint", easing.outQuint},
    {"easing.inOutQuint", easing.inOutQuint},
    {"easing.outInQuint", easing.outInQuint}, {"easing.inExpo", easing.inExpo},
    {"easing.outExpo", easing.outExpo}, {"easing.inOutExpo", easing.inOutExpo},
    {"easing.outInExpo", easing.outInExpo}, {"easing.inCirc", easing.inCirc},
    {"easing.outCirc", easing.outCirc}, {"easing.inOutCirc", easing.inOutCirc},
    {"easing.outInCirc", easing.outInCirc}, {"easing.inBack", easing.inBack},
    {"easing.outBack", easing.outBack}, {"easing.inOutBack", easing.inOutBack},
    {"easing.outInBack", easing.outInBack},
    {"easing.inElastic", easing.inElastic},
    {"easing.outElastic", easing.outElastic},
    {"easing.inOutElastic", easing.inOutElastic},
    {"easing.outInElastic", easing.outInElastic},
    {"easing.inBounce", easing.inBounce},
    {"easing.outBounce", easing.outBounce},
    {"easing.inOutBounce", easing.inOutBounce},
    {"easing.outInBounce", easing.outInBounce}
}

-- Create picker wheel for easing methods and transition time
local easingLabels = {}
for i = 1, #easingMethods do
    easingLabels[#easingLabels + 1] = easingMethods[i][1]
end

-- for k, v in pairs(transitionMethods) do easingLabels[#easingLabels + 1] = k end

local columnData = {
    {
        align = "left",
        width = 180 - display.screenOriginX,
        labelPadding = 25,
        startIndex = 3,
        labels = easingLabels
    }, {
        align = "center",
        width = 140 - display.screenOriginX,
        labelPadding = 0,
        startIndex = 3,
        labels = {"250", "500", "1000", "2000"}
    }
}
local pickerWheel = widget.newPickerWheel({
    columns = columnData,
    style = "resizable",
    width = display.actualContentWidth,
    rowHeight = 32,
    font = appFont,
    fontSize = 15
})
mainGroup:insert(pickerWheel)
pickerWheel.x = display.contentCenterX
pickerWheel.y = display.contentHeight - display.screenOriginY - 80

-- Picker wheel column labels (above)
local label1 = display.newText({
    parent = mainGroup,
    text = "Easing Interpolation",
    x = display.screenOriginX + 25,
    y = pickerWheel.contentBounds.yMin - 18,
    width = 180 - display.screenOriginX,
    height = 0,
    font = appFont,
    fontSize = 15
})
label1:setFillColor(0.8)
label1.anchorX = 0
local label2 = display.newText({
    parent = mainGroup,
    text = "Time (ms)",
    x = 180,
    y = pickerWheel.contentBounds.yMin - 18,
    width = 140 - display.screenOriginX,
    height = 0,
    font = appFont,
    fontSize = 15,
    align = "center"
})
label2:setFillColor(0.8)
label2.anchorX = 0

-- Data for repeating series of transitions
local characterTransitions = {
    {x = 260, delay = 400}, {y = 260, xScale = -0.8, delay = 800},
    {xScale = -1, yScale = 1, delay = 400},
    {x = 60, xScale = -0.6, yScale = 0.6, delay = 1200},
    {rotation = 135, delay = 400}, {x = 260, y = 60, alpha = 0, delay = 400},
    {rotation = 0, alpha = 1, delay = 800}, {x = 60, delay = 400},
    {xScale = 0.8, yScale = 0.8, delay = 400}
}

local function createCharacter()
    -- Create character
    local sheetOptions = {
        width = 55,
        height = 42,
        numFrames = 2,
        sheetContentWidth = 110,
        sheetContentHeight = 42
    }
    local imageSheet = graphics.newImageSheet("fish.png", sheetOptions)
    local character = display.newSprite(mainGroup, imageSheet, {
        name = "swim",
        start = 1,
        count = 2,
        time = 200
    })
    character.x, character.y = 60, 60
    character.xScale, character.yScale = 0.8, 0.8
    character:play()
    return character
end

local currentTransition = 1

local character = createCharacter()
local instance = nil

doNextTransition = function()
    print("doNextTransition")
    -- if character then character:removeSelf() end
    -- character = createCharacter()

    -- Before next transition starts, gather settings from picker wheel
    local pickerValues = pickerWheel:getValues()

    -- Set up transition parameters
    local transData = characterTransitions[currentTransition]
    transData["time"] = tonumber(pickerValues[2].value)
    transData["transition"] = easingMethods[pickerValues[1].index][2]
    transData["onComplete"] = doNextTransition

    -- local funcName = easingLabels[pickerValues[1].index]
    -- transitionMethods[funcName](character)

    -- Initiate the transition
    instance = transition.to(character, transData)

    -- Increment current transition (or reset to first)
    if (currentTransition < #characterTransitions) then
        currentTransition = currentTransition + 1
    else
        currentTransition = 1
    end
end

-- Initiate first transition
-- doNextTransition()

M["character/Transitions"] = function(value)
    local json = require("json")
    print(json.encode(value))
    characterTransitions = value
end

function M:setValue(name, value)
    print("setValue")
    transition.cancel(instance)
    if character then character:removeSelf() end
    character = createCharacter()
    self[name](value)
    currentTransition = 1
    doNextTransition()
end

function M:setTransition(name, params)
    print("setTransition", params[1].transition)
    transition[params[1].transition](character,params[2].params)
    for k, v in pairs(params[2].params) do print("", k, v) end
    -- transition["bounce"](character, {
    --     height = 400, -- Bounces upwards. Set to negative value to bounce downwards.
    --     width = 200, -- Bounces to the right. Set to negative value to bounce left.
    --     time = 1000,
    --     iterations = 0
    -- })
end


transitionMethods.fallingLeaf()
-- timer.performWithDelay(5000, doNextTransition, -1)
return M
