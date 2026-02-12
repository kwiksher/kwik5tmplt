-- Narration Action (Cabin Scene)
-- Uses base narration action with cabin-specific texts

local BaseNarrationAction = require("actions.base_narration_action")

-- Narration text content for cabin scene
local narrationTexts = {
    cabin_exterior = "The cabin stands before you, weathered and silent. A faint glow seeps through cracks in the door.",
    cabin_interior = "Inside, dust motes dance in shafts of light. The air smells of old wood and forgotten things.",
    key_discovery = "Something metallic glints in the shadows...",
    search_near_door = "You search near the doorstep. Something metallic catches your eye beneath a loose stone...",
    search_room = "You carefully search the room, examining every corner. Your foot presses on a floorboard that creaks differently from the others...",
    trapped_in_cabin = "The door slams shut behind you with a thunderous crash. You're trapped inside the cabin!",
}

print("DEBUG: Creating cabin narration module with texts: " .. tostring(narrationTexts))

-- Create and return module instance (not the base class itself)
local module = BaseNarrationAction.new(narrationTexts)

print("DEBUG: Cabin narration module created")
print("DEBUG: Module type: " .. type(module))
print("DEBUG: Module.execute exists: " .. tostring(module.execute ~= nil))
print("DEBUG: Module.initialize exists: " .. tostring(module.initialize ~= nil))
print("DEBUG: Module.ACTIONS count: " .. tostring(module.ACTIONS and #module.ACTIONS or "nil"))

return module
