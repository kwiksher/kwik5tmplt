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
        if step.object then
            self:changeObjectState(step.object, step.state)
        end
        if step.objects then
            for i, objName in ipairs(step.objects) do
                self:changeObjectState(objName, step.state)
            end
        end
        self:executeSceneStep(index + 1)

    elseif step.type == "object_state_conditional" then
        if step.object then
            self:changeObjectStateConditional(step.object, step.state, step.condition)
        end
        if step.objects then
            for i, objName in ipairs(step.objects) do
                self:changeObjectStateConditional(objName, step.state, step.condition)
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

-- Generic show for objects registered in env.objects: just reveal if exists
function M.methods:showObject(name)
    local env = self._env or {}
    local objects = env.objects or {}
    local od = objects[name]
    if od and od.image then
        od.image.isVisible = true
    end
end

-- Change object visual state based on registry in env.objects
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

    -- Optional special effects
    if newState == "broken" or newState == "shattered" then
        transition.to(objectData.image, { time = 300, rotation = 5, transition = easing.continuousLoop })
        timer.performWithDelay(300, function() objectData.image.rotation = 0 end)
    end
    if newState == "glowing" or newState == "pulsing" then
        transition.to(objectData.image, { time = 800, xScale = 1.1, yScale = 1.1, alpha = 0.8, transition = easing.continuousLoop })
    end

    if onComplete then
        timer.performWithDelay(600, onComplete)
    end
end

function M.methods:changeObjectStateConditional(objectName, newState, condition)
    if condition then
        self:changeObjectState(objectName, newState)
    else
        -- If a default state is defined, fall back to it; otherwise no-op
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
