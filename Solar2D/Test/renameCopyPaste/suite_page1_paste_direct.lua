local M = require("Test.base_suite").new({
  book = "renameCopyPaste",
  page = "page1",
  component = "iconOnly"
})

local PAGE2_BASELINE = {
  components = {
    layers = {
      {background = {}},
      {name = {}},
      {cat = {}},
      {cat_face1 = {}},
      {title_base = {}},
      {title3 = {}},
      {title2 = {}},
      {title1 = {}},
      {starfish = {}},
      {fish = {}},
    },
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
  page2LuaRelPath = nil,
  page2LuaPath = nil,
  page2LuaMTimeBefore = nil,
  page2LuaSizeBefore = nil,
  paste = nil,
}

local helper = require("Test.renameCopyPaste.helper_renameCopyPaste").new(state, PAGE2_BASELINE)

local make_components = helper.make_components
local make_full_button_layer = helper.make_full_button_layer
local make_pulse_layer = helper.make_pulse_layer
local make_audio_entry = helper.make_audio_entry
local make_group_entry = helper.make_group_entry
local make_timer_entry = helper.make_timer_entry
local make_variable_entry = helper.make_variable_entry
local resolve_runtime_path = helper.resolve_runtime_path
local file_exists = helper.file_exists
local assert_layer_files_generated = helper.assert_layer_files_generated
local should_skip_if_layers_generated = helper.should_skip_if_layers_generated
local should_skip_if_files_exist = helper.should_skip_if_files_exist
local assert_page2_lua_written = helper.assert_page2_lua_written
local assert_page2_updated = helper.assert_page2_updated
local assert_page2_index_layer_class = helper.assert_page2_index_layer_class
local debug_print_paste_outputs = helper.debug_print_paste_outputs

function M.setup()
  helper.setup_stubs()
end

function M.teardown()
  helper.teardown_stubs()
end

function M.test_paste_layer_class_from_starfish_button()
  if should_skip_if_layers_generated("test_paste_layer_class_from_starfish_button", {
    {"starfish", "button"}
  }) then
    return
  end

  state.clipboard = {
    class = "button",
    page = "page1",
    components = make_components({
      layers = {
        make_full_button_layer("starfish")
      }
    })
  }

  state.UI.editor.currentLayer = {layer = "starfish"}
  state.UI.editor.selections = {{layer = "starfish"}}

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_paste_layer_class_from_starfish_button")

  assert_layer_files_generated("starfish", "button")
  assert_true(not file_exists(resolve_runtime_path("App/renameCopyPaste/components/page2/layers/starfish_1_button.lua")))
  assert_page2_lua_written()
  assert_page2_updated(true, "test_paste_layer_class_from_starfish_button", "button")
end

function M.xtest_paste_layer_class_from_title1_pulse()
  if should_skip_if_layers_generated("xtest_paste_layer_class_from_title1_pulse", {
    {"title1", "pulse"}
  }) then
    return
  end

  state.clipboard = {
    class = "pulse",
    page = "page1",
    components = make_components({
      layers = {
        make_pulse_layer("title1")
      }
    })
  }

  state.UI.editor.currentLayer = {layer = "title1"}
  state.UI.editor.selections = {{layer = "title1"}}

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_paste_layer_class_from_title1_pulse")

  assert_equal(1, #state.calls.updateIndexModel)
  assert_equal("title1", state.calls.updateIndexModel[1].layer)
  assert_equal("pulse", state.calls.updateIndexModel[1].class)
  assert_true(not file_exists(resolve_runtime_path("App/renameCopyPaste/components/page2/layers/title1_1_pulse.lua")))
  assert_page2_lua_written()
  assert_page2_updated(true, "test_paste_layer_class_from_title1_pulse", "title1")
  assert_page2_index_layer_class("title1", "pulse", true)
end

function M.xtest_paste_audios_long_and_short()
  if should_skip_if_files_exist("xtest_paste_audios_long_and_short", {
    "App/renameCopyPaste/components/page2/audios/long/long.lua",
    "App/renameCopyPaste/components/page2/audios/short/short.lua"
  }) then
    return
  end

  state.clipboard = {
    class = "audio",
    page = "page1",
    components = make_components({
      audios = {
        make_audio_entry("long"),
        make_audio_entry("short")
      }
    })
  }

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_paste_audios_long_and_short")

  assert_equal(2, #state.calls.render)
  assert_equal("long", state.calls.render[1].name)
  assert_equal("short", state.calls.render[2].name)
  assert_page2_lua_written()
  assert_page2_updated(true, "test_paste_audios_long_and_short", "long")
end

function M.xtest_paste_group_groupCat()
  if should_skip_if_files_exist("xtest_paste_group_groupCat", {
    "App/renameCopyPaste/components/page2/groups/groupCat.lua"
  }) then
    return
  end

  state.clipboard = {
    class = "group",
    type = "group",
    page = "page1",
    components = make_components({
      groups = {
        make_group_entry("groupCat", "group")
      }
    })
  }

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_paste_group_groupCat")

  assert_equal(1, #state.page2.components.groups)
  assert_not_nil(state.page2.components.groups[1].groupCat)
  assert_page2_lua_written()
  assert_page2_updated(true, "test_paste_group_groupCat", "groupCat")
end

function M.xtest_paste_timer_nameTimer()
  if should_skip_if_files_exist("xtest_paste_timer_nameTimer", {
    "App/renameCopyPaste/components/page2/timers/nameTimer.lua"
  }) then
    return
  end

  state.clipboard = {
    class = "timer",
    page = "page1",
    components = make_components({
      timers = {
        make_timer_entry("nameTimer")
      }
    })
  }

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_paste_timer_nameTimer")

  assert_equal(1, #state.page2.components.timers)
  assert_equal("nameTimer", state.page2.components.timers[1])
  assert_page2_lua_written()
  assert_page2_updated(true, "test_paste_timer_nameTimer", "nameTimer")
end

function M.xtest_paste_variable_myText()
  if should_skip_if_files_exist("xtest_paste_variable_myText", {
    "App/renameCopyPaste/components/page2/variables/myText.lua"
  }) then
    return
  end

  state.clipboard = {
    class = "variable",
    page = "page1",
    components = make_components({
      variables = {
        make_variable_entry("myText")
      }
    })
  }

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_paste_variable_myText")

  assert_equal(1, #state.page2.components.variables)
  assert_equal("myText", state.page2.components.variables[1])
  assert_page2_lua_written()
  assert_page2_updated(true, "test_paste_variable_myText", "myText")
end

function M.test_paste_one_to_many_for_selected_layers()
  if should_skip_if_layers_generated("test_paste_one_to_many_for_selected_layers", {
    {"starfish", "button"}
  }) then
    return
  end

  state.clipboard = {
    class = "button",
    page = "page1",
    components = make_components({
      layers = {
        make_full_button_layer("starfish")
      }
    })
  }

  state.UI.editor.selections = {
    {layer = "starfish"},
    {layer = "fish"},
  }

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_paste_one_to_many_for_selected_layers")

  assert_equal(2, #state.calls.updateIndexModel)
  assert_equal("starfish", state.calls.updateIndexModel[1].layer)
  assert_equal("fish", state.calls.updateIndexModel[2].layer)
  assert_layer_files_generated("starfish", "button")
  assert_layer_files_generated("fish", "button")
  assert_page2_lua_written()
  assert_page2_updated(true, "test_paste_one_to_many_for_selected_layers", "starfish")
  assert_page2_index_layer_class("starfish", "button", true)
  assert_page2_index_layer_class("fish", "button", true)

end

function M.xtest_direct_multi_paste_skips_unmatched_layer_names()
  if should_skip_if_layers_generated("xtest_direct_multi_paste_skips_unmatched_layer_names", {
    {"starfish", "button"}
  }) then
    return
  end

  state.clipboard = {
    class = "button",
    page = "page1",
    components = make_components({
      layers = {
        make_full_button_layer("starfish"),
        make_full_button_layer("ghost")
      }
    })
  }

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_direct_multi_paste_skips_unmatched_layer_names")

  assert_equal(1, #state.calls.updateIndexModel)
  assert_equal("starfish", state.calls.updateIndexModel[1].layer)
  assert_equal("starfish", state.calls.render[1].name)

  local starfishPath = resolve_runtime_path("App/renameCopyPaste/components/page2/layers/starfish_button.lua")
  local ghostPath = resolve_runtime_path("App/renameCopyPaste/components/page2/layers/ghost_button.lua")
  assert_true(file_exists(starfishPath))
  assert_true(not file_exists(ghostPath))
  assert_page2_lua_written()
  assert_page2_updated(true, "test_direct_multi_paste_skips_unmatched_layer_names", "starfish")
  assert_page2_index_layer_class("starfish", "button", true)
  assert_page2_index_layer_class("title1", "button", false)
end

function M.xtest_direct_paste_title1_does_not_force_unique_rename()
  if should_skip_if_layers_generated("xtest_direct_paste_title1_does_not_force_unique_rename", {
    {"title1", "pulse"}
  }) then
    return
  end

  state.clipboard = {
    class = "pulse",
    page = "page1",
    components = make_components({
      layers = {
        make_pulse_layer("title1")
      }
    })
  }

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_direct_paste_title1_does_not_force_unique_rename")

  assert_equal(1, #state.calls.updateIndexModel)
  assert_equal("title1", state.calls.updateIndexModel[1].layer)
  assert_equal("pulse", state.calls.updateIndexModel[1].class)
  assert_layer_files_generated("title1", "pulse")
  assert_true(not file_exists(resolve_runtime_path("App/renameCopyPaste/components/page2/layers/title1_1_pulse.lua")))
  assert_page2_lua_written()
  assert_page2_updated(true, "test_direct_paste_title1_does_not_force_unique_rename", "title1")
  assert_page2_index_layer_class("title1", "pulse", true)
end

return M