# BTree Test - Simplified Behavior Tree Sample

This is a simplified behavior tree test application based on TheLastSpark sample. It demonstrates basic behavior tree concepts with two simple scenes.

## Structure

```
BTree_test/
├── main.lua                    # Entry point - starts with animation scene
├── config.lua                  # Solar2D configuration
├── build.settings              # Solar2D build settings
├── animation.tree              # Behavior tree for animation scene
├── button.tree                 # Behavior tree for button scene
├── actions/
│   ├── animation_actions.lua   # Animation action implementations
│   ├── animation_controller.lua# Animation action controller
│   ├── button_actions.lua      # Button action implementations
│   ├── button_controller.lua   # Button action controller
│   └── base_wait_action.lua    # Base wait action (from TheLastSpark)
├── utils/
│   ├── btree.lua              # Behavior tree processor (from TheLastSpark)
│   ├── common_helpers.lua     # Common helper functions (from TheLastSpark)
│   └── action_helper.lua      # Action helper utilities (from TheLastSpark)
└── views/
    ├── animationScene.lua     # Animation scene implementation
    ├── buttonScene.lua        # Button scene implementation
    ├── baseScene.lua          # Base scene class (from TheLastSpark)
    ├── display_manager.lua    # Display management (from TheLastSpark)
    └── display_base.lua       # Display base class (from TheLastSpark)
```

## Scenes

### Animation Scene (animation.tree)

**Behavior Tree:**
```
->
|    [animate star]
|    [wait for animation]
|    [goto button scene]
```

**What it does:**
1. **Star is created in the scene module** (views/animationScene.lua)
2. Animates the star moving linearly to the right side (2 seconds)
3. Waits for the animation to complete
4. Transitions to the button scene

### Button Scene (button.tree)

**Behavior Tree:**
```
->
|    ?
|    |    (button clicked)
|    |    [goto animation scene]
```

**What it does:**
1. **Button is created in the scene module** (views/buttonScene.lua)
2. **Uses a condition node** to check if button was clicked
3. When the condition is true (button clicked), executes goto action
4. **Immediately ticks the tree** when button is pressed
5. Transitions back to the animation scene

## Debug Flag

Both action implementations have a `DEBUG_ENABLED` flag:

- **When `true`**: Full implementations run (star animations, button interactions, scene transitions)
- **When `false`**: Only debug logs are printed, no actual visual changes occur

To toggle debug mode, edit these files:
- `actions/animation_actions.lua` - Line 11: `M.DEBUG_ENABLED = false`
- `actions/button_actions.lua` - Line 12: `M.DEBUG_ENABLED = false`

Set to `true` to enable full functionality.

## Action Implementations

### Animation Actions

Located in `actions/animation_actions.lua`:

1. **animate star** - Moves star from left to right using `transition.to()`
2. **wait for animation** - Returns `RUNNING` until animation completes, then `SUCCESS`
3. **goto button scene** - Uses `composer.gotoScene()` to transition

### Button Actions

Located in `actions/button_actions.lua`:

1. **goto animation scene** - Uses `composer.gotoScene()` to transition back

### Condition Implementations

Located in `conditions/button_conditions.lua`:

1. **button clicked** - Checks if `buttonPressed` flag is true

## Display Object Creation

### Star Creation

The star is created in [animationScene.lua](views/animationScene.lua) in the `create` event:
- Yellow polygon star shape
- Positioned at left side of screen
- Stored in `self.objs.star` for animation actions to use

### Button Creation

The button is created in [buttonScene.lua](views/buttonScene.lua) after the tree controller is initialized:
- Blue widget button labeled "Go to Animation"
- Positioned at center of screen
- **OnRelease handler** sets `buttonPressed` flag AND immediately ticks the behavior tree
- This allows the condition to be evaluated and action to execute without delay

## Behavior Tree Processing

The behavior trees are processed by `utils/btree.lua`:

1. Trees are loaded from `.tree` files using `common.loadBehaviorTree()`
2. The tree format uses:
   - `->` for sequence nodes (execute children in order)
   - `?` for fallback/selector nodes (execute until one succeeds)
   - `[action name]` for action nodes
   - `(condition)` for condition nodes
3. Action nodes call registered action controllers
4. The tree ticks repeatedly until completion or RUNNING status

## Running the Test

1. Open the project in Solar2D Simulator
2. The animation scene will start automatically
3. Watch the star animate from left to right
4. After animation completes, the button scene will appear
5. Click the button to return to the animation scene
6. The cycle repeats

## Console Output

With `DEBUG_ENABLED = false`, you'll see logs like:

```
=== Starting BTree Test Application ===
Starting with animation scene...
Animation Scene: Created successfullyand fallback/selector nodes
2. **Condition Nodes** - Using `(condition name)` syntax to check state
3. **Action Node Implementation** - Modular action handlers
4. **Tree Status Management** - SUCCESS, RUNNING, FAILED states
5. **Scene Transitions** - Using Solar2D Composer
6. **Animation Control** - Solar2D transitions
7. **User Input with Immediate Response** - Button clicks trigger immediate tree ticks
8. **Condition Evaluation** - Checking conditions before tree tick using `setConditionStatus()`
9. **Separation of Concerns** - Display objects created in views, behavior in actions/conditions
10ACTION] animate star
DEBUG: Would animate star from left to right over 2 seconds
[ACTION] wait for animation
Animation is complete, proceeding...
[ACTION] goto button scene
DEBUG: Would transition to button scene with fade effect
Tree status: 1
Behavior tree completed with status: 1
```

With `DEBUG_ENABLED = true`, you'll see the actual implementations running with full visual feedback.

## Key Concepts Demonstrated

1. **Behavior Tree Structure** - Sequential execution of actions
2. **Action Node Implementation** - Modular action handlers
3. **Tree Status Management** - SUCCESS, RUNNING, FAILED states
4. **Scene Transitions** - Using Solar2D Composer
5. **Animation Control** - Solar2D transitions
6. **User Input** - Button widget interactions
7. **Debug Mode** - Toggle between full implementation and debug logs

## Extending the Test

To add new behaviors:

1. Create new action functions in the action files
2. Register them in the `ACTIONS` table
3. Add new action nodes to the `.tree` files
4. Implement the logic with proper status returns (SUCCESS/RUNNING/FAILED)
