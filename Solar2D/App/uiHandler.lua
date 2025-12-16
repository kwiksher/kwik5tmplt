local parent,root, M = newModule(...)
local util = require(kwikGlobal.ROOT.."lib.util")
--
-- TODO extlib table in kwik editor and template/uiHandler.lua
--
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
local appPath = "/App/TheLastSpark/behaviorTree"
package.path = resourcePath .. appPath.."/?.lua;" .. resourcePath .. appPath.."/?/?.lua;"..package.path


function M:init(UI)
  for i, v in next, self.libs do
    UI[v.name] = require(parent..v.value)
  end

  local App = require(kwikGlobal.ROOT.."controller.Application")
  local props = App.getProps()
  print(props.appName)
  --
  --  behaviorTree
  --
  local path = "App/"..props.appName.."/behaviorTree/"..UI.page.."_scene.tree"
  local fullPath = system.pathForFile(path, system.ResourceDirectory)
  if fullPath and util.isFile(fullPath) then
    UI.behaviorTree = require("App."..props.appName..".behaviorTree.views."..UI.page.."."..UI.page.."Scene")
    UI.behaviorTree.view = UI.sceneGroup
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
  if UI.behaviorTree then
    UI.behaviorTree:show({phase = "willShow"})
  end
end

function M:didShow(UI)
  if UI.behaviorTree then
    UI.behaviorTree:show({phase = "didShow"})
  end
end

function M:willHide(UI)
    if UI.behaviorTree then
    UI.behaviorTree:show({phase = "willHide"})
  end
end

function M:didHide(UI)
  if UI.behaviorTree then
    UI.behaviorTree:show({phase = "didHide"})
  end
end

function M:destroy(UI)
  if UI.behaviorTree then
    UI.behaviorTree:destroy()
  end
end

function M:resume(UI)
end

return M