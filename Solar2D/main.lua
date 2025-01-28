require("components.common.myComponent")
system.setTapDelay( 0.2 )
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
  name="interaction",
  editing = true,
  goPage = "button",
  language = "en",
  position = {x=0, y=0},
  common = common} -- scenes.index

-- for product release
-- require("controller.index").bootstrap({name="interaction", edting = false, goPage = "button", position = {x=0, y=0}, common = common}) -- scenes.index
