local lfs = require("lfs")

local book = "hub"
local arr = {"cafe", "collection", "inventory", "members", "mission", "party", "quest", "recruit", "shop"}

local function mkdir(path)
    lfs.mkdir(path)
end

local function writeFile(path, content)
    local file = io.open(path, "w")
    file:write(content)
    file:close()
end

local dst = lfs.currentdir()
local tmp = ""

mkdir(dst .. "/App/" .. book)
lfs.chdir(dst .. "/App/" .. book)

for _, page in ipairs(arr) do
    tmp = tmp .. "'" .. page .. "', "
    print(page)
    mkdir("assets/images/" .. page)
    mkdir("commands/" .. page)
    mkdir("components/" .. page)
    mkdir("components/" .. page .. "/audios")
    mkdir("components/" .. page .. "/audios/long")
    mkdir("components/" .. page .. "/audios/short")
    mkdir("components/" .. page .. "/audios/sync")
    mkdir("components/" .. page .. "/groups")
    mkdir("components/" .. page .. "/layers")
    mkdir("components/" .. page .. "/page")
    mkdir("components/" .. page .. "/timers")
    mkdir("components/" .. page .. "/variables")
    mkdir("components/" .. page .. "/joints")
    mkdir("models/" .. page)

    local bgLuaContent = [[
local M = {}
--
function M:init(UI)
end
--
function M:create(UI)
  local sceneGroup = UI.sceneGroup
end
--
function M:didShow(UI)
end
--
function M:didHide(UI)
end
--
function M:destroy(UI)
end
--
return M
]]
    writeFile("components/" .. page .. "/layers/bg.lua", bgLuaContent)

    local indexLuaContent = [[
local sceneName = ...
--
local scene = require('controller.scene').new(sceneName, {
    components = {
      layers = { },
      audios = { },
      groups = { },
      timers = { },
      variables = { },
      page = { }
    },
    commands = { },
    onInit = function(scene) print("onInit") end
})
--
return scene
]]
    lfs.chdir("components/" .. page)
    writeFile("index.lua", indexLuaContent)
    lfs.chdir("../..")
end

print(tmp)

lfs.chdir(dst .. "/App/" .. book)

local indexLuaContent = [[
local scenes = {
]] .. tmp .. [[
}
return scenes
]]
writeFile("index.lua", indexLuaContent)

lfs.chdir(dst)
