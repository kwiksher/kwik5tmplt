local parent,root, M = newModule(...)
local util = require(kwikGlobal.ROOT.."lib.util")
--
-- TODO extlib table in kwik editor and template/uiHandler.lua
--
local enableBehaviorTree = true
M.enableBehaviorTree = enableBehaviorTree

M.libs = {
}

-- enable the line belor for kwik5-sample-books/App/keyvoard. See https://kwiksher.github.io/kwik5docs/tutorial/keyboard/index.html
local keyboardPath = system.pathForFile("keyboard", system.ResourceDirectory)
if keyboardPath then
  local attr = lfs.attributes(keyboardPath)
  if attr and attr.mode == "directory" then
    table.insert(M.libs, {name="mycode", value = "keyboard.mycode"})
    print("Keyboard module found and enabled")
  end
end

local resourcePath = system.pathForFile("", system.ResourceDirectory)

local function dispatchBehaviorTreePhase(behaviorTree, eventName, phase)
  if not behaviorTree then
    return
  end

  if behaviorTree.show then
    behaviorTree:show({phase = phase})
    return
  end

  if eventName == "show" and behaviorTree.onShow then
    behaviorTree:onShow(phase)
    return
  end

  if eventName == "hide" and behaviorTree.onHide then
    behaviorTree:onHide(phase)
    return
  end
end



function M:init(UI)
  for i, v in next, self.libs do
    UI[v.name] = require(parent..v.value)
  end

  local App = require(kwikGlobal.ROOT.."controller.Application")
  local props = App.getProps()
  print(props.appName)

  local appPath = "/Behavior/"..props.appName
  local appLuaPath1 = resourcePath .. appPath.."/?.lua"
  local appLuaPath2 = resourcePath .. appPath.."/?/?.lua"
  if not string.find(package.path, appLuaPath1, 1, true) then
    package.path = appLuaPath1..";" .. appLuaPath2..";"..package.path
  end

  --
  --  behaviorTree
  --
  local path = "Behavior/"..props.appName.."/"..UI.page.."_scene.tree"
  local fullPath = system.pathForFile(path, system.ResourceDirectory)
  if enableBehaviorTree and fullPath and util.isFile(fullPath) then
    local function clearModule(modName)
      if package.loaded[modName] then
        package.loaded[modName] = nil
      end
    end

    -- Avoid cross-app and stale module cache collisions caused by generic names like `views.display_manager`.
    clearModule("views.display_manager")
    clearModule("views.baseScene")
    clearModule("views.common_scene")
    clearModule("views."..UI.page.."."..UI.page.."Scene")
    clearModule("lua_modules.kwiksher.kwik.behaivor.display_manager_common")
    clearModule("kwiksher.kwik.behaivor.display_manager_common")

    UI.behaviorTree = require("Behavior."..props.appName..".views."..UI.page.."."..UI.page.."Scene")
    UI.behaviorTree.view = UI.sceneGroup
    UI.behaviorTree.UI = UI
  else
    print("behavitor tree is not found", path)
  end
end

function M:create(UI)
  -- print(UI.props.appName, UI.props.gotoPage)
  -- UI.mycode:createDica(UI)
  if UI.behaviorTree then
    UI.behaviorTree:create()
  end
end

function M:willShow(UI)
  dispatchBehaviorTreePhase(UI.behaviorTree, "show", "will")
end

function M:didShow(UI)
  dispatchBehaviorTreePhase(UI.behaviorTree, "show", "did")
end

function M:willHide(UI)
  dispatchBehaviorTreePhase(UI.behaviorTree, "hide", "will")
end

function M:didHide(UI)
  dispatchBehaviorTreePhase(UI.behaviorTree, "hide", "did")
end

function M:destroy(UI)
  if UI.behaviorTree then
    UI.behaviorTree:destroy()
  end
end

function M:resume(UI)
end


return M