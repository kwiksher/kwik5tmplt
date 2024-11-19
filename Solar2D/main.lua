--require("controller.index").bootstrap({name="keyboard", sceneIndex = 1, position = {x=0, y=0}}) -- scenes.index

-- print("test")

-- require("installer.index").init()

require("components.common.myComponent")

local restore = false
-- restore = true
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
    "index"
  }
}

require("controller.index").bootstrap{
  name="book",
  editing = true,
  -- goPage = "landscape",
  goPage = "portrait",
  position = {x=0, y=0},
  common = common} -- scenes.index

