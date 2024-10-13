local name = ...
local parent, root = newModule(name)
local util = require("editor.util")
local scripts = require("editor.scripts.commands")
local json = require("json")

local types = {"page", "timer", "group", "variables", "layer"}

local instance =
  require("commands.kwik.baseCommand").new(
  function(params)
    local UI = params.UI
    -- print(name)
    if params.props and params.props.book then
      print("delete book")
    else
      if UI.editor.selections then
        for i, obj in next, UI.editor.selections do
          if obj.page then
            print("", obj.page)
          elseif obj.layer then
            print("", obj.layer, obj.class)
          end
        end
      end

      local book = UI.book
      local page = UI.page

      local selections = UI.editor.selections or {UI.editor.currentLayer}
      --
      local files, targets = {}, {}
      local indexModel = util.createIndexModel(UI.scene.model) -- noRecursive
      -- local indexModel = util.createIndexModel(UI.scene.model, nil, nil, true) -- noRecursive
      -- print(json.prettify(indexModel))

      local updatedModel = UI.scene.model
      -- UI.scene.model
      local namesMap = {}

      --local classFolder = UI.editor:getClassFolderName(data.class)
      local book, page = UI.book, UI.page
      local entries
      if class == "audio" then
        entries = indexModel.components.audios
      elseif class == "group" then
        entries = indexModel.components.groups
      elseif class == "timer" then
        entries = indexModel.components.timers
      elseif class == "variable" then
        entries = indexModel.components.variables
      elseif class == "joint" then
        entries = indexModel.components.joints
      elseif class == "page" then
        -- TODO
      else
        entries = indexModel.components.layers
      end

      local function createNamesMap(layers, parent)
        for i, v in next, layers do
          if parent then
            namesMap[parent.."/"..v.name] = {i, v}
          else
            namesMap[v.name] = {i, v}
          end
          for k, vv in pairs(v) do
            -- layers1, layer2, layers3
            if k:find("layers") then
                createNamesMap(vv ,v.name)
            end
          end
        end
      end
      --
      createNamesMap(entries)

      -- print(json.prettify(namesMap))

      for i, obj in next, selections do
        local class = params.class or obj.class
        local name
        local path
        if class == "audio" then
          path = "App/" .. book .. "/components/" .. page .. "/audios/" .. obj.subclass .. "." .. obj.audio
          name = obj.subclass .. "." .. obj.audio
        elseif class == "group" then
          path = "App/" .. book .. "/components/" .. page .. "/groups/" .. obj.group
          name = obj.group
        elseif class == "timer" then
          path = "App/" .. book .. "/components/" .. page .. "/timers/" .. obj.timer
          name = obj.timer
        elseif class == "variable" then
          path = "App/" .. book .. "/components/" .. page .. "/variables/" .. obj.variable
          name = obj.variable
        elseif class == "joint" then
          path = "App/" .. book .. "/components/" .. page .. "/joints/" .. obj.joint
          name = obj.joint
        elseif class == "page" then
        elseif class then
          path = "App/" .. book .. "/components/" .. page .. "/layers/" .. obj.layer .. "_" .. obj.class
          name = obj.layer
          if obj.parentObj then
            name = obj.parentObj.layer .."/"..name
          end
        else --class==nil
          path = "App/" .. book .. "/components/" .. page .. "/layers/" .. obj.layer
          name = obj.layer
        end

        -- print(name)
        local entry = namesMap[name]
        -- printTable(namesMap)
        --
        if entry then
          targets[#targets + 1] = {index = entry[1], obj=entry[2], path = path, class = class}
        end
      end
      --
      table.sort(
        targets,
        function(a, b)
          return a.index > b.index
        end
      )

      local function getClass(tbl)
        for k, v in pairs(tbl) do
          -- print(k)
          if type(k) == "string" and k:find("class") then
            return k
          end
        end
      end

      local targetsDelete = {}
      for i, v in next, targets do
        -- print(v.index, v.path, v.class)
        local obj = v.obj
        -- printTable(obj)
        local classKey = getClass(obj)
        -- print(obj.name, classKey)
        if v.class == nil then
          -- table.remove(indexModel,v.index) -- delete from index
        elseif v.class == "audio" then
        elseif v.class == "group" then
        elseif v.class == "timer" then
        elseif v.class == "variable" then
        elseif v.class == "joint" then
        else
          local updated = {}
          for ii, vv in next, obj[classKey] do -- Notice
            if vv ~= v.class then
              updated[#updated + 1] = vv
            end
          end
          obj[classKey] = updated
        end
        files[#files + 1] = v.path
        targetsDelete[#targetsDelete + 1] = v.path
      end
      --
      scripts.saveSelection(book, page, {{name = "deleted", class = class}})
      --
      local indexFile = util.renderIndex(book, page, indexModel)
      files[#files + 1] = indexFile
      --
      scripts.backupFiles(files)
      scripts.executeCopyFiles({indexFile})
      scripts.delete(targetsDelete)
    end
  end
)
--
return instance
