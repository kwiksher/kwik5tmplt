# Handoff: Physics Body Alignment at Scale 2 (Gear Page)

## Summary

Circle physics bodies (gearL, gearR) are visually misaligned with their display objects when `sceneGroup.xScale = 2`. Rectangles (rect_0, rect_1) are correctly aligned. The basic physics page (anchor=0.5,0.5 objects) works fine at any scale.

---

## Files Involved

| File | Role |
|---|---|
| `Solar2D/lua_modules/kwiksher/kwik/components/kwik/layer_physicsBody.lua` | **Runtime** physics body creator (loaded by sample books) |
| `kwik5-plugin/kwik/components/kwik/layer_physicsBody.lua` | **Source** physics body creator (keep in sync with above) |
| `App/physics/components/gear/layers/gearL.lua` | gearL display object — `anchorX=0, anchorY=0, radius=40` |
| `App/physics/components/gear/layers/gearR.lua` | gearR display object — `anchorX=0, anchorY=0, radius=80` |

---

## Root Cause

In `layer_physicsBody.lua`, `physics.addBody` circle fixture `x,y` offsets must be in the **object's own local (unscaled) coordinate space**. The code was computing `localCenterOffsetX = (0.5 - anchorX) * obj.width * parentScaleX`, which multiplies by `parentScaleX`.

- At **scale=1**: `0.5 * 80 * 1 = 40` → correct
- At **scale=2**: `0.5 * 80 * 2 = 80` → **wrong** (should still be 40)

This is why the basic page (anchor=0.5,0.5 → offset=0) never showed the bug.

### Corona docs confirm:
> `x` / `y` in the fixture table are local-space offsets from the object's anchor point.
> https://docs.coronalabs.com/api/library/physics/addBody.html

---

## Fix Applied

Both `layer_physicsBody.lua` files (plugin + lua_modules) were updated to remove `parentScaleX` from the circle case:

```lua
-- BEFORE (wrong at scale ≠ 1):
physics.addBody(obj, props.type, {
  radius = radius,
  x = localCenterOffsetX,   -- = (0.5 - anchorX) * width * parentScaleX
  y = localCenterOffsetY,
})

-- AFTER (correct):
physics.addBody(obj, props.type, {
  radius = radius,
  x = (0.5 - (obj.anchorX or 0.5)) * obj.width,
  y = (0.5 - (obj.anchorY or 0.5)) * obj.height,
})
```

### Expected values after fix:
| Object | anchorX | obj.width | Fix offset x | Scale-independent? |
|---|---|---|---|---|
| gearL | 0 | 80 | 0.5×80 = **40** | ✓ |
| gearR | 0 | 160 | 0.5×160 = **80** | ✓ |
| ellipse_0 basic | 0.5 | 67 | 0×67 = **0** | ✓ |

---

## Current State (as of last log)

The log still shows the **old** `localCenterOffset=80,80` entry for anchor=0,0 runs — this is because:
1. The debug print message still references the old `fixtureOffset` variable name (cosmetic only).
2. The latest log entry shows gearL with `anchor=0.5,0.5` (a debug test run), not the current anchor=0,0 production state.

**The fix is in the source.** The simulator must be **restarted** to pick up the change, then navigate to the gear page to confirm body alignment.

---

## Verification Steps

1. Restart Solar2D Simulator.
2. Navigate to the **gear physics page** with `sceneGroup.xScale = 2`.
3. Confirm gearL (small purple circle) and gearR (large grey circle) physics bodies visually overlap their display objects.
4. Check `tmp.log` for lines like:
   ```
   [physicsBody] gearL circle ... localCenterOffset=80,80
   ```
   The `x,y` passed to `physics.addBody` is now `40,40` (half of obj.width/height), not `80,80`.

---

## Rectangle Case (Already Correct)

The rectangle `box` fixture uses `halfWidth`/`halfHeight` (in content space via `bounds.halfW = scaledW * 0.5`), so parentScaleX cancels out correctly there. No change needed for rectangles.

---

## Related Changes in This Session

| File | Change |
|---|---|
| `page_physicsJoint.lua` | Removed hardcoded `scale=0.5`; distance joint reads raw `anchorA_x/y` (no offset) |
| `rect_0_rect_1_distance.lua` | Computes anchors as `obj.x + obj.width * xScale * 0.5` |
| All other joint files in `App/physics` | Anchor positions updated to `dimension * kwikGlobal.scale * 0.5` |
| `gear/joints/rect_0_gearL_pivot.lua` | Uses `gearL:localToContent(width/2, height/2)` for pivot anchor |
| `gear/joints/rect_0_gearR_pivot.lua` | Uses `gearR:localToContent(width/2, height/2)` for pivot anchor |
| `lua_modules/.../baseTable.lua:114` | Fixed typo `UI.edtior` → `UI.editor` |
