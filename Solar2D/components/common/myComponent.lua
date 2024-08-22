-- $weight=-1
--
local _M = {}

local current = ...
local parent = current:match("(.-)[^%.]+$")
local root = parent:sub(1, parent:len()-1):match("(.-)[^%.]+$")
local util = require("lib.util")
-- print(current, parent ,root)

function string:mySplit(delimiter)
  local t = {}
  for s in self:gmatch(delimiter) do
    table.insert(t, s)
  end
  return t
end

local _print = print

print = function(...)
  local t = debug.traceback()
  local stacks = t:mySplit("[^\r\n]+")
  local lines = stacks[3]:mySplit("[^/]+")
  local line = lines[#lines]
  local file = line:mySplit("[^:]+")
  if #file > 2 then
    local name = file[#file-2]
    if name == 'index.lua' then
      _print(lines[#lines-2].."/"..lines[#lines-1].."/index.lua:".. file[#file-1], ...)
    else
      _print(file[#file-2]..":".. file[#file-1], ...)
    end
  else
    _print("", line, ...)
  end
end

printTable = function(tbl, printType)
  local flatten_tbl = util.flattenKeys(nil, tbl)
  local t = debug.traceback()
  local stacks = t:mySplit("[^\r\n]+")
  local lines = stacks[3]:mySplit("[^/]+")
  local line = lines[#lines]
  for i, v in next, lines do
    if v:find(".lua") then
      line = v
      break
    end
  end
  local file = line:mySplit("[^:]+")
  local header
  if #file > 2 then
    local name = file[#file-2]
    if name == 'index.lua' then
      header = lines[#lines-2].."/"..lines[#lines-1].."/index.lua:".. file[#file-1]
    else
     header = file[#file-2]..":".. file[#file-1]
    end
  else
    header = line
  end
  local function compare(a,b)
    return a.name < b.name
  end
  local array_tbl = {}
  for k, v in pairs(flatten_tbl) do
    array_tbl[#array_tbl+1] = {name =k:sub(2), value=v}
  end

  table.sort(array_tbl, compare)
  for i, v in next, array_tbl do
    if printType then
      _print(header, v.name, type(v.value))
    else
      _print(header, v.name, v.value)
    end
  end
end

function table:mySet (list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end
--
function _M:init(UI)
end
--
function _M:create(UI)
end
--
function _M:didShow(UI)
end
--
function _M:didHide(UI)
end
--
function _M:destroy()
end
--
return _M
