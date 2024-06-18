local exports = {}

local lfs = require( "lfs" )
local isWindows = system.getInfo("platform") == "win32"

function exports.pwd(path)
  return path:match("(.-)[^%.]+$")
end

function exports.root(path)
  local parent = exports.pwd(path)
  return parent:sub(1, parent:len()-1):match("(.-)[^%.]+$")
end


function exports.pairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0      -- iterator variable
	local iter = function ()   -- iterator function
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end


function exports.PATH (path)
	local ret = path
	if isWindows then
			ret = ret:gsub('/','\\')
	end
	return ret
end

function exports.isFile(name)
	if type(name)~="string" then return false end
	if not exports.isDir(name) then
			return os.rename(name,name) and true or false
			-- note that the short evaluation is to
			-- return false instead of a possible nil
	end
	return false
end

function exports.isFileOrDir(name)
	if type(name)~="string" then return false end
	return os.rename(name, name) and true or false
end

function exports.isDir(name)
	if type(name)~="string" then return false end
	local cd = lfs.currentdir()
	local is = lfs.chdir(name) and true or false
	lfs.chdir(cd)
	return is
end
--------
--------
local lustache = require "extlib.lustache"
local json     = require("json")
--
function exports.renderer (tmpltPath, outPath, model)
	--- .lua
	local file, errorString = io.open( tmpltPath..".lua", "r" )
	if not file then
		print( "File error: " .. errorString )
	else
		local contents = file:read( "*a" )
		io.close( file )
		local output = lustache:render(contents, model)

		local scenePath = outPath:gsub("models/", "")
		local file, errorString = io.open( scenePath..".lua", "w+" )
		if not file then
			print( "File error: " .. errorString )
		else
			output = string.gsub(output, "\r\n", "\n")
			file:write( output )
			io.close( file )
		end
	end
	-- .json
	local file, errorString = io.open( outPath..".json", "w+" )
	if not file then
		print( "File error: " .. errorString )
	else
		local output = json.encode(model)
		file:write( output )
		io.close( file )
	end
end

-- Calculates anchor points
function exports.repositionAnchor(object, newAnchorX, newAnchorY)
    local origX = object.x;
    local origY = object.y
    if object.repositionDone == nil then
        object.repositionDone = true;
        if newAnchorX ~= 0.5 or newAnchorY ~= 0.5 then
            local width = object.width;
            local height = object.height
            local xCoord = width * (newAnchorX - .5)
            local yCoord = height * (newAnchorY - .5)
            object.x = origX + xCoord;
            object.y = origY + yCoord
            object.oriX = object.x;
            object.oriY = object.y
        end
    end
end

function exports.readWeight(_path, file)
  local weight = 0
  local path = _path.."/"..file
         -- Open the file handle
  local file, errorString = io.open( path, "r" )

  if not file then
      -- Error occurred; output the cause
      print( "File error: " .. errorString )
  else
      -- Output lines
      for line in file:lines() do
          if line:find(".weight") then
              local pos = line:find("=")
              weight = line:sub(pos + 1)
             -- print( line, weight )
              break
          end
      end
      -- Close the file handle
      io.close( file )
  end
  file = nil
  return tonumber(weight) or 0
end

function exports.newLineswithWeight(_path, file, weight)
  local weight = 0
  local path = _path.."/"..file
         -- Open the file handle
  local file, errorString = io.open( path, "r" )
  if not file then
      -- Error occurred; output the cause
      print( "File error: " .. errorString )
  else
     local lines = file:lines()
      -- Output lines
      for i, line in next, lines do
          if line:find(".weight") then
              lines[i] = "$.weight="..weight
             -- print( line, weight )
              io.close( file )
              return lines
          end
      end
      table.insert(lines, 1, "$.weight="..weight)
      io.close( file )
      -- Close the file handle
      return lines
  end
  return nil
end

function exports.getLayer(UI, name)
  for i, v in next, UI.layers do
    if v.name == name then
      return v
    end
  end
end

function exports.split(str, sep)
  local out = {}
  for m in string.gmatch(str, "[^" .. sep .. "]+") do
    out[#out + 1] = m
  end
  return out
end
----------------------------------
--
local function newText(option)
  local obj = display.newText(option)
  obj:setFillColor(0)
  return obj
end

local appFont
if ( "android" == system.getInfo( "platform" ) or "win32" == system.getInfo( "platform" ) ) then
  appFont = native.systemFont
else
  -- appFont = "HelveticaNeue-Light"
  appFont = "HelveticaNeue"
end
---
function exports.newTextFactory(_option) -- this is global
  local option = {
    text = "",
    x    = 0,
    y    = 0,
    width    = 0,
    height   = 20,
    font     = appFont,
    fontSize = 10,
    align    = "left"
  }
  if _option then
    for k,v in pairs(_option) do
      option[k] = v
    end
    if _option.anchorX then
      return option, function(option)
        local obj = display.newText(option)
        obj:setFillColor(0)
        obj.anchorX = _option.anchorX
        return obj
      end
    elseif _option.setFillColor then
      return option, function(option)
        local obj = display.newText(option)
        obj:setFillColor(_ootion.setFillColor)
        return obj
      end
    end
  end
  return option, newText
end

function exports.newTextField(option)
  		-- Create native text field
      textField = native.newTextField( option.x, option.y, option.width, option.height )
      textField.font = native.newFont( appFont,option.fontSize )
      --textField:resizeFontToFitHeight()
      --textField:setReturnKey( "done" )
      --textField.placeholder = "Enter text"
      textField:addEventListener( "userInput", function() print("userInput") end )
      --native.setKeyboardFocus( textField )
      textField.text = option.text
      option.parent:insert(textField)
      return textField
end

--/Users/ymmtny/Documents/GitHub/kwik5/sandbox/Ps/react-uxp-styles/Project/Solar2D/templates/components/layer_props.lua
--/Users/ymmtny/Documents/GitHub/kwik5/sandbox/Ps/react-uxp-styles/Project/Solar2D/src/App/../templates/components/layer_props.lua: No such file or directory
return exports