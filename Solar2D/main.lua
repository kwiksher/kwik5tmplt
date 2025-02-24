require("components.common.myComponent")
system.setTapDelay( 0.2 )
-- display.setDefault( "background", 0.8, 0.8, 0.8 )
-- display.setDefault( "background", 1, 1, 1 )

-- Create a gradient effect using rectangles Good for emitting particles!
--[[
  local numRectangles = 100
  local rectHeight = display.contentHeight / numRectangles
  for i = 1, numRectangles do
    local alpha = 1 - (i / numRectangles) -- Fade from opaque to transparent
    local rect = display.newRect(display.contentCenterX, rectHeight * (i - 0.5), display.contentWidth, rectHeight)
    rect:setFillColor(1, 1, 1, alpha) -- White to transparent gradient
    rect:toBack()
  end
--]]

--
-- require("installer.index").init()
--
local restore = false
--restore = true
if restore then
  os.execute("cd " .. system.pathForFile("../", system.ResourceDirectory) .. "; source undo_lua.command")
  return
end

if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  local lldebugger = loadfile(os.getenv("LOCAL_LUA_DEBUGGER_FILEPATH"))()
  lldebugger.start()
end

local common = {
  commands = {"myEvent"},
  components = {
    -- "align",
    "thumbnailNavigation",
    "index" -- this loads editor!
    -- "keyboardNavigation",
  }
}

require("controller.index").bootstrap{
  name="replacement",
  editing = true,
  goPage = "sprite",
  language = "en",
  position = {x=0, y=0},
  common = common} -- scenes.index

-- for product release
-- require("controller.index").bootstrap({name="interaction", edting = false, goPage = "button", position = {x=0, y=0}, common = common}) -- scenes.index
