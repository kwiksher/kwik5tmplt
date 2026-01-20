# BTree Test - Behavior Tree Sample

A simplified Solar2D/Corona SDK project demonstrating behavior tree implementation with two interactive scenes.

## Overview

This project demonstrates a behavior tree system with:
- **Animation Scene**: Displays a counter and animates a yellow star moving from left to right
- **Button Scene**: Shows a button that returns to the animation scene when clicked

The scenes transition between each other using behavior trees defined in `.tree` files.

## Behavior Tree Files

### animation.tree

Controls the animation scene flow:

```tree
->
|    ?
|    |    ->
|    |    |    (scene first tick)
|    |    |    [increment counter]
|    |    ->
|    [animate star]
|    (star animation completed)
|    [goto buttonScene]
```

**Flow:**
1. **Optional counter increment**: Uses a fallback to increment scene display counter only on first tick
2. **Animate star**: Starts the star animation (skips if already in progress)
3. **Wait for completion**: Checks if star animation is complete
4. **Transition**: Goes to button scene when animation finishes

### button.tree

Controls the button scene flow:

```tree
->
|    (button clicked)
|    [goto animationScene]
```

**Flow:**
1. **Check button click**: Evaluates if button was pressed
2. **Transition**: Returns to animation scene when button is clicked

The tree continuously ticks until the button is clicked, creating a wait-for-input behavior.

## Behavior Tree Node Types

### Sequence Node (`->`)

A **sequence** node executes its children in order and requires **ALL** children to succeed.

- **Success**: When all children return SUCCESS
- **Failure**: When any child returns FAILED (stops execution)
- **Behavior**: Executes children left-to-right until one fails or all succeed

**Example from animation.tree:**
```tree
->
|    [animate star]
|    (star animation completed)
|    [goto buttonScene]
```
This sequence ensures: star animates → waits for completion → then transitions.

### Fallback/Selector Node (`?`)

A **fallback** (or selector) node tries children in order until one succeeds.

- **Success**: When any child returns SUCCESS (stops trying remaining children)
- **Failure**: When all children return FAILED
- **Behavior**: Tries children left-to-right until one succeeds

**Example from animation.tree:**
```tree
?
|    ->
|    |    (scene first tick)
|    |    [increment counter]
|    ->
```
This fallback provides optional behavior:
- First tick: Inner sequence succeeds → counter increments → fallback succeeds
- Later ticks: Inner sequence fails → empty sequence succeeds → fallback succeeds

The empty sequence (`->` with no children) always succeeds, making the fallback always succeed.

### Action Node (`[action name]`)

An **action** node executes a specific action and returns its result.

**Format:** `[action type what]` or `[action name]`

**Examples:**
- `[increment counter]` - Parsed as type="increment", what="counter"
- `[animate star]` - Parsed as type="animate", what="star"
- `[goto buttonScene]` - Parsed as type="goto", what="buttonScene"

**Routing:**
Actions are routed to appropriate modules via `simpleRouting` configuration:
- `increment` → animation module → executes "counter" action
- `animate` → animation module → executes "star" action
- `goto` → scene module → executes scene transition

### Condition Node (`(condition name)`)

A **condition** node evaluates a state and returns SUCCESS or FAILED (never RUNNING).

**Examples:**
- `(scene first tick)` - Returns SUCCESS only on first tree tick after scene shows
- `(star animation completed)` - Returns SUCCESS when star animation finishes
- `(button clicked)` - Returns SUCCESS when button is pressed

**Evaluation:**
Conditions are evaluated before each tree tick via `conditionController.evaluate()` and their status is set with `tree:setConditionStatus()`.

## Key Implementation Details

### Scene Display Counter

The counter increment demonstrates a "once per scene" action using behavior tree logic:

1. Scene "will" phase sets `sceneFirstTickDone = false`
2. Condition `(scene first tick)` checks this flag
3. First tick: condition succeeds → counter increments → flag set to true
4. Subsequent ticks: condition fails → inner sequence fails → empty fallback child succeeds

This is cleaner than checking the flag in action code - the tree structure handles the logic.

### Animation State Management

To prevent animation restart on every tick:

