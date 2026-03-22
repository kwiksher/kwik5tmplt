local env = require("env")


--env.book = "BTree_test"
--env.page = "animation"
--env.page = "button"
--env.page = "narration"

--env.book = "TheLastSpark"
--env.page = "forest"
--env.page = "cabin"

env.book = "book"
env.page = "landscape"

-- env.book = "animation"
-- env.page = "linear"
--env.page = "blink"
--env.page = "path"
-- env.page = "filter"

-- env.book = "interaction"
-- env.page = "button"
-- env.page = "drag"
-- env.page = "pinch"
-- env.page = "canvas"
--env.page = "scroll_image"
-- env.page = "scroll_text"
-- env.page  = "swipe"

--env.book = "replacement"
--env.page = "counter"
-- env.page = "dynamicText"
-- env.page = "inputText"
-- env.page = "map"
-- env.page = "mask"
--env.page = "multiplier"
--env.page = "particles"
-- env.page = "snowman"
--env.page = "sprite"
-- env.page = "sync"
-- env.page = "text"
-- env.page = "vector"
--env.page = "video"
-- env.page = "web"

-- env.book = "particles"
-- env.page = "air_stars"

-- env.book = "LULU" -- "book"
-- env.page = "LULU_Sitting_With_A_CAT_Refine"

-- env.book = "snowMan"
-- env.page = "page1"

--env.book = "shape"
--env.page = "ellipse"

--env.book = "physics"
--env.page = "basic"
-- env.page = "distance"
-- env.page = "friction"
-- env.page = "gear"
-- env.page = "piston"
-- env.page = "pivot"
-- env.page = "pulley"
-- env.page = "rope"
-- env.page = "touch"
-- env.page = "weld"
--env.page = "wheel"

-- env.book = "page"
-- env.page = "audio"
 -- env.page = "group"
 -- env.page = "timer"
--  env.page = "variable"

 -- env.book = "layer"
 -- env.page = "addCode" -- uiHandler.lua /tutorial/keyboard/
 -- env.page = "lang"
 -- env.page = "properties"
--

env.mode  = "development"
-- env.mode  = "debug"
-- env.mode = "production" -- need kwik5-plugin src from kwiksher's repo
-- env.mode = "behaviorTree"

--
if env.mode == "development" or env.mode == "debug" then
  env.props = {
    name = env.book,
    editor = true,
    gotoPage = env.page,
    language = "", -- empty string "" is for a single language project
    position = {x = 0, y = 0},
    gotoLastBook = false,
    unitTest = true,
    httpServer = false,
    scale      = 1,
    showPageName = true,
    turnOffNativeVideo = false
  }
elseif env.mode == "production" then
  env.props = {
    name = env.book,
    editor = false,
    gotoPage = env.page,
    language = "", -- empty string "" is for a single language project
    position = {x = 0, y = 0},
    gotoLastBook = false,
    unitTest = false,
    httpServer = false,
    scale      = 1,
    showPageName = false,
    turnOffNativeVideo = false
  }
elseif env.mode == "behaviorTree" then

  require("custom.components.myComponent")

  local resourcePath = system.pathForFile("", system.ResourceDirectory)
  local appPath = "/Behavior/" .. env.book
  local kwikPath = "/lua_modules/kwiksher/kwik"
  package.path = resourcePath .. appPath .. "/?.lua;" ..
                 resourcePath .. appPath .. "/?/?.lua;" ..
                 resourcePath .. kwikPath .. "/?.lua;" ..
                 resourcePath .. kwikPath .. "/?/?.lua;" ..
                 package.path

    -- Require Composer for scene management
  local composer = require("composer")

  -- Start with the selected behavior-tree scene
  local sceneModule = "Behavior."..env.book..".views."..env.page.."."..env.page.."Scene"
  local okScene, sceneOrErr = pcall(require, sceneModule)
  if not okScene then
    print("Failed to load scene module:", sceneModule)
    print(sceneOrErr)
    return
  end

  composer.gotoScene(sceneModule)

  --Start automated test after scene loads
  -- timer.performWithDelay(1000, function()
  --     print("\n=== Starting Automated Test (Jump to Choices) ===\n")
  --     local sceneTest = require("tests."..env.page.."SceneTest")
  --     sceneTest.start()
  -- end)
  return
end
--
--
system.setTapDelay(0.2)
--
--
if env.setPlugin(env.mode)  then
  if env.mode == "development" or env.mode == "debug" then
    local forceReloadModules = {
      "kwiksher.kwik.controller.ApplicationUI",
      "kwiksher.kwik.controller.scene",
      "kwiksher.kwik.controller.Application",
      "kwiksher.kwik.components.kwik.layer_image"
    }
    for i = 1, #forceReloadModules do
      package.loaded[forceReloadModules[i]] = nil
    end
  end
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
  --         Runtime:dispatchEvent{name="changeThisMug", appName=env.props.name, gotoPage=env.props.page, editor = false }
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

