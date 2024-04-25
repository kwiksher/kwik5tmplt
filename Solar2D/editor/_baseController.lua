local current = ...
local parent,root = newModule(current)
--
local json = require("json")
local util = require("editor.util")


local M ={}
-------
-- I/F
--
local function useProps(UI)
  -- print("useProps")
  local props = {
    name = "",
  }
  props.name = propsTable.name
  --
  return props
end

-- this handler should be called from selectbox to set one of animtations user selected
function M:setValue(decoded, index, template)
  if decoded == nil then print("## Error setValue ##") return end
  if not template then
    self.baseTable:setValue(decoded[index])
  else
    self.baseTable:setValue(decoded)
  end
end


function M:toggle ()
  self.buttons:toggle()
  self.propsTable:toggle()
  self.baseTable:toggle()
end

function M:show ()
  self.propsTable:show()
  self.baseTable:show()
  self.buttons:show()
end

function M:hide ()
  self.propsTable:hide()
  self.baseTable:hide()
  self.buttons:hide()
end

function M:reset()
  local UI = self.view.UI

  self.baseTable:didHide(UI)
  self.baseTable:destroy(UI)
  self.baseTable:init(UI)
  self.propsTable:didHide(UI)
  self.propsTable:destroy(UI)
  self.propsTable:init(UI)
end

function M:redraw()
  local UI = self.view.UI

  self.baseTable:create(UI)
  self.baseTable:didShow(UI)
  self.propsTable:create(UI)
  self.propsTable:didShow(UI)
  UI.editor.variableEditor:toFront()
end

function M:save(book, page, value, decoded)
  local name =  value or "index"
  local path = page .."/"..name.."_"..self.suffix..".json"
  local path = system.pathForFile( "App/"..book.."/models/"..page .."/"..name.."_"..self.suffix..".json", system.ResourceDirectory)

  local file, errorString = io.open( path, "w" )
   if not file then
      -- Error occurred; output the cause
      print( "File error: " .. errorString )
      return false
  else
      -- Write encoded JSON data to file
      file:write( json.encode( decoded ) )
      -- Close the file handle
      io.close( file )
      return true
  end
end

function M:read(book, page, value, isNew, tool)
  print("read", page, value, isNew, tool)
  if isNew then
  -- create a new value
  -- read the template
  local path = "editor.defaults.value"
  print(path)
  local template = require(path)
  print("", json.encode(template))

  local decoded -- TODO
  self:reset()
  self:setValue(template, nil, true)
  self:redraw()

  else
    local name = layer or "index"
    local path      = page .."/"..name.."_"..self.suffix..".json"
    local path      = system.pathForFile( "App/"..book.."/models/"..page .."/"..name.."_"..self.suffix..".json", system.ResourceDirectory)
    local decoded,   pos, msg = json.decodeFile( path )
    if not decoded then
        print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
    else
        print( "File successfully decoded!" )
    end
    self:reset()
    self:setValue(decoded, 1)
    self:redraw()
  end
  self:show()
end

function M:command()
  local instance = require("commands.kwik.baseCommand").new(
  function (params)
    local UI    = params.UI
    local name =  params[params.class] or ""
    local decoded = util.decode(params)
    --
    print("From selectors")
    self.propsTable:didHide(UI)
    self.propsTable:destroy(UI)
    self.propsTable:init(UI)
    self.propsTable:setValue(decoded)

    self.propsTable:create(UI)
    self.propsTable:didShow(UI)

    --
    self:show()
    --
    UI.editor.editPropsLabel = name
    --
    UI.editor.rootGroup:dispatchEvent{name="labelStore",
      currentBook= UI.editor.currentBook,
      currentPage= UI.page,
      currentLayer = name}

  end)
  return instance
end

M.new = function(t,p, b, suffix)
  local instance = {baseTable = t, propsTable = p, buttons = b}

  t.setValue = function(decoded, index)
    instance:reset()
    instance:setValue(decoded, index)
    instance:redraw()
  end
  --
  t.useProps = useProps

	return setmetatable(instance, {__index=M})
end

return M