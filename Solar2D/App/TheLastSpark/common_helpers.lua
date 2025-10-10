-------------------------------------------------------------------------------
-- Common Helpers - shared utilities across scenes
-------------------------------------------------------------------------------

local M = {}
local composer = composer or require("composer")
local widget = require("widget")

-- Methods table for setmetatable __index usage. Each method expects self._env.
M.methods = {}

function M.methods:executeSceneStep(index)
    local env = self._env or {}
    local dialogue = env.sceneDialogue or {}
    local audioFiles = env.audioFiles

    local state = env.state or {}
    state.currentDialogueIndex = index

    if index > #dialogue then return end
    local step = dialogue[index]

    if step.type == "narration" then
        self:showDialogue(step.text)

    elseif step.type == "show" then
        self:showObject(step.what)
        timer.performWithDelay(500, function()
            self:executeSceneStep(index + 1)
        end)

    elseif step.type == "scene" then
        self:changeBackground("images/" .. step.background .. ".png")
        timer.performWithDelay(500, function()
            self:executeSceneStep(index + 1)
        end)

    elseif step.type == "sfx" then
        self:playSFX(step.sound, step.loop)
        self:executeSceneStep(index + 1)

    elseif step.type == "vo" then
        self:showDialogue(step.text)
        self:playSFX(step.sound)

    elseif step.type == "music" then
        if step.action == "play" and audioFiles then
            local path = audioFiles[step.sound]
            if path then
                audio.play(audio.loadStream(path), { channel = 1, loops = -1 })
            end
        end
        self:executeSceneStep(index + 1)

    elseif step.type == "emotion" then
        self:changeEmotion(step.character, step.state)
        self:executeSceneStep(index + 1)

    elseif step.type == "object_state" then
        if step.object then self:changeObjectState(step.object, step.state) end
        if step.objects then
            for _, objName in ipairs(step.objects) do
                self:changeObjectState(objName, step.state)
            end
        end
        self:executeSceneStep(index + 1)

    elseif step.type == "object_state_conditional" then
        if step.object then self:changeObjectStateConditional(step.object, step.state, step.condition) end
        if step.objects then
            for _, objName in ipairs(step.objects) do
                self:changeObjectStateConditional(objName, step.state, step.condition)
            end
        end
        self:executeSceneStep(index + 1)

    elseif step.type == "custom" then
        -- Execute custom action/function
        if step.action then
            if self.executeAction then
                -- Use scene-specific action execution (supports string lookup)
                self:executeAction(step.action)
            elseif type(step.action) == "function" then
                -- Fallback: direct function call
                step.action()
            elseif type(step.action) == "string" then
                print("Warning: Action string '" .. step.action .. "' provided but scene has no executeAction method!")
            end
        end
        self:executeSceneStep(index + 1)

    elseif step.type == "choice" then
        self:showChoice(step.options)
    end
end

function M.methods:advanceDialogue()
    local env = self._env or {}
    local state = env.state or { currentDialogueIndex = 0 }
    local nextButton = env.nextButton
    if nextButton then nextButton.isVisible = false end
    self:executeSceneStep((state.currentDialogueIndex or 0) + 1)
end

function M.methods:showDialogue(text)
    local env = self._env or {}
    local dialogueText = env.dialogueText
    local nextButton = env.nextButton
    if dialogueText then dialogueText.text = text or "" end
    if nextButton then nextButton.isVisible = true end
end

function M.methods:changeBackground(imagePath)
    local env = self._env or {}
    local background = env.background
    local vignette = env.vignette
    if not background then return end
    transition.fadeOut(background, { time = 800 })
    timer.performWithDelay(800, function()
        if background.numChildren and background.numChildren > 0 then
            pcall(function() background:remove(1) end)
        end
        local newBg = display.newImageRect(background, imagePath, 1280, 720)
        newBg.x = display.contentCenterX
        newBg.y = display.contentCenterY
        newBg.alpha = 0
        if vignette then background:insert(1, vignette) end
        transition.fadeIn(newBg, { time = 800 })
    end)
end

function M.methods:playSFX(soundName, shouldLoop)
    local env = self._env or {}
    local audioFiles = env.audioFiles
    local options = { channel = 2 }
    if shouldLoop then options.loops = -1 end
    local path = audioFiles and audioFiles[soundName]
    if path then audio.play(audio.loadSound(path), options) end
end

-- Generic object visibility helper using the scene's objects registry
function M.methods:showObject(name)
    local env = self._env or {}
    local objects = env.objects or {}
    local od = objects[name]
    if od and od.image then
        od.image.isVisible = true
    end
end

-- Generic object state change: swap image for a named object/state
-- Expects env.objects[objectName] = { states={ [state]=imagePath }, width,height,x,y, image? }
function M.methods:changeObjectState(objectName, newState, onComplete)
    local env = self._env or {}
    local objects = env.objects or {}
    local characterGroup = env.characterGroup or self.view
    local objectData = objects[objectName]
    if not objectData then
        print("Warning: Object '" .. tostring(objectName) .. "' not found!")
        return
    end

    local stateImage = objectData.states and objectData.states[newState]
    if not stateImage then
        print("Warning: State '" .. tostring(newState) .. "' not found for object '" .. tostring(objectName) .. "'!")
        return
    end

    if not objectData.image then
        objectData.image = display.newImageRect(
            characterGroup,
            stateImage,
            objectData.width or 100,
            objectData.height or 100
        )
        objectData.image.x = objectData.x or display.contentCenterX
        objectData.image.y = objectData.y or display.contentCenterY
    else
        local oldX, oldY = objectData.image.x, objectData.image.y
        local oldW, oldH = objectData.image.width, objectData.image.height
        pcall(function() objectData.image:removeSelf() end)
        objectData.image = display.newImageRect(characterGroup, stateImage, oldW, oldH)
        objectData.image.x, objectData.image.y = oldX, oldY
    end

    objectData.image.alpha = 0
    transition.fadeIn(objectData.image, { time = 500 })

    if onComplete then
        timer.performWithDelay(600, onComplete)
    end
end

function M.methods:changeObjectStateConditional(objectName, newState, condition)
    -- Evaluate condition using scene's checkCondition method if available
    local conditionMet = false

    if self.checkCondition then
        -- Use scene-specific condition checking
        conditionMet = self:checkCondition(condition)
    else
        -- Fallback to basic evaluation
        if type(condition) == "function" then
            conditionMet = condition()
        elseif type(condition) == "boolean" then
            conditionMet = condition
        else
            conditionMet = (condition ~= nil and condition ~= false)
        end
    end

    if conditionMet then
        self:changeObjectState(objectName, newState)
    else
        local env = self._env or {}
        local objects = env.objects or {}
        local od = objects[objectName]
        local default = od and od.defaultState
        if default then
            self:changeObjectState(objectName, default)
        end
    end
end

function M.methods:showChoice(options)
    local env = self._env or {}
    local dialogueText = env.dialogueText
    local state = env.state or {}
    state.isChoiceActive = true

    if dialogueText then dialogueText.text = "What will you do?" end

    -- clear previous group
    if state.choiceGroup then
        pcall(function() state.choiceGroup:removeSelf() end)
        state.choiceGroup = nil
    end

    local choiceGroup = display.newGroup()
    if self.view then self.view:insert(choiceGroup) end
    state.choiceGroup = choiceGroup

    for i, option in ipairs(options or {}) do
        local choiceButton = widget.newButton({
            label = option,
            shape = "roundedRect",
            width = 350,
            height = 60,
            cornerRadius = 8,
            fillColor = { default={0.3,0.3,0.4,1}, over={0.4,0.4,0.5,1} },
            labelColor = { default={1,1,1}, over={0.8,0.8,0.8} },
            onRelease = function() self:handleChoice(i, option) end
        })
        choiceButton.x = display.contentCenterX
        choiceButton.y = 400 + (i * 80)
        choiceGroup:insert(choiceButton)
    end
end

