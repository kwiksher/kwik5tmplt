--- base_suite.lua
-- Factory for suite module tables.
-- Provides generic M.init and M.suite_setup driven by a config table.
-- All common editor modules are pre-loaded and accessible as M.xxx fields;
-- they are also forwarded to helper.init so helper utilities work without
-- explicit module arguments.
--
-- Usage:
--   local M = require("Test.base_suite").new()
--
--   -- with config:
--   local M = require("Test.base_suite").new({
--     show         = true,          -- (always on; show+onClick on projectPageSelector)
--     appFolder    = true,          -- (always on; set global appFolder from ResourceDirectory)
--     selectApp    = true,          -- dispatchEvent editor.selector.selectApp
--     book         = "myBook",      -- bookTable.commandHandler
--     page         = "page1",       -- pageTable.commandHandler
--     component    = "iconOnly",    -- override default "withClick" ("iconOnly" skips onClick)
--     componentTable = "layerTable" -- arg to componentSelector:onClick (default)
--   })
--
-- Context (set during M.init) is available as:
--   M.selectors, M.UI, M.bookTable, M.pageTable, M.layerTable
--
-- Common editor modules are available immediately as:
--   M.json, M.groupTable, M.buttons, M.actionTable, M.commandbox,
--   M.actionCommandPropsTable, M.actionController, M.assetTable,
--   M.variableTable, M.audioTable, M.actionCommandTable, M.actionEditor,
--   M.partsButtons, M.classProps, M.actionbox, M.actionButtons,
--   M.listbox, M.listPropsTable, M.listButtons, M.picker,
--   M.colorPicker, M.scriptsCommands, M.util, M.editorUtil, and more

local helper = require("Test.helper")

-- Pre-load all common modules once (Lua caches require results).
local _mods = {
  json                    = require("json"),
  groupTable              = require("editor.group.groupTable"),
  buttons                 = require("editor.group.buttons"),
  actionTable             = require("editor.action.actionTable"),
  commandbox              = require("editor.action.commandbox"),
  actionCommandPropsTable = require("editor.action.actionCommandPropsTable"),
  actionController        = require("editor.action.controller.index"),
  assetTable              = require("editor.asset.assetTable"),
  variableTable           = require("editor.variable.variableTable"),
  audioTable              = require("editor.audio.audioTable"),
  actionCommandTable      = require("editor.action.actionCommandTable"),
  actionEditor            = require("editor.action.index"),
  partsButtons            = require("editor.parts.buttons"),
  classProps              = require("editor.parts.classProps"),
  actionbox               = require("editor.parts.actionbox"),
  -- additional modules
  actionButtons           = require("editor.action.buttons"),
  actionButtonContext      = require("editor.action.buttonContext"),
  actionCommandButtons    = require("editor.action.actionCommandButtons"),
  actionboxButtonContext   = require("editor.parts.buttonContext"),
  listbox                 = require("editor.replacement.listbox"),
  listPropsTable          = require("editor.replacement.listPropsTable"),
  listButtons             = require("editor.replacement.listButtons"),
  picker                  = require("editor.picker.name"),
  scriptsCommands         = require("editor.scripts.commands"),
  util                    = require("lib.util"),
  editorUtil              = require("editor.util"),
  colorPicker             = require("colorPicker"),
  timerTable              = require("editor.timer.timerTable"),
}

local base_suite = {}

function base_suite.new(config)
  config = config or {}
  local M = {}

  -- Attach all pre-loaded modules to M so tests can use M.groupTable etc.
  for k, v in pairs(_mods) do
    M[k] = v
  end

  --- Called by the test runner with the shared props table.
  -- Extracts run-time context into M fields and forwards all module refs to
  -- helper.init so helper utilities (clickButton, etc.) work without explicit args.
  function M.init(props)
    M.selectors, M.UI, M.bookTable, M.pageTable, M.layerTable =
      helper.extractProps(props)
    helper.initSuite(props, M)
  end

  --- Called once before the suite's tests run.
  function M.suite_setup()
    appFolder = system.pathForFile("App", system.ResourceDirectory)
    M.selectors.projectPageSelector:show()
    M.selectors.projectPageSelector:onClick(true)
    if config.selectApp then
      M.UI.scene.app:dispatchEvent {
        name = "editor.selector.selectApp",
        UI   = M.UI,
      }
    end
    if config.book then
      M.bookTable.commandHandler({book = config.book}, nil, true)
    end
    if config.page then
      M.pageTable.commandHandler({page = config.page}, nil, true)
    end
    if config.component == "iconOnly" then
      M.selectors.componentSelector.iconHander()
    elseif config.component then  -- default: "withClick"
      M.selectors.componentSelector.iconHander()
      M.selectors.componentSelector:onClick(
        true, config.componentTable or "layerTable")
    end
  end

  M.setup    = function() end
  M.teardown = function() end

  return M
end

return base_suite
