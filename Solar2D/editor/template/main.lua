--require("controller.index").bootstrap({name="{{book}}", sceneIndex = {{sceneIndex}}, position = {x=0, y=0}}) -- scenes.index

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
    "index" -- this loads editor!
  }
}

require("controller.index").bootstrap({name="{{book}}", sceneIndex = {{sceneIndex}}, position = {x=0, y=0}, common = common}) -- scenes.index

