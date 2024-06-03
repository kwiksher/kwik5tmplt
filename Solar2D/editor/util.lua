local M = {}
local json = require("json")
local lfs = require("lfs")
local lustache = require "extlib.lustache"
local formatter = require("extlib.formatter")
local platform = system.getInfo( "platformName" )

function M.getPath(str)
  return str:match("(.*[/\\])")
end

function M.getFileName(str)
  local n = str:match("^.+/(.+)$")
  return n:sub(0, #n - 4)
end

local isTarget = function(layer, layerName)
  for key, v in pairs(layer) do
    if key == "class" then
    elseif key == "event" then
    elseif key == layerName then
      return true
    end
  end
  return false
end
--
local isClass = function(v, class)
  for j = 1, #v.class do
    if v.class[j] == class then
      return true
    end
  end
  return false
end

function M.isExist(book, page, layer, class)
  local path =system.pathForFile( "App/"..book.."/components/"..page.."/layers/"..layer.."_"..class..".lua", system.ResourceDirectory)
  return path
end

function M.updateIndexModel(_scene, layerName, class)
  local scene = _scene or {
    components = {
      layers = {  },
      audios = {  },
      groups = {  },
      timers = {  },
      variables = {  },
      others = {  }
     }
  }
  --
  local onInit = scene.onInit
  scene.onInit = nil
  local copied = M.copyTable(scene)
  scene.onInit = onInit

  -- print("%%%", layerName)
  local function processLayers(layers, nLevel)
    for i = 1, #layers do
      -- print("%%%", i)
      local layer = layers[i]
      local children = {}
      --
      if isTarget(layer, layerName) then
        -- print("%%%", layerName)
        local target = layer[layerName]
        if target.class == nil then
          target.class = {}
        end
        --
        if not isClass(target, class) then
          table.insert(target.class, class)
        end
      end

      --
      local children = {}
      for key, value in pairs(layer) do
        -- print(key, value)
        if key == "class" then
        elseif key == "event" then
        else
          if type(value)=="table" and next(value) then
            if value.class == nil then
              --
              -- {aName = {A={}, B={}}}
              --
              children[#children + 1] = value
            else
              local field, child = next(value, nil)
              while field do
                -- print(field, "=", child, #children +1)
                if field ~= "class" then
                  -- child.layers = false
                  children[#children + 1] = child
                -- elseif newEntry.class == nil then
                --   newEntry.class = child
                end
                field, child = next(value, field)
              end
            end
          end
        end
      end
      if #children > 0 then
        -- if next(v) == nil then
        --   -- just empty layer without class nor event
        --   v.class = {class}
        -- end
        processLayers(children, nLevel + 1)
      else
        -- newEntry.layers = false
      end
    end
  end
  --
  --if layerName then
  processLayers(copied.components.layers, 1)
  --end
  --
  return copied
end


function M.createIndexModel(_scene, layerName, class)
  local scene = _scene or {
    components = {
      layers = {  },
      audios = {  },
      groups = {  },
      timers = {  },
      variables = {  },
      others = {  }
     }
  }
  --
  local onInit = scene.onInit
  scene.onInit = nil
  local copied = M.copyTable(scene)
  scene.onInit = onInit

  local function processLayers(layers, nLevel)
    for i = 1, #layers do
      local layer = layers[i]
      local newEntry = {}
      local children = {}
      --
      if isTarget(layer, layerName) then
        local target = layer[layerName]
        if target.class == nil then
          newEntry.class = {}
        else
          newEntry.class = target.class
        end
        --
        if not isClass(newEntry, class) then
          newEntry.class[#newEntry.class + 1] = class
        end
      end

      --
      local children = {}
      for key, value in pairs(layer) do
        -- print(key, value)
        if key == "class" then
          -- if newEntry.class == nil then -- this means not isTarget(layer, layerName)
          --   newEntry.class = value
          -- end
        elseif key == "event" then
        else
          newEntry.name = key
          if type(value)=="table" and next(value) then
            if value.class == nil then
              --
              -- {aName = {A={}, B={}}}
              --
              children[#children + 1] = value
            else
              -- print("@@@@", json.encode(children ))
              --
              -- {aName = {class = {"button"), A={}, B={}}}
              --  => {"class"]["button"], "1":{ "A":[]}, "2":{"B":[]}} see the A's and B's object is array

              -- print("###", json.encode(value ))

              local field, child = next(value, nil)
              while field do
                -- print(field, "=", child, #children +1)
                if field ~= "class" then
                  -- child.layers = false
                  children[#children + 1] = child
                elseif newEntry.class == nil then
                  newEntry.class = child
                end
                field, child = next(value, field)
              end
            end
          end
        end
      end
      if #children > 0 then
        -- if next(v) == nil then
        --   -- just empty layer without class nor event
        --   v.class = {class}
        -- end
        newEntry["layers" .. nLevel] = children
        processLayers(newEntry["layers" .. nLevel], nLevel + 1)
      else
        -- newEntry.layers = false
      end
      layers[i] = newEntry
    end
  end
  --
  --if layerName then
  processLayers(copied.components.layers, 1)
  --end
  --
  return copied
end

function M.selectFromIndexModel(scene, args)
  local target = args[1]
  --
  local function processLayers(layers, target, level)
    local nextTarget = args[level + 1]
    for i = 1, #layers do
      local layer = layers[i]
      local children = {}
      --
      for key, value in pairs(layer) do
        -- print(key, value)
        if isTarget(layer, target) then
          if nextTarget == nil then
            return {type = "layer", file = key, value=value}
          elseif isClass(layer, nextTarget) then
            return {type = "class", file = key .. "_" .. nextTarget}
          else -- look into childen
            if key == "class" then
            elseif key == "event" then
            else
              if next(value) then
                if value.class == nil then
                  --
                  -- {aName = {A={}, B={}}}
                  --
                  children[#children + 1] = value
                else
                  -- print("@@@@", json.encode(children ))
                  --
                  -- {aName = {class = {"button"), A={}, B={}}}
                  --  => {"class"]["button"], "1":{ "A":[]}, "2":{"B":[]}} see the A's and B's object is array

                  -- print("###", json.encode(value ))

                  local field, child = next(value, nil)
                  while field do
                    -- print(field, "=", child, #children +1)
                    if field ~= "class" then
                      -- child.layers = false
                      children[#children + 1] = child
                    elseif layer.class == nil then
                    end
                    field, child = next(value, field)
                  end
                end
              end

              if #children > 0 then
                local ret = processLayers(children, nextTarget, level + 1)
                return {type = ret.type, file = target .. "/" .. ret.file}
              end
            end
          end
        end
      end
      return nil
    end
    --
    local out = processLayers(scene.components.layers, target, 1)
    print(json.encode(out))
    return out
  end
end


function M.copyTable(decoded)
  if decoded then
    return json.decode(json.encode(decoded))
  else
    return {}
  end
end

function M.mkdir(...)
  -- print("#### mkdir")
  local folders = {...}
  local path = system.pathForFile(nil, system.TemporaryDirectory)
  lfs.chdir(path)
  local parent = lfs.currentdir()
  for i = 1, #folders do
    local name = folders[i]
    -- print("",name)
    local isDir = lfs.chdir(name) and true or false
    if not isDir then
      lfs.mkdir(name)
      local newFolderPath = lfs.currentdir() .. "/" .. name
      lfs.chdir(newFolderPath)
    end
    parent = parent .. "/" .. lfs.currentdir()
  end
  -- print(parent)
end

function M.saveLua(tmplt, dst, model, partial)
  print("local tmplt='".. tmplt.. "'")
  print("local dst ='".. dst.. "'")
  print("local model = json.decode('".. json.encode(model).. "')" )

  local path = system.pathForFile(tmplt, system.ResourceDirectory)
  local file, errorString = io.open(path, "r")
  if not file then
    print("File error: " .. errorString)
    return nil
  else
    local contents = file:read("*a")
    io.close(file)
    --print(json.encode(model))
    local output = lustache:render(contents, model, partial)
    local path = system.pathForFile(dst, system.TemporaryDirectory) --system.TemporaryDirectory)
    --print(path)
    local file, errorString = io.open(path, "w+")
    if not file then
      print("File error: " .. errorString)
    else
      output = string.gsub(output, "\r\n", "\n")
      output = output:gsub("&#x2F;", "/")
      output = output:gsub("&#39;", '"')
      output = output:gsub("class={  }", "")
      local formatted = formatter.indentcode(output, "\n", true, "  ")
      if formatted then
        -- print(formatted)
        file:write(formatted)
      else
        -- print(output)
        file:write(output)
      end
      io.close(file)
    end
    return path
  end
end

function M.writeLines(_path, lines)
  local path = system.pathForFile(_path, system.TemporaryDirectory)
  local file, errorString = io.open(path, "w")
  if not file then
    -- Error occurred; output the cause
    print("File error: " .. errorString)
  else
    for i, l in ipairs(lines) do io.write(l, "\n") end
    io.close(file)
    return true
  end
  return false
end

function M.saveJson(_path, model)
  local path = system.pathForFile(_path, system.TemporaryDirectory)
  -- print(_path)
  local file, errorString = io.open(path, "w")
  if not file then
    -- Error occurred; output the cause
    print("File error: " .. errorString)
    return false
  else
    -- Write encoded JSON data to file
    file:write(json.encode(model))
    -- Close the file handle
    io.close(file)
    return true
  end
end


function M.decode(book, page, class, name, options)
  print("$$$$", options.isNew)
  if options.isNew then
    local path = "editor.template.components.pageX." .. class .. ".defaults." .. class
    return require(path)
  elseif options.isDelete then
    print(class, "delete")
    return {}
  else
    local name = name or ""
    if options.subclass then
      name = options.subclass .. "/" .. name
    end
    local path =
      system.pathForFile(
      "App/" .. book .. "/models/" .. page .. "/" .. class .. "s/" .. name .. ".json",
      system.ResourceDirectory
    )
    if path then
      print("App/" .. book .. "/models/" .. page .. "/" .. class .. "s/" .. name .. ".json")
      decoded, pos, msg = json.decodeFile(path)
    end
    if not decoded then
      print("Decode failed at " .. tostring(pos) .. ": " .. tostring(msg), path)
      decoded = {}
    end
    return decoded or {}
  end
end

-- function M.read(book, page, filter)
--   local path =system.pathForFile("App/"..book.."/models/"..page .."/commands"
--   , system.ResourceDirectory)
--   print(path)
--   return {}
-- end

function M.read(book, page, filter)
  local path = system.pathForFile("App/" .. book .. "/models/" .. page .. "/index.json", system.ResourceDirectory)
  -- print(path)

  local ret = {}
  --
  -- TODO read it recurrsively!
  --
  local decoded, pos, msg = json.decodeFile(path)
  if not decoded then
    print("Decode failed at " .. tostring(pos) .. ": " .. tostring(msg))
  else
    local function parser(decoded, parent)
      local layers = nil
      for i = 1, #decoded do
        local name = nil
        for k, v in pairs(decoded[i]) do
          if k ~= "class" and k ~= "commands" and k ~= "weight" then
            local layer = {name = k, parent = parent}
            --  ret.layers[#ret.layers+1] = {name=k}
            if filter then
              layer.isFiltered = filter(parent, k)
            end
            if layers == nil then
              layers = {}
            end
            layers[#layers + 1] = layer

            name = k
            --print(k)
            if parent then
              layer.children = parser(v, parent .. "." .. k)
            else
              layer.children = parser(v, k)
            end
            break
          end
        end
        local classEntries = decoded[i].class or {}
        for j = 1, #classEntries do
          local className = classEntries[j]
          -- print("", name.."_"..className)
          local t = ret[className]
          if t == nil then
            t = {}
            ret[className] = t
          end
          local f = name .. "_" .. className .. ".json"
          local path = system.pathForFile("App/" .. book .. "/models/" .. page .. "/" .. f, system.ResourceDirectory)
          local decoded, pos, msg = json.decodeFile(path)
          if not decoded then
            print("Decode failed at " .. tostring(pos) .. ": " .. tostring(msg))
          else
            for l = 1, #decoded do
              t[#t + 1] = {name = decoded[l].name, file = name .. "_" .. className, index = l}
            end
          end
        end
      end
      return layers
    end
    --
    ret.layers = parser(decoded)
    --
    ret.audios = {}
    ret.groups = {}
    ret.commands = {}
    --
    -- read audios/*.json
    local function setFiles(t, dir)
      -- print( "App/"..UI.editor.currentBook.."/models/"..UI.editor.currentPage..dir)
      local path = system.pathForFile("App/" .. book .. "/models/" .. page .. dir, system.ResourceDirectory)
      if path then
        for file in lfs.dir(path) do
          if file:find(".json") ~= nil then
            -- print( "Found file: " .. file )
            t[#t + 1] = {name = file:gsub(".json", "")}
          end
        end
      end
    end
    --
    setFiles(ret.audios, "/audios/short")
    setFiles(ret.audios, "/audios/long")
    setFiles(ret.groups, "/groups")
    setFiles(ret.commands, "/commands")
  end
  --print(json.encode(ret))
  return ret
end

M.setSelection = function(self, obj)
  -- print("@@@@", obj.text)
  if not self:isControlDown() then
    -- UI.scene.app:dispatchEvent {
    --   name = "editor.group.selectLayer",
    --   UI = UI,
    --   index = obj.index,
    --  -- value = self.actions[obj.index]
    -- }

    for i = 1, #self.selections do
      self.selections[i].rect:setFillColor(1)
    end

    if obj.isSelected then
      obj.rect:setFillColor(1)
      self.selections = {}
    else
      self.selections = {obj}
      obj.rect:setFillColor(0, 1, 0)
    end
    obj.isSelected = not obj.isSelected
  else -- multi
    --obj:setFillColor(1)
    if not obj.isSelected then
      self.selections[#self.selections + 1] = obj
      obj.rect:setFillColor(0, 1, 0)
    else
      obj.rect:setFillColor(1)
    end
    obj.isSelected = not obj.isSelected
    local tmp = {}
    for i = 1, #self.selections do
      if self.selections[i].isSelected then
        tmp[#tmp + 1] = self.selections[i]
      end
    end
    self.selections = tmp
  end
end

function M.getParent(obj)
  local ret = ""
  if obj.parentObj then
    ret = M.getParent(obj.parentObj, ret) .. obj.parentObj.layer .. "/" .. ret
  end
  return ret
end

function M.renderIndex(book, page, model)
  local dst = "App/" .. book .. "/components/" .. page .. "/index.lua"
  --local dst = "index.lua"
  local tmplt = "editor/template/components/pageX/index.lua"
  local n = ""

  local function getRecursive(n)
    return [[
    {
      {{name}} = { {{ #layers]] ..
      n ..
        [[ }}{{>recursive]] ..
          n .. [[}} {{/layers]] .. n .. [[}}
      class={ {{#class}}"{{.}}",{{/class}} }  }
    },
   ]]
  end

  -- {
  --   {{name}} = { {{ #layers]]..n..[[ }}{{>recursive]]..n..[[}} {{/layers]]..n..[[}}
  --   {{#class}} class={ {{#class}}"{{.}}"{{/class}} } {{/class}} }
  -- },

  local partial = {recursive = getRecursive(1)}
  local numOfchildren = 3
  for i = 1, numOfchildren do
    partial["recursive" .. i] = getRecursive(i + 1)
  end
  -- print(json.encode(partial))
  M.saveLua(
    tmplt,
    dst,
    {
      name = model.name,
      events = model.commands,
      layers = model.components.layers,
      audios = model.components.audios,
      timers = model.components.timers,
      groups = model.components.groups,
      variables = model.components.variables,
      page = model.components.page
    },
    partial
  )
  return dst
end

function M.saveIndex(book, page, layer, class, model)
  local dst = "App/" .. book .. "/models/" .. page .. "/index.json"
  --local dst = "index.json"
  local decoded = M.copyTable(model)
  if layer then
    for i = 1, #decoded.components.layers do
      local entry = decoded.components.layers[i]
      -- for k, v in pairs(entry) do print(k,v) end
      if entry.name == layer then
        if entry.class == nil then
          entry.class = {}
        end
        table.insert(entry.class, class)
        for j = 1, #entry.class do
          print(entry.class[j])
        end
        break
      end
    end
  else
    print("TODO for timer, variable, audio")
  end
  decoded.onInit = nil
  -- print(json.encode(decoded))
  M.saveJson(dst, decoded)
  return dst
end

function M.readAssets(book, type, filter)
  local path = system.pathForFile("App/" .. book .. "/assets/", system.ResourceDirectory)
  local ret = {
    fonts = {},
    images = {},
    particles = {},
    sprites = {},
    thumbnails = {},
    videos = {}
  }
  ret["audios.short"] = {}
  ret["audios.long"] = {}
  ret["audios.sync"] = {}
  --
  local _filter = filter or {}
  for k, v in pairs(ret) do
    if not _filter[k] and type == k then
      local out = M.split(k, ".")
      local folder = out[1]
      local sub = out[2]
      local target = ret[k]
      if sub and sub:len() > 0 then
        target = ret[folder .. "." .. sub]
        folder = folder .. "/" .. sub
      end
      --
      local success = lfs.chdir(path .. "/" .. folder) -- Returns true on success
      if success then
        local fullpath = lfs.currentdir()
        ---
        local function getFiles(fullpath, _folder, parent)
          local children = {}
          -- print(fullpath)
          local full_path =fullpath
          local _parent = parent or ""
          if _folder then
            full_path = fullpath .. (_folder or "")
            -- print(full_path)
          end
          --
          for file in lfs.dir(full_path) do
            -- print("", file)
            if file:len() > 2 then
              local isDir = lfs.chdir(file) and true or false
              if k == "audios.long" then
                print(file)
              end
              if isDir then
                getFiles(full_path, "/" .. file, _parent.."/"..file)
                lfs.chdir(full_path)
              else
                if _folder then
                  table.insert(target, _parent:sub(2) .."/".. file)
                else
                  table.insert(target, _parent:sub(2)..file)
                end
              end
            end
          end
          return children
        end
        ---
        getFiles(fullpath)
      end
    end
  end
  return ret
end

function M.split(str, sep)
  local out = {}
  for m in string.gmatch(str, "[^" .. sep .. "]+") do
    out[#out + 1] = m
  end
  return out
end
--
-- merge
local exports = require("lib.util")
return setmetatable(M, {__index = exports})
