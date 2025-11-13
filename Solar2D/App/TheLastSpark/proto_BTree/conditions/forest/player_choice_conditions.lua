-- Player Choice Conditions Module
-- Checks if player has made specific choices (fight, calm, retreat)

local M = {}

-- Shared state for player choice
local playerChoice = nil

-- Reset choice (call this before presenting choice to player)
function M.resetChoice()
    playerChoice = nil
end

-- Set player choice (call this when player clicks a choice button)
function M.setChoice(choice)
    playerChoice = choice
    print("Player choice set to: " .. tostring(choice))
end

-- Get current choice
function M.getChoice()
    return playerChoice
end

-- Condition: Has player chosen to fight?
function M.checkFight()
    return playerChoice == "fight"
end

-- Condition: Has player chosen to calm the wolf?
function M.checkCalm()
    return playerChoice == "calm"
end

-- Condition: Has player chosen to retreat?
function M.checkRetreat()
    return playerChoice == "retreat"
end

return M
