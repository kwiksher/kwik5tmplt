--require("controller.index").bootstrap({name="book", sceneIndex = 1, position = {x=0, y=0}}) -- scenes.index

local restore = false
-- restore = true
if restore then
  os.execute("cd " .. system.pathForFile("../", system.ResourceDirectory) .. "; source undo_lua.command")
  return
end

NIL = setmetatable({},{__tostring=function() return "nil" end})

dump = function(t)
  local ret = ""
  for k, v in pairs(t.userdata) do
    ret = "   " ..k ..":" ..tostring(v)
  end
  return ret
end

if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  local lldebugger = loadfile(os.getenv("LOCAL_LUA_DEBUGGER_FILEPATH"))()
  lldebugger.start()
end

inspect = require("extlib.inspect")

local common = {
  commands = {"myEvent"},
  components = {
    -- "align",
    "myComponent",
    "thumbnailNavigation",
    "keyboardNavigation",
    "index" -- this loads editor!
  }
}

require("controller.index").bootstrap({name="book", sceneIndex = 1, position = {x=0, y=0}, common = common}) -- scenes.index

