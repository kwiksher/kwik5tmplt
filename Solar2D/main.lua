local env = require("env")


env.book = "BTree_test"
--env.goPage = "animation"
--env.goPage = "button"
env.goPage = "narration"


-- env.book = "book"
-- env.goPage = "landscape"

--env.book = "animation"
--env.goPage = "linear"

-- env.book = "interaction"
-- env.goPage = "canvas"

-- env.book = "particles"
-- env.goPage = "air_stars"

-- env.book = "LULU" -- "book"
-- env.goPage = "LULU_Sitting_With_A_CAT_Refine"

-- env.book = "snowMan"
-- env.goPage = "page1"

--env.book = "TheLastSpark"
-- env.goPage = "forest"
--env.goPage = "cabin"

--
--env.mode = "development"
-- env.mode = "production"

env.mode = "debug" -- need kwik5-plugin src from kwiksher's repo
--env.mode = "behaviorTree"

--
if env.mode == "development" or env.mode == "debug" then
  env.props = {
    name = env.book,
    editor = true,
    gotoPage = env.goPage,
    language = "", -- empty string "" is for a single language project
    position = {x = 0, y = 0},
    gotoLastBook = true,
    unitTest = false,
    httpServer = false,
    scale      = 0.25,
    showPageName = true,
    turnOffNativeVideo = true
  }
elseif env.mode == "production" then
  env.props = {
    name = env.book,
    editor = false,
    gotoPage = env.goPage,
    language = "", -- empty string "" is for a single language project
    position = {x = 0, y = 0},
    gotoLastBook = false,
    unitTest = false,
    httpServer = false,
    showPageName = false,
    turnOffNativeVideo = false
  }
elseif env.mode == "behaviorTree" then

  require("custom.components.myComponent")

  local resourcePath = system.pathForFile("", system.ResourceDirectory)

--  local appPath = "/App/TheLastSpark/behaviorTree"
  local appPath = "/App/BTree_test/behaviorTree"

  package.path = resourcePath .. appPath.."/?.lua;" .. resourcePath .. appPath.."/?/?.lua;"..package.path

    -- Require Composer for scene management
  local composer = require("composer")

  -- Start with the forest scene
  -- composer.gotoScene("views.forest.forestScene")
  -- composer.gotoScene("views.cabin.cabinScene")
  composer.gotoScene("views.animation.animationScene")


  --Start automated test after scene loads
  -- timer.performWithDelay(1000, function()
  --     print("\n=== Starting Automated Cabin Test (Jump to Choices) ===\n")
  --     local cabinTest = require("tests.cabinSceneTest")
  --     cabinTest.start()
  -- end)
  return
end
--
--
system.setTapDelay(0.2)
--
--
if env.setPlugin(env.mode)  then
  local kwik = require("kwiksher.kwik")
  --
  --display.setDefault( "background", 0.2, 0.2, 0.2, 0.1 )
  kwik.useGradientBackground()
  --

  -- -- Key event listener for Alt+P to switch to production mode
  -- local function onKeyEvent(event)
  --   if event.phase == "down" then
  --     if event.keyName == "p" and event.isAltDown then
  --       env.props.editor = false
  --       env.props.showPageName = false
  --       print("Mode changed to production - restarting...")
  --         Runtime:dispatchEvent{name="changeThisMug", appName=env.props.name, gotoPage=env.props.goPage, editor = false }
  --       return true
  --     end
  --   end
  --   return false
  -- end

  -- Runtime:addEventListener("key", onKeyEvent)

  --[[
    if kwik.restore() then
      native.showAlert("kwik", "restored comment it out kwik.restore()")
      return
    end
  --]]
  --

  kwik.setCustomModule(
    "custom",
    {
      commands = {"myEvent"},
      components = {
        -- "align",
        "myComponent",
        "thumbnailNavigation",
        "index"
        -- "keyboardNavigation",
      }
    }
  )
  --
  kwik.bootstrap(env.props)
  --
end