1. Scene "did" phase sets `animationInProgress = false`
2. `[animate star]` action checks this flag
3. If false: starts animation, sets flag to true
4. If true: returns SUCCESS immediately without restarting

The `animationComplete.star` flag is set in the animation's `onComplete` callback, which also triggers an immediate tree tick.

### Button State Management

Button pressed flag is cleared in scene "did" phase:

1. `buttonPressed = false` on scene show
2. Button click sets `buttonPressed = true` and ticks tree
3. Condition `(button clicked)` checks flag
4. Tree succeeds → transitions to animation scene

## Project File Structure

```
BTree_test/
├── main.lua                          # Entry point
├── config.lua                        # Solar2D configuration
├── build.settings                    # Solar2D build settings
├── animation.tree                    # Animation scene behavior tree
├── button.tree                       # Button scene behavior tree
├── actions/
│   ├── animation/
│   │   ├── animation_actions.lua     # Star animation & counter actions
│   │   └── animation_controller.lua  # Action routing & execution
│   ├── button/
│   │   ├── button_actions.lua        # Button actions (currently minimal)
│   │   └── button_controller.lua     # Button action controller
│   └── scene/
│       ├── scene_actions.lua         # Scene transition (goto) action
│       └── scene_controller.lua      # Scene action controller
├── conditions/
│   ├── animation/
│   │   └── animation_conditions.lua  # Animation conditions (first tick, completed)
│   └── button/
│       └── button_conditions.lua     # Button conditions (clicked)
├── utils/
│   ├── btree.lua                     # Behavior tree processor
│   ├── common_helpers.lua            # Common helper functions
│   └── action_helper.lua             # Action parsing utilities
└── views/
    ├── animationScene.lua            # Animation scene with tree controller
    ├── buttonScene.lua               # Button scene with tree controller
    ├── baseScene.lua                 # Base scene class
    ├── display_manager.lua           # Display management
    └── display_base.lua              # Display base class
```

## Node Type Reference

| Node Type | Symbol | Purpose | Success | Failure | Use Case |
|-----------|--------|---------|---------|---------|----------|
| **Sequence** | `->` | All children must succeed in order | All children succeed | Any child fails | Sequential actions |
| **Fallback** | `?` | Try until one succeeds | Any child succeeds | All children fail | Optional/fallback behavior |
| **Action** | `[name]` | Execute an action | Action returns SUCCESS | Action returns FAILED | Do something |
| **Condition** | `(name)` | Check state | Condition is true | Condition is false | Gate execution |

## Status Codes

Behavior tree nodes return one of three status codes:

- `bt.FAILED (0)` - Node failed, stop sequence or try next fallback child
- `bt.SUCCESS (1)` - Node succeeded, continue sequence or complete fallback
- `bt.RUNNING (2)` - Node still in progress, tick again (actions only)

Conditions always return SUCCESS or FAILED (never RUNNING).

## Running the Sample

1. Open in Solar2D Simulator
2. Animation scene shows with counter = 0 and animates the star
3. After animation completes, transitions to button scene
4. Click "Back to Animation" button
5. Returns to animation scene, counter = 1
6. Cycle repeats, counter increments each time

## Learning Points

This sample demonstrates:

1. **Tree Syntax**: How to structure sequences, fallbacks, actions, and conditions
2. **Action Routing**: Using `simpleRouting` to map action types to modules
3. **Condition-Based Logic**: Using tree structure for conditional behavior (counter increment)
4. **State Management**: Managing animation/button states across scene lifecycle
5. **Scene Integration**: How behavior trees control Solar2D Composer scenes

## Differences from TheLastSpark

This is a simplified version focusing on core concepts:

- **Simpler trees**: Two basic trees vs. complex multi-level trees
- **Basic actions**: Animation and scene transitions only
- **Condition gating**: Demonstrates using conditions to control action execution
- **State flags**: Simple boolean flags vs. complex state management
- **Direct implementation**: Less abstraction for easier learning

## Further Exploration

To extend this sample:

1. Add more complex animations with multiple objects
2. Implement parallel node (`||`) for simultaneous actions
3. Add decorators (repeat, invert, timeout)
4. Create more complex condition logic
5. Implement action interruption/cancellation
6. Add visual debugging of tree execution

---

Created as a learning resource for Solar2D behavior tree implementation.

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
