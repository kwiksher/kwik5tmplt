# Behavior Tree Code Generation Prompt Design

## Overview
This document defines a comprehensive prompt template for generating complete codebases from `.tree` files following the Behavior Tree architectural pattern observed in the Pacman example.

## Core Prompt Template

```
You are an expert game developer specializing in Behavior Tree architectures. Your task is to generate a complete codebase from a provided .tree file following a specific architectural pattern.

Analyze the provided .tree file and generate a complete implementation following this architecture:

1. **Main Entry Point** (`main.lua`):
   - Initialize the behavior tree system
   - Load and parse the .tree file
   - Set up the game loop
   - Manage the overall game state

2. **Behavior Tree Engine** (`btree.lua`):
   - Implement core node types: Selector, Sequence, Decorator, Condition, Action
   - Handle node execution and state management
   - Provide tree traversal and execution logic

3. **Models** (in `models/` directory):
   - Create data structures representing game entities
   - Implement state management for each entity
   - Define properties and methods for entity behavior

4. **Views** (in `views/` directory):
   - Implement display logic for game entities
   - Handle rendering and visual updates
   - Connect to the underlying model data

5. **Actions** (in `actions/` directory):
   - Implement individual action nodes as separate files
   - Each action should be a self-contained module
   - Actions should modify model state and return success/failure

6. **Conditions** (in `conditions/` directory):
   - Implement condition nodes as separate files
   - Each condition should evaluate a specific state
   - Conditions should return true/false without modifying state

7. **Controllers** (in `actions/action_controller.lua` and `conditions/condition_controller.lua`):
   - Manage registration and execution of actions/conditions
   - Provide lookup mechanisms for named nodes
   - Handle parameter passing to nodes

8. **Utilities** (in `utils/` directory):
   - File loading and parsing utilities
   - Helper functions for common operations
   - Configuration and setup utilities

Follow these specific patterns:
- Use Lua as the implementation language
- Follow Corona SDK/Solar2D conventions
- Implement modular, loosely-coupled components
- Use functional programming patterns where appropriate
- Ensure all generated code follows consistent naming conventions
- Include proper error handling and validation

.tree File Syntax Reference:
- Lines starting with # are comments
- Indentation represents tree hierarchy
- Node types: Selector, Sequence, Action, Condition
- Actions and Conditions are leaf nodes
- Composite nodes (Selector, Sequence) have child nodes
- Parameters are specified in parentheses after node names

Generate the complete codebase with proper directory structure and file organization.
```

## Example Usage

For a .tree file like:
```
Selector (root)
  Sequence (find_food)
    Condition (hungry)
    Action (search_food)
    Action (eat_food)
  Sequence (explore)
    Action (wander)
    Condition (bored)
```

The prompt would generate:
1. A main.lua that initializes and runs this tree
2. A btree.lua implementing Selector and Sequence nodes
3. Models for any entities involved
4. Views for displaying entities
5. Individual action files: search_food.lua, eat_food.lua, wander.lua
6. Individual condition files: hungry.lua, bored.lua
7. Controller files to manage actions and conditions
8. Utility functions for tree parsing

## Architecture Patterns to Follow

### 1. Separation of Concerns
- Models handle data and state
- Views handle display and rendering
- Controllers manage logic flow
- Actions implement behaviors
- Conditions evaluate states

### 2. Modularity
- Each action/condition is a separate file
- Components can be reused across different trees
- Loose coupling between components

### 3. Behavior Tree Principles
- Leaf nodes (Actions/Conditions) do the actual work
- Composite nodes (Selector/Sequence) control flow
- Nodes return success, failure, or running states
- Trees are evaluated each frame/update cycle

### 4. Naming Conventions
- Files: lowercase with underscores (e.g., eat_food.lua)
- Functions: camelCase (e.g., executeAction)
- Variables: descriptive and consistent

## Implementation Details

### Directory Structure
```
project/
├── main.lua
├── btree.lua
├── models/
│   ├── entity1.lua
│   └── entity2.lua
├── views/
│   ├── entity1_display.lua
│   └── entity2_display.lua
├── actions/
│   ├── action1.lua
│   ├── action2.lua
│   └── action_controller.lua
├── conditions/
│   ├── condition1.lua
│   ├── condition2.lua
│   └── condition_controller.lua
└── utils/
    └── file_loader.lua
```

### Node Implementation Patterns

#### Actions
```lua
-- actions/example_action.lua
local M = {}

function M.execute(params)
  -- Implementation here
  -- Modify model state
  -- Return status: "success", "failure", or "running"
end

return M
```

#### Conditions
```lua
-- conditions/example_condition.lua
local M = {}

function M.evaluate(params)
  -- Evaluation logic here
  -- Return boolean
end

return M
```

### Controllers
```lua
-- actions/action_controller.lua
local M = {}

local actions = {
  ["action_name"] = require("actions.action_name"),
  -- ... other actions
}

function M.execute(actionName, params)
  local action = actions[actionName]
  if action then
    return action.execute(params)
  else
    error("Action not found: " .. actionName)
  end
end

return M
```

This prompt design ensures that when given a .tree file, the AI will generate a complete, well-structured codebase that follows the established architectural patterns while being tailored to the specific behavior tree defined in the input file.