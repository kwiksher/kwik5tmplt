local M = require("Test.base_suite").new({
  book = "renameCopyPaste",
  page = "page1",
  component = "iconOnly"
})

local json = require("json")

local state = {
  originalModules = {},
  utilStub = nil,
  scriptsStub = nil,
  controllerStub = nil,
  paste = nil,
  UI = nil,
  pageModel = nil,
  previousPageModel = nil,
  nameActModel = nil,
  nameActDecoded = nil,
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

local function module_names(name)
  local names = {name}
  if kwikGlobal and kwikGlobal.ROOT then
    names[#names + 1] = kwikGlobal.ROOT .. name
  end
  return names
end

local function swap_module(name, replacement)
  for i = 1, #module_names(name) do
    local moduleName = module_names(name)[i]
    if state.originalModules[moduleName] == nil then
      state.originalModules[moduleName] = package.loaded[moduleName]
    end
    package.loaded[moduleName] = replacement
  end
end

local function clear_module(name)
  for i = 1, #module_names(name) do
    package.loaded[module_names(name)[i]] = nil
  end
end

local function restore_modules()
  for moduleName, original in pairs(state.originalModules) do
    package.loaded[moduleName] = original
  end
  state.originalModules = {}
end

local function reset_spy_state()
  state.controllerStub.calls = {
    render = {},
    save = {}
  }
  state.utilStub.calls = {
    renderIndex = {},
    saveIndex = {}
  }
  state.scriptsStub.calls = {
    saveSelection = {},
    backupFiles = {},
    executeCopyFiles = {}
  }
end

local function make_ui()
  return {
    book = "renameCopyPaste",
    page = "page1",
    scene = {
      model = deep_copy(state.pageModel)
    },
    editor = {
      currentBook = "renameCopyPaste",
      currentAction = {name = "previousPage"},
      clipboard = {
        read = function()
          return state.clipboardData
        end
      }
    }
  }
end

local function find_command_name(commands)
  local names = {}
  for i = 1, #commands do
    names[commands[i]] = true
  end
  return names
end

function M.setup()
  state.pageModel = require("App.renameCopyPaste.page1").model
  state.previousPageModel = require("App.renameCopyPaste.commands.page1.previousPage").model
  state.nameActModel = require("App.renameCopyPaste.commands.page1.nameAct").model
  state.nameActDecoded = json.decode(state.nameActModel)

  state.utilStub = {
    calls = {},
    createIndexModel = function(_, model)
      return deep_copy(model)
    end,
    renderIndex = function(_, book, page, updatedModel)
      state.utilStub.calls.renderIndex[#state.utilStub.calls.renderIndex + 1] = {
        book = book,
        page = page,
        model = deep_copy(updatedModel)
      }
      return "render-index.lua"
    end,
    saveIndex = function(_, book, page, a, b, updatedModel)
      state.utilStub.calls.saveIndex[#state.utilStub.calls.saveIndex + 1] = {
        book = book,
        page = page,
        model = deep_copy(updatedModel)
      }
      return "save-index.json"
    end,
  }

  state.controllerStub = {
    calls = {},
    render = function(_, book, page, command, actions)
      state.controllerStub.calls.render[#state.controllerStub.calls.render + 1] = {
        book = book,
        page = page,
        command = command,
        actions = deep_copy(actions)
      }
      return "render-" .. tostring(command) .. ".lua"
    end,
    save = function(_, book, page, command, decoded)
      state.controllerStub.calls.save[#state.controllerStub.calls.save + 1] = {
        book = book,
        page = page,
        command = command,
        decoded = deep_copy(decoded)
      }
      return "save-" .. tostring(command) .. ".json"
    end,
  }

  state.scriptsStub = {
    calls = {},
    saveSelection = function(_, book, page, selection)
      state.scriptsStub.calls.saveSelection[#state.scriptsStub.calls.saveSelection + 1] = {
        book = book,
        page = page,
        selection = deep_copy(selection)
      }
    end,
    backupFiles = function(_, files)
      state.scriptsStub.calls.backupFiles[#state.scriptsStub.calls.backupFiles + 1] = deep_copy(files)
    end,
    executeCopyFiles = function(_, files)
      state.scriptsStub.calls.executeCopyFiles[#state.scriptsStub.calls.executeCopyFiles + 1] = deep_copy(files)
    end,
  }

  swap_module("editor.util", state.utilStub)
  swap_module("editor.action.controller.index", state.controllerStub)
  swap_module("editor.scripts.commands", state.scriptsStub)
  clear_module("editor.action.controller.paste")
  state.paste = require("editor.action.controller.paste")
end

function M.teardown()
  clear_module("editor.action.controller.paste")
  restore_modules()
end

function M.test_paste_action_from_previousPage()
  reset_spy_state()

  state.clipboardData = {
    actions = {state.previousPageModel},
    actionCommands = {},
    book = "renameCopyPaste",
    page = "page1",
  }

  state.UI = make_ui()
  state.paste.execute({UI = state.UI, class = "action"})

  assert_equal(1, #state.controllerStub.calls.render)
  assert_equal("previousPage_copied", state.controllerStub.calls.render[1].command)

  local savedIndex = state.utilStub.calls.saveIndex[#state.utilStub.calls.saveIndex].model
  local names = find_command_name(savedIndex.commands)
  assert_true(names.previousPage)
  assert_true(names.nameAct)
  assert_true(names.previousPage_copied)
end

function M.test_paste_action_from_nameAct()
  reset_spy_state()

  state.clipboardData = {
    actions = {state.nameActModel},
    actionCommands = {},
    book = "renameCopyPaste",
    page = "page1",
  }

  state.UI = make_ui()
  state.paste.execute({UI = state.UI, class = "action"})

  assert_equal(1, #state.controllerStub.calls.render)
  assert_equal("nameAct_copied", state.controllerStub.calls.render[1].command)

  local savedIndex = state.utilStub.calls.saveIndex[#state.utilStub.calls.saveIndex].model
  local names = find_command_name(savedIndex.commands)
  assert_true(names.nameAct_copied)
end

function M.test_paste_multiple_actions_previousPage_and_nameAct()
  reset_spy_state()

  state.clipboardData = {
    actions = {state.previousPageModel, state.nameActModel},
    actionCommands = {},
    book = "renameCopyPaste",
    page = "page1",
  }

  state.UI = make_ui()
  state.paste.execute({UI = state.UI, class = "action"})

  assert_equal(2, #state.controllerStub.calls.render)
  assert_equal("previousPage_copied", state.controllerStub.calls.render[1].command)
  assert_equal("nameAct_copied", state.controllerStub.calls.render[2].command)

  local savedIndex = state.utilStub.calls.saveIndex[#state.utilStub.calls.saveIndex].model
  local names = find_command_name(savedIndex.commands)
  assert_true(names.previousPage_copied)
  assert_true(names.nameAct_copied)
end

function M.test_paste_one_actionCommand_into_previousPage()
  reset_spy_state()

  state.clipboardData = {
    actions = {},
    actionCommands = {deep_copy(state.nameActDecoded.actions[1])},
    book = "renameCopyPaste",
    page = "page1",
  }

  state.UI = make_ui()
  state.UI.editor.currentAction = {name = "previousPage"}
  state.paste.execute({UI = state.UI, class = "actionCommand", index = 1})

  assert_equal(1, #state.controllerStub.calls.render)
  local renderCall = state.controllerStub.calls.render[1]
  assert_equal("previousPage", renderCall.command)
  assert_equal(2, #renderCall.actions)
  assert_equal("page.gotoPage", renderCall.actions[1].command)
  assert_equal("variable.editVar", renderCall.actions[2].command)
end

function M.test_paste_multiple_actionCommands_into_previousPage()
  reset_spy_state()

  state.clipboardData = {
    actions = {},
    actionCommands = {
      deep_copy(state.nameActDecoded.actions[1]),
      {
        command = "action.play",
        params = {
          actionName = "nameAct"
        }
      }
    },
    book = "renameCopyPaste",
    page = "page1",
  }

  state.UI = make_ui()
  state.UI.editor.currentAction = {name = "previousPage"}
  state.paste.execute({UI = state.UI, class = "actionCommand", index = 1})

  assert_equal(1, #state.controllerStub.calls.render)
  local renderCall = state.controllerStub.calls.render[1]
  assert_equal("previousPage", renderCall.command)
  assert_equal(3, #renderCall.actions)
  assert_equal("page.gotoPage", renderCall.actions[1].command)
  assert_equal("variable.editVar", renderCall.actions[2].command)
  assert_equal("action.play", renderCall.actions[3].command)
end

return M