function M.methods:handleChoice(choiceIndex, choiceText)
    local env = self._env or {}
    local state = env.state or {}
    if not state.isChoiceActive then return end
    state.isChoiceActive = false

    if state.choiceGroup then
        pcall(function() state.choiceGroup:removeSelf() end)
        state.choiceGroup = nil
    end

    self:showDialogue("You chose: " .. tostring(choiceText))

    if type(gameData) == "table" then
        gameData.playerChoice = choiceIndex
    else
        _G.gameData = _G.gameData or {}
        _G.gameData.playerChoice = choiceIndex
    end

    timer.performWithDelay(2000, function()
        if self.transitionToNextScene then self:transitionToNextScene() end
    end)
end
-- (Removed duplicate function-style helpers; use methods via metatable)

-- Generic condition/action registry methods
function M.methods:setCondition(key, value)
    _G.gameData = _G.gameData or {}
    _G.gameData[key] = value
    print("Set condition: " .. key .. " = " .. tostring(value))
end

function M.methods:getCondition(key)
    return _G.gameData and _G.gameData[key]
end

function M.methods:checkCondition(condition)
    if type(condition) == "function" then
        return condition()
    elseif type(condition) == "boolean" then
        return condition
    elseif type(condition) == "string" then
        -- Look up in scene-specific condition registry
        local env = self._env or {}
        local conditions = env.conditions or {}
        local conditionFunc = conditions[condition]
        if conditionFunc then
            return conditionFunc()
        else
            print("Warning: Condition '" .. condition .. "' not found in registry!")
            return false
        end
    end
    return false
end

function M.methods:executeAction(actionName)
    if type(actionName) == "function" then
        -- Fallback: allow inline functions for backward compatibility
        actionName()
    elseif type(actionName) == "string" then
        -- Look up in scene-specific action registry
        local env = self._env or {}
        local actions = env.actions or {}
        local actionFunc = actions[actionName]
        if actionFunc then
            actionFunc()
        else
            print("Warning: Action '" .. actionName .. "' not found in registry!")
        end
    else
        print("Warning: Invalid action type:", type(actionName))
    end
end

function M.methods:changeEmotion(character, state)
    local env = self._env or {}
    local characterGroup = env.characterGroup
    local objects = env.objects or {}

    -- Generic implementation for any character
    local charObj = objects[character]
    if charObj then
        -- Remove old image if it exists
        if charObj.image and charObj.image.removeSelf then
            pcall(function() charObj.image:removeSelf() end)
        end

        -- Get the state image path
        local stateImage = charObj.states and charObj.states[state]
        if stateImage then
            -- Create new image with the emotion state
            local width = charObj.width or 300
            local height = charObj.height or 500
            local newImage = display.newImageRect(characterGroup, stateImage, width, height)
            newImage.x = charObj.x or display.contentCenterX
            newImage.y = charObj.y or display.contentCenterY

            -- Update the object registry
            charObj.image = newImage
            -- Also update env reference if it exists (for backward compatibility)
            if env[character] then
                env[character] = newImage
            end

            -- Fade in effect
            newImage.alpha = 0
            transition.fadeIn(newImage, { time = 500 })

            print("Changed " .. character .. " emotion to: " .. state)
        else
            print("Warning: State '" .. state .. "' not found for " .. character)
        end
    else
        print("Warning: Character '" .. character .. "' not found in objects registry!")
    end
end

-- Determine player's choice from global gameData (or _G fallback)
local function getPlayerChoice()
    if type(gameData) == "table" and gameData.playerChoice ~= nil then
        return gameData.playerChoice
    end
    if _G.gameData and _G.gameData.playerChoice ~= nil then
        return _G.gameData.playerChoice
    end
    return nil
end

-- Go to a scene based on player's choice using the provided mapping.
-- mapping: table like { [1] = "sceneA", [2] = "sceneB", default = "sceneC" }
-- options: composer options (e.g., { effect = "fade", time = 1000 })
function M.gotoSceneByChoice(mapping, options)
    local choice = getPlayerChoice()
    local nextScene = (choice and mapping[choice]) or mapping.default
    if not nextScene then return end
    composer.gotoScene(nextScene, options or { effect = "fade", time = 800 })
end

return M
