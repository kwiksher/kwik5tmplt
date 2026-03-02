# Handoff: Physics Joint Anchors vs Scale (App/physics)

## Confirmed Findings

- `Solar2D/main.lua` currently has `env.props.scale = 1`.
- If this is changed to `2`, then `kwikGlobal.scale`-based anchor formulas in joint files double their width/height offsets.
- Ellipse/circle objects should use `anchorX, anchorY = 0.5, 0.5` for center-based joint anchors.
- Rectangle objects with `anchorX, anchorY = 0, 0` are fine as long as joint anchors add `width/2` and `height/2` (or scaled equivalents).

---

## How Scale=2 Affects Joint Anchor Coordinates

For joints that compute center from top-left anchors using:

```lua
obj.x + obj.width * kwikGlobal.scale * 0.5
obj.y + obj.height * kwikGlobal.scale * 0.5
```

changing `env.props.scale` from 1 to 2 doubles the local offset term:

- scale=1: `obj.x + obj.width * 0.5`
- scale=2: `obj.x + obj.width * 1.0`

So anchor points move farther from the top-left anchor when scale is increased.

For joints using direct center-positioned objects (`anchor=0.5,0.5`) and `anchor_x = ellipse.x`, scale does not appear explicitly in the formula.

---

## Joint Anchor Report (All Joint Files in `App/physics/components/*/joints`)

| Joint file | Type | Anchor points passed to `physics.newJoint` | Uses `kwikGlobal.scale` |
|---|---|---|---|
| `components/distance/joints/rect_0_rect_1_distance.lua` | distance | `anchorA=(rect_0.x + rect_0.width*kwikGlobal.scale*0.5, rect_0.y + rect_0.height*kwikGlobal.scale*0.5)`, `anchorB=(rect_1.x + rect_1.width*kwikGlobal.scale*0.5, rect_1.y + rect_1.height*kwikGlobal.scale*0.5)` | Yes |
| `components/friction/joints/rect_0_rect_1_friction.lua` | friction | `anchor=(rect_1.x + rect_1.width*kwikGlobal.scale*0.5, rect_1.y + rect_1.height*kwikGlobal.scale*0.5)` | Yes |
| `components/piston/joints/rect_0_rect_1_piston.lua` | piston | `anchor=(rect_1.x + rect_1.width*kwikGlobal.scale*0.5, rect_1.y + rect_1.height*kwikGlobal.scale*0.5)` | Yes |
| `components/pivot/joints/rect_0_rect_1_pivot.lua` | pivot | `anchor=(rect_0.x + rect_0.width*kwikGlobal.scale*0.5, rect_0.y + rect_0.height*kwikGlobal.scale*0.5)` | Yes |
| `components/pulley/joints/rect_0_rect_1_pulley.lua` | pulley | `groundA=(rect_0.x + rect_0.width*kwikGlobal.scale*0.5, rect_0.y + rect_0.height*kwikGlobal.scale*0.5 - 100)`, `groundB=(rect_1.x + rect_1.width*kwikGlobal.scale*0.5, rect_0.y + rect_0.height*kwikGlobal.scale*0.5 - 100)`, `bodyA=(rect_0.x + rect_0.width*kwikGlobal.scale*0.5, rect_0.y + rect_0.height*kwikGlobal.scale*0.5)`, `bodyB=(rect_1.x + rect_1.width*kwikGlobal.scale*0.5, rect_1.y + rect_1.height*kwikGlobal.scale*0.5)` | Yes |
| `components/rope/joints/rect_0_rect_1_rope.lua` | rope | `offsetA=(25*kwikGlobal.scale, 25*kwikGlobal.scale)`, `offsetB=(25*kwikGlobal.scale, 25*kwikGlobal.scale)` | Yes |
| `components/touch/joints/rect_0_touch.lua` | touch | `anchor=(rect_0.x + rect_0.width*kwikGlobal.scale*0.5, rect_0.y + rect_0.height*kwikGlobal.scale*0.5)` | Yes |
| `components/weld/joints/rect_0_rect_1_weld.lua` | weld | `anchor=(rect_0.x + rect_0.width*kwikGlobal.scale*0.5, rect_0.y + rect_0.height*kwikGlobal.scale*0.5)` | Yes |
| `components/wheel/joints/rect_0_ellipse_0_wheel.lua` | wheel | `anchor=(ellipse_0.x, ellipse_0.y)` | No (direct) |
| `components/wheel/joints/rect_0_ellipse_1_wheel.lua` | wheel | `anchor=(ellipse_1.x, ellipse_1.y)` | No (direct) |
| `components/gear/joints/rect_0_gearL_pivot.lua` | pivot | `anchor=(gearL.x, gearL.y)` | No (direct) |
| `components/gear/joints/rect_0_gearR_pivot.lua` | pivot | `anchor=(gearR.x, gearR.y)` | No (direct) |
| `components/gear/joints/rect_0_rect_1_piston.lua` | piston | `anchor=(rect_1.x + rect_1.width/2, rect_1.y + rect_1.height/2)` | No |
| `components/gear/joints/gearL_gearR_gear.lua` | gear | no anchor coordinates (links two existing joints: `rect_0_gearL_pivot`, `rect_0_gearR_pivot`) | No |
| `components/gear/joints/gearR_rect_1_gear.lua` | gear | no anchor coordinates (links two existing joints: `rect_0_gearR_pivot`, `rect_0_rect_1_piston`) | No |

---

## Anchor Settings of Referenced Objects (Wheel + Gear)

| Object file | Shape | anchorX, anchorY |
|---|---|---|
| `components/wheel/layers/rect_0.lua` | rectangle | `0, 0` |
| `components/wheel/layers/ellipse_0.lua` | ellipse/circle | `0.5, 0.5` |
| `components/wheel/layers/ellipse_1.lua` | ellipse/circle | `0.5, 0.5` |
| `components/gear/layers/rect_0.lua` | rectangle | `0, 0` |
| `components/gear/layers/rect_1.lua` | rectangle | `0, 0` |
| `components/gear/layers/gearL.lua` | ellipse/circle | `0.5, 0.5` |
| `components/gear/layers/gearR.lua` | ellipse/circle | `0.5, 0.5` |

---

## Recommendation

- Keep ellipses/circles at `anchorX, anchorY = 0.5, 0.5` (recommended).
- Avoid `anchor=0,0` for circles when using center-based wheel/pivot anchors.
- Rectangles with `anchor=0,0` are valid and already handled correctly by explicit center offsets in joint formulas.
