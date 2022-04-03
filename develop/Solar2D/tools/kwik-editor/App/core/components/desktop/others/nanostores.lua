
local M = {}
M.name = ...
M.weight = 1
---

local nanostores =  require("extlib.nanostores.index")
local albums = nanostores.createStore()
local pages = nanostores.createStore()
local layers = nanostores.createStore()
local props = nanostores.createStore()
local actions = nanostores.createStore()
local actionProps = nanostores.createStore()
local layerInstances = nanostores.createStore()
local assets = nanostores.createStore()

---
function M:init(UI)
  print("-------- nanostore ---------")
  UI.albumStore = albums
  UI.pageStore = pages
  UI.layerStore = layers
  UI.propsStore = props
  UI.actionStore = actions
  UI.actionPropsStore = actionProps
  UI.layerInstanceStore = layerInstances -- layer
  UI.assetStore = assets
  ----_----------------
  --
  --------------------
  --[[
    local fooStore = nanostores.createStore()

    fooStore:set(1)

  -- -- -- subscribing to changes
  -- fooStore:subscribe(function(foo, fooValue)
  --   print("","Initial value from a subscription", fooValue)
  -- end)

  -- -- -- listen for changes without an initial value
  fooStore:listen(function(foo, fooValue)
    print("","Change from a listener", fooValue)
  end)

  -- easy getter
  local value = nanostores.getValue(fooStore)
  print("","current foo value", value)
  -- value.test = 2

  -- local value1 = nanostores.getValue(fooStore)

  -- print("","current foo value", value1.test)

  -- setting values
  --fooStore:set(value)
  --]]
  --------------------
  -- map
  --------------------
--[[

  local mapStore = nanostores.createMap()

  mapStore:listen(function(foo, fooValue)
    for k, v in pairs(fooValue) do print(" listen", k, v) end
  end)

  mapStore:set({test=1})
  --mapStore:set({test=1, name="hello"})

  mapStore:subscribe(function(foo, fooValue)
    for k, v in pairs(fooValue) do print(" sub", k, v) end
  end)

  mapStore:setKey('test',2)

  local value1 = nanostores.getValue(mapStore)

  print("","current value1", value1)
  for k, v in pairs(value1) do print(k, v) end

  -- setting values
  --mapStore:set(value)

  --]]
end

--
function M:create(UI)
  print("create", self.name)

  local models = {
    {name="layer01"},
    {name="layer02"}
  }

end
--
function M:didShow(UI) end
--
function M:didHide(UI) end
--
function M:destroy() end
--
return M


