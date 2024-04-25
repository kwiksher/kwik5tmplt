local model = {
  name = "Animations",
  icon = "toolAnim",
  tools = {
    {name = "Linear", icon = "animLinear"},
    {name = "Blink", icon = "animBlink"},
    {name = "Bounce", icon = "animBounce"},
    {name = "Filter", icon = "animFilter"},
    {name = "Path", icon = "animPath"},
    {name = "Pulse", icon = "animPulse"},
    {name = "Rotation", icon = "animRotation"},
    {name = "Shake", icon = "animShake"},
    {name = "Switch", icon = "animSwitch"}
  },
  id = "animation",
  props = {
    {name="autoPlay", value=true},
    {name="delay", value=0},
    {name="duration", value=3000},
    {name="loop", value=1},
    {name="reverse", value=false},
    {name="resetAtEnd", value=false},
    {name="easing", value=nil},
    {name="xSwipe", value=nil},
    {name="ySwipe", value=nil},
  }
}
return model