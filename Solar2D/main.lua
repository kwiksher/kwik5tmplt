local env = require("env")


--env.book = "BTree_test"
--env.goPage = "animation"
--env.goPage = "button"
--env.goPage = "narration"


--env.book = "TheLastSpark"
--env.goPage = "forest"
--env.goPage = "cabin"


env.book = "book"
env.goPage = "landscape"

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

--env.book = "shape"
--env.goPage = "ellipse"


env.book = "physics"
-- env.goPage = "basic"
-- env.goPage = "distance"
-- env.goPage = "friction"
-- env.goPage = "gear"
-- env.goPage = "piston"
-- env.goPage = "pivot"
-- env.goPage = "pulley"
-- env.goPage = "rope"
-- env.goPage = "touch"
-- env.goPage = "weld"
env.goPage = "wheel"

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
    gotoPage = env.goPage,
    language = "", -- empty string "" is for a single language project
    position = {x = 0, y = 0},
    gotoLastBook = true,
    unitTest = true,
    httpServer = false,
    scale      = 1,
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
  local sceneModule = "Behavior."..env.book..".views."..env.goPage.."."..env.goPage.."Scene"
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
  --     local sceneTest = require("tests."..env.goPage.."SceneTest")
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

