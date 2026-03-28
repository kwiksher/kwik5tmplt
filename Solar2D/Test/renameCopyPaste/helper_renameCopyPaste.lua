local H = {}

function H.new(state, PAGE2_BASELINE)
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

  local function make_full_button_layer(name, target, onTap)
    return {
      name = name,
      class = "button",
      properties = {
        target = target or name,
        type = "",
        eventType = "tap",
        over = "",
        btaps = 1,
        mask = "",
      },
      actions = {
        onTap = onTap or "previousPage",
      },
    }
  end

  local function make_pulse_layer(name, target)
    return {
      name = name,
      class = "pulse",
      properties = {
        target = target or name,
      },
    }
  end

  local function make_audio_entry(name)
    return {
      name = name,
    }
  end

  local function make_group_entry(name, groupType)
    return {
      name = name,
      type = groupType or "group",
    }
  end

  local function make_timer_entry(name)
    return {
      name = name,
    }
  end

  local function make_variable_entry(name)
    return {
      name = name,
    }
  end

  local function get_file_mtime(path)
    local p = io.popen('stat -f %m "' .. tostring(path) .. '" 2>/dev/null')
    if not p then
      return nil
    end
    local raw = p:read("*a")
    p:close()
    local ts = tonumber((raw or ""):match("%d+"))
    return ts
  end

  local function get_file_size(path)
    local p = io.popen('stat -f %z "' .. tostring(path) .. '" 2>/dev/null')
    if not p then
      return nil
    end
    local raw = p:read("*a")
    p:close()
    local sz = tonumber((raw or ""):match("%d+"))
    return sz
  end

  local function file_exists(path)
    return get_file_mtime(path) ~= nil
  end

  local function wait_until(predicate, timeoutSecs)
    local timeout = timeoutSecs or 8
    local start = os.time()
    while os.time() - start < timeout do
      if predicate() then
        return true
      end
      os.execute("sleep 1")
    end
    return predicate()
  end

  local function resolve_runtime_path(path)
    if type(path) ~= "string" then
      return path
    end
    if system and system.pathForFile then
      local abs = system.pathForFile(path, system.ResourceDirectory)
      if abs then
        return abs
      end
      local page2Abs = system.pathForFile("App/renameCopyPaste/page2.lua", system.ResourceDirectory)
      if page2Abs then
        local base = page2Abs:gsub("App/renameCopyPaste/page2.lua$", "")
        if base ~= page2Abs then
          return base .. path
        end
      end
    end
    if path:match("^Solar2D/") then
      return path
    end

    local direct = path
    local underSolar2D = "Solar2D/" .. path
    if get_file_mtime(direct) ~= nil then
      return direct
    end
    if get_file_mtime(underSolar2D) ~= nil then
      return underSolar2D
    end

    if get_file_mtime("App") ~= nil then
      return direct
    end
    if get_file_mtime("Solar2D") ~= nil then
      return underSolar2D
    end
    return direct
  end

  local function read_text_file(path)
    local f = io.open(path, "r")
    if not f then
      return nil
    end
    local text = f:read("*a")
    f:close()
    return text
  end

  local function ensure_runtime_templates()
    local runtimeTemplateRoot = resolve_runtime_path("lua_modules/kwiksher/resources/template")
    local pageX = runtimeTemplateRoot .. "/pageX.lua"
    if file_exists(pageX) then
      return
    end

    local resourceRoot = system.pathForFile("", system.ResourceDirectory) or ""
    local repoRoot = resourceRoot:gsub("/Solar2D/?$", "")
    local pluginTemplateRoot = repoRoot:gsub("kwik5%-sample%-books$", "kwik5-plugin") .. "/resources/template"

    if file_exists(pluginTemplateRoot .. "/pageX.lua") then
      os.execute('mkdir -p "' .. runtimeTemplateRoot .. '" >/dev/null 2>&1')
      os.execute('cp -R "' .. pluginTemplateRoot .. '/." "' .. runtimeTemplateRoot .. '/" >/dev/null 2>&1')
    end
  end

  local function resolve_page2_lua_path()
    if system and system.pathForFile then
      local abs = system.pathForFile("App/renameCopyPaste/page2.lua", system.ResourceDirectory)
      if abs then
        return abs
      end
    end
    return resolve_runtime_path("App/renameCopyPaste/page2.lua")
  end

  local function assert_layer_files_generated(layerName, className)
    local luaPath = resolve_runtime_path("App/renameCopyPaste/components/page2/layers/" .. layerName .. "_" .. className .. ".lua")
    local jsonPath = resolve_runtime_path("App/renameCopyPaste/models/page2/" .. layerName .. "_" .. className .. ".json")
    wait_until(function()
      return file_exists(luaPath) and file_exists(jsonPath)
    end, 8)
    assert_true(file_exists(luaPath))
    assert_true(file_exists(jsonPath))
  end

  local function should_skip_if_layers_generated(testName, checks)
    local allGenerated = true
    for i = 1, #checks do
      local check = checks[i]
      local ok = pcall(assert_layer_files_generated, check[1], check[2])
      if not ok then
        allGenerated = false
        break
      end
    end

    if allGenerated then
      print("SKIP " .. testName .. ": generated files already exist")
      return true
    end
    return false
  end

  local function should_skip_if_files_exist(testName, relPaths)
    local allExist = true
    for i = 1, #relPaths do
      local relPath = relPaths[i]
      local absPath = resolve_runtime_path(relPath)
      if not file_exists(absPath) then
        allExist = false
        break
      end
    end

    if allExist then
      print("SKIP " .. testName .. ": output files already exist")
      return true
    end
    return false
  end

  local function assert_page2_lua_written()
    wait_until(function()
      return file_exists(state.page2LuaPath or resolve_page2_lua_path())
    end, 8)
    assert_true(file_exists(state.page2LuaPath or resolve_page2_lua_path()))
  end

  local function index_layer_has_class(model, layerName, className)
    if type(model) ~= "string" then
      return false
    end

    local flat = "name%s*=%s*\"" .. layerName .. "\".-class%s*=%s*%b{}"
    local p1, p2 = model:find(flat)
    if p1 and p2 and model:sub(p1, p2):find("\"" .. className .. "\"", 1, true) then
      return true
    end

    local nestedStart, nestedEnd = model:find(layerName .. "%s*=%s*%b{}")
    if nestedStart and nestedEnd then
      local block = model:sub(nestedStart, nestedEnd)
      if block:find("\"" .. className .. "\"", 1, true) then
        return true
      end
    end

    return false
  end

  local function assert_page2_index_layer_class(layerName, className, expected)
    local page2Path = state.page2LuaPath or resolve_page2_lua_path()
    wait_until(function()
      local content = read_text_file(page2Path)
      if not content then
        return false
      end
      if expected then
        return index_layer_has_class(content, layerName, className)
      end
      return true
    end, 8)

    local page2 = read_text_file(page2Path)
    assert_not_nil(page2)
    local hasClass = index_layer_has_class(page2, layerName, className)
    assert_equal(expected, hasClass, "page2.lua class check failed: " .. layerName .. "_" .. className)
  end

  local function assert_page2_updated(expectedChanged, tag, requiredText)
    assert_not_nil(state.page2LuaMTimeBefore)
    assert_not_nil(state.page2LuaSizeBefore)

    local after = get_file_mtime(state.page2LuaPath) or state.page2LuaMTimeBefore
    local sizeAfter = get_file_size(state.page2LuaPath) or state.page2LuaSizeBefore
    if expectedChanged then
      wait_until(function()
        after = get_file_mtime(state.page2LuaPath) or state.page2LuaMTimeBefore
        sizeAfter = get_file_size(state.page2LuaPath) or state.page2LuaSizeBefore
        local content = read_text_file(state.page2LuaPath) or ""
        local hasRequiredText = (requiredText == nil) or (content:find(requiredText, 1, true) ~= nil)
        return (after > state.page2LuaMTimeBefore) or (sizeAfter ~= state.page2LuaSizeBefore) or hasRequiredText
      end, 8)
    end

    local content = read_text_file(state.page2LuaPath) or ""
    local hasRequiredText = (requiredText == nil) or (content:find(requiredText, 1, true) ~= nil)
    local changed = (after > state.page2LuaMTimeBefore) or (sizeAfter ~= state.page2LuaSizeBefore)
    local detail = " before_mtime=" .. tostring(state.page2LuaMTimeBefore) .. " after_mtime=" .. tostring(after)
      .. " before_size=" .. tostring(state.page2LuaSizeBefore) .. " after_size=" .. tostring(sizeAfter)
    assert_equal(expectedChanged, changed, "page2 mtime updated check failed: " .. tostring(tag) .. detail)
    if expectedChanged and requiredText ~= nil then
      assert_true(hasRequiredText, "required text not found in page2.lua: " .. tostring(requiredText))
    end
  end

  local function debug_print_paste_outputs(tag)
    local expectedFiles = {
      "App/renameCopyPaste/components/page2/layers/starfish_button.lua",
      "App/renameCopyPaste/models/page2/starfish_button.json",
      "App/renameCopyPaste/models/page2/index.json",
    }
    for i = 1, #expectedFiles do
      local relPath = expectedFiles[i]
      local absPath = resolve_runtime_path(relPath)
      if file_exists(absPath) then
        print("NEW_FILE", tag, relPath)
      end
    end
    local indexPath = resolve_runtime_path("App/renameCopyPaste/models/page2/index.json")
    if file_exists(indexPath) then
      print("NEW_FILE", tag, "App/renameCopyPaste/models/page2/index.json")
    end

    local diskPage2 = read_text_file(state.page2LuaPath or resolve_page2_lua_path())
    if diskPage2 then
      print("UPDATED_PAGE2_LUA_BEGIN", tag)
      for line in diskPage2:gmatch("[^\n]+") do
        print("UPDATED_PAGE2_LUA", tag, line)
      end
      print("UPDATED_PAGE2_LUA_END", tag)
    else
      print("UPDATED_PAGE2_LUA", tag, "<file read failed>")
    end
  end

  local function setup_stubs()
    ensure_runtime_templates()

    state.calls = {
      render = {},
      save = {},
      updateIndexModel = {},
    }
    state.page2 = deep_copy(PAGE2_BASELINE)
    state.page2LuaRelPath = "App/renameCopyPaste/page2.lua"
    state.page2LuaPath = resolve_page2_lua_path()
    if state.page2LuaPath then
      os.execute('touch -t 200001010000 "' .. state.page2LuaPath .. '" >/dev/null 2>&1')
    end
    state.page2LuaMTimeBefore = get_file_mtime(state.page2LuaPath) or os.time()
    state.page2LuaSizeBefore = get_file_size(state.page2LuaPath) or 0
    state.paste = require("editor.controller.paste")

    local root = (kwikGlobal and kwikGlobal.ROOT) or ""

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
          local c = (class or ""):lower()
          if c == "button" then
            return "interaction"
          end
          return class or ""
        end,
        getClassModule = function(_, class)
          local c = (class or ""):lower()
          if c == "button" then
            return require(root .. "editor.interaction.index")
          end
          return require(root .. "editor.layer.index")
        end,
      }
    }
  end

  local function teardown_stubs()
    state.clipboard = nil
    state.page2 = deep_copy(PAGE2_BASELINE)
    state.page2LuaRelPath = nil
    state.page2LuaPath = nil
    state.page2LuaMTimeBefore = nil
    state.page2LuaSizeBefore = nil
  end

  return {
    deep_copy = deep_copy,
    make_components = make_components,
    make_full_button_layer = make_full_button_layer,
    make_pulse_layer = make_pulse_layer,
    make_audio_entry = make_audio_entry,
    make_group_entry = make_group_entry,
    make_timer_entry = make_timer_entry,
    make_variable_entry = make_variable_entry,
    resolve_runtime_path = resolve_runtime_path,
    file_exists = file_exists,
    assert_layer_files_generated = assert_layer_files_generated,
    should_skip_if_layers_generated = should_skip_if_layers_generated,
    should_skip_if_files_exist = should_skip_if_files_exist,
    assert_page2_lua_written = assert_page2_lua_written,
    assert_page2_updated = assert_page2_updated,
    assert_page2_index_layer_class = assert_page2_index_layer_class,
    debug_print_paste_outputs = debug_print_paste_outputs,
    setup_stubs = setup_stubs,
    teardown_stubs = teardown_stubs,
  }
end

return H
