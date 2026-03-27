local M = require("Test.base_suite").new({
  book = "renameCopyPaste",
  page = "page1",
  component = "iconOnly"
})

local PAGE2_BASELINE = {
  components = {
    layers = {{background = {}}},
    audios = {},
    groups = {},
    timers = {},
    variables = {},
    joints = {},
    page = {}
  },
  commands = {}
}

local state = {
  calls = nil,
  page2 = nil,
  scripts = nil,
  util = nil,
  paste = nil,
  originals = nil,
  moduleBackups = nil,
}

local function deep_copy(v)
  if type(v) ~= "table" then
    return v
  end
  local out = {}
  for k, val in pairs(v) do
    out[k] = deep_copy(val)
  end
  return out
end

local function make_components(overrides)
  local components = {
    layers = {},
    audios = {},
    groups = {},
    timers = {},
    variables = {},
    joints = {}
  }
  for k, v in pairs(overrides or {}) do
    components[k] = v
  end
  return components
end

local function make_controller(kind)
  local controller = {}

  function controller:render(...)
    local args = {...}
    local model = args[#args]
    local name = args[3]
    if type(model) == "table" and model.name then
      name = model.name
    end
    table.insert(state.calls.render, {kind = kind, name = name, args = args})
    return "tmp/" .. kind .. "_render_" .. tostring(name) .. ".lua"
  end

  function controller:save(...)
    local args = {...}
    local model = args[#args]
    local name = args[3]
    if type(model) == "table" and model.name then
      name = model.name
    end
    table.insert(state.calls.save, {kind = kind, name = name, args = args})
    return "tmp/" .. kind .. "_save_" .. tostring(name) .. ".json"
  end

  return controller
end

local function install_module_stub(moduleName, moduleValue)
  state.moduleBackups[moduleName] = package.loaded[moduleName]
  package.loaded[moduleName] = moduleValue
end

local function setup_stubs()
  state.calls = {
    render = {},
    save = {},
    updateIndexModel = {},
    backupFiles = {},
    executeCopyFiles = {},
    saveSelection = {},
    copyPage = {},
  }
  state.page2 = deep_copy(PAGE2_BASELINE)
  state.moduleBackups = {}

  local layerController = make_controller("layer")
  local audioController = make_controller("audio")
  local groupController = make_controller("group")
  local timerController = make_controller("timer")
  local variableController = make_controller("variable")
  local jointController = make_controller("joint")

  local root = (kwikGlobal and kwikGlobal.ROOT) or ""
  local function with_root(mod)
    return root .. mod
  end

  install_module_stub(with_root("editor.audio.index"), {controller = audioController})
  install_module_stub(with_root("editor.group.index"), {controller = groupController})
  install_module_stub(with_root("editor.timer.index"), {controller = timerController})
  install_module_stub(with_root("editor.variable.index"), {controller = variableController})
  install_module_stub(with_root("editor.physics.index"), {controller = jointController})

  if root ~= "" then
    install_module_stub("editor.audio.index", {controller = audioController})
    install_module_stub("editor.group.index", {controller = groupController})
    install_module_stub("editor.timer.index", {controller = timerController})
    install_module_stub("editor.variable.index", {controller = variableController})
    install_module_stub("editor.physics.index", {controller = jointController})
  end

  state.scripts = require("editor.scripts.commands")
  state.util = require("editor.util")
  state.paste = require("editor.controller.paste")

  state.originals = {
    backupFiles = state.scripts.backupFiles,
    executeCopyFiles = state.scripts.executeCopyFiles,
    saveSelection = state.scripts.saveSelection,
    copyPage = state.scripts.copyPage,
    updateIndexModel = state.util.updateIndexModel,
  }

  state.scripts.backupFiles = function(files)
    table.insert(state.calls.backupFiles, deep_copy(files))
  end

  state.scripts.executeCopyFiles = function(files)
    table.insert(state.calls.executeCopyFiles, deep_copy(files))
  end

  state.scripts.saveSelection = function(book, page, selections)
    table.insert(state.calls.saveSelection, {book = book, page = page, selections = deep_copy(selections)})
  end

  state.scripts.copyPage = function(book, src, dst)
    table.insert(state.calls.copyPage, {book = book, src = src, dst = dst})
  end

  state.util.updateIndexModel = function(scene, layer, class, modelType)
    table.insert(state.calls.updateIndexModel, {layer = layer, class = class, modelType = modelType})
    return state.originals.updateIndexModel(scene, layer, class, modelType)
  end

  state.UI = {
    book = "renameCopyPaste",
    page = "page2",
    scene = {model = state.page2},
    editor = {
      currentLayer = {layer = "background"},
      selections = {{layer = "background"}},
      clipboard = {
        read = function()
          return state.clipboard
        end
      },
      getClassFolderName = function(_, class)
        return class or ""
      end,
      getClassModule = function(_, class)
        return {controller = layerController, class = class}
      end,
    }
  }
end

local function teardown_stubs()
  if state.scripts and state.originals then
    state.scripts.backupFiles = state.originals.backupFiles
    state.scripts.executeCopyFiles = state.originals.executeCopyFiles
    state.scripts.saveSelection = state.originals.saveSelection
    state.scripts.copyPage = state.originals.copyPage
  end

  if state.util and state.originals then
    state.util.updateIndexModel = state.originals.updateIndexModel
  end

  if state.moduleBackups then
    for moduleName, prev in pairs(state.moduleBackups) do
      package.loaded[moduleName] = prev
    end
  end

  state.clipboard = nil
  state.page2 = deep_copy(PAGE2_BASELINE)
end

function M.setup()
  setup_stubs()
end

function M.teardown()
  teardown_stubs()
end

function M.test_direct_paste_layer_class_from_starfish_button()
  state.clipboard = {
    class = "button",
    page = "page1",
    components = make_components({
      layers = {
        {name = "starfish", class = "button", properties = {target = "starfish"}}
      }
    })
  }

  state.paste.execute({UI = state.UI})

  assert_equal(1, #state.calls.updateIndexModel)
  assert_equal("background", state.calls.updateIndexModel[1].layer)
  assert_equal("button", state.calls.updateIndexModel[1].class)
  assert_true(#state.calls.render > 0)
end

function M.test_direct_paste_layer_class_from_title1_pulse()
  state.clipboard = {
    class = "pulse",
    page = "page1",
    components = make_components({
      layers = {
        {name = "title1", class = "pulse", properties = {target = "title1"}}
      }
    })
  }

  state.paste.execute({UI = state.UI})

  assert_equal(1, #state.calls.updateIndexModel)
  assert_equal("background", state.calls.updateIndexModel[1].layer)
  assert_equal("pulse", state.calls.updateIndexModel[1].class)
end

function M.test_direct_paste_audios_long_and_short()
  state.clipboard = {
    class = "audio",
    page = "page1",
    components = make_components({
      audios = {
        {name = "long"},
        {name = "short"}
      }
    })
  }

  state.paste.execute({UI = state.UI})

  assert_equal(2, #state.calls.render)
  assert_equal("long", state.calls.render[1].name)
  assert_equal("short", state.calls.render[2].name)
end

function M.test_direct_paste_group_groupCat()
  state.clipboard = {
    class = "group",
    type = "group",
    page = "page1",
    components = make_components({
      groups = {
        {name = "groupCat", type = "group"}
      }
    })
  }

  state.paste.execute({UI = state.UI})

  assert_equal(1, #state.page2.components.groups)
  assert_not_nil(state.page2.components.groups[1].groupCat)
end

function M.test_direct_paste_timer_nameTimer()
  state.clipboard = {
    class = "timer",
    page = "page1",
    components = make_components({
      timers = {
        {name = "nameTimer"}
      }
    })
  }

  state.paste.execute({UI = state.UI})

  assert_equal(1, #state.page2.components.timers)
  assert_equal("nameTimer", state.page2.components.timers[1])
end

function M.test_direct_paste_variable_myText()
  state.clipboard = {
    class = "variable",
    page = "page1",
    components = make_components({
      variables = {
        {name = "myText"}
      }
    })
  }

  state.paste.execute({UI = state.UI})

  assert_equal(1, #state.page2.components.variables)
  assert_equal("myText", state.page2.components.variables[1])
end

function M.test_direct_paste_one_to_many_for_selected_layers()
  state.UI.editor.selections = {
    {layer = "cat"},
    {layer = "fish"}
  }

  state.clipboard = {
    class = "button",
    page = "page1",
    components = make_components({
      layers = {
        {name = "starfish", class = "button", properties = {target = "starfish"}}
      }
    })
  }

  state.paste.execute({UI = state.UI})

  assert_equal(2, #state.calls.updateIndexModel)
  assert_equal("cat", state.calls.updateIndexModel[1].layer)
  assert_equal("fish", state.calls.updateIndexModel[2].layer)
end

function M.test_direct_paste_many_entries_keeps_payload_from_page1_components()
  state.clipboard = {
    class = "button",
    page = "page1",
    components = make_components({
      layers = {
        {name = "starfish", class = "button", properties = {target = "starfish"}},
        {name = "title1", class = "button", properties = {target = "title1"}}
      }
    })
  }

  state.paste.execute({UI = state.UI})

  assert_equal(2, #state.calls.updateIndexModel)
  assert_equal("starfish", state.calls.updateIndexModel[1].layer)
  assert_equal("title1", state.calls.updateIndexModel[2].layer)
end

return M