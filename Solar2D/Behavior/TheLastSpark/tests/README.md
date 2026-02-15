# TheLastSpark Scene Tests

Automated scene tests for `Behavior/TheLastSpark`.

## Files

- `Behavior/TheLastSpark/tests/cabinSceneTest.lua`
- `Behavior/TheLastSpark/tests/forestSceneTest.lua`

## Cabin Test

### Purpose

`cabinSceneTest.lua` sets scene state to fast-forward toward the trapped branch and auto-advances until `[ui show_choices]` appears.

### Run

```lua
composer.gotoScene("views.cabin.cabinScene", { time = 300, effect = "fade" })

timer.performWithDelay(1000, function()
    local cabinTest = require("Behavior.TheLastSpark.tests.cabinSceneTest")
    cabinTest.start()
end)
```

## Forest Test

### Purpose

`forestSceneTest.lua` auto-advances the forest flow and stops when `[ui show_choices]` appears.

### Run

```lua
composer.gotoScene("views.forest.forestScene", { time = 300, effect = "fade" })

timer.performWithDelay(1000, function()
    local forestTest = require("Behavior.TheLastSpark.tests.forestSceneTest")
    forestTest.start()
end)
```

## Input Simulation Notes

Both tests press the Next button using event simulation first:

1. `touch` event (`began` + `ended`)
2. fallback touch on internal widget view
3. fallback `tap` event

This matches current runtime behavior where Next is created through `widget.newButton(...)` and scene progression is handled by its `onRelease` callback.

## Related Runtime Files

- `Behavior/TheLastSpark/views/cabin/cabinScene.lua`
- `Behavior/TheLastSpark/views/forest/forestScene.lua`
- `Behavior/TheLastSpark/actions/cabin/iron_key_actions.lua`
- `Behavior/TheLastSpark/conditions/cabin/has_iron_key.lua`
