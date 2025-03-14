local kwik = require "kwik"

system.setTapDelay(0.2)
--
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  local lldebugger = loadfile(os.getenv("LOCAL_LUA_DEBUGGER_FILEPATH"))()
  lldebugger.start()
end

-- kwik.restore()
-- kwik.autoUpdate()

display.setDefault( "background", 0.2, 0.2, 0.2, 0.1 )
-- kwik.useGradientBackground()

kwik.setCustomModule(
  "custom",
  {
    commands = {"myEvent"},
    components = {
      -- "align",
      "myComponent",
      "thumbnailNavigation",
      "index",
      -- "keyboardNavigation",
    }
  }
)

kwik.bootstrap {
  name = "book",
  editor = false,
  goPage = "landscape",
  language = "", -- empty string "" is for a single language project
  position = {x = 0, y = 0},
  gotoLastBook = false,
  unitTest = false,
  httpServer = false,
  showPageName = false
}
