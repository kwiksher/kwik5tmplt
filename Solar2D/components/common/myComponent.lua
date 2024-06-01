-- $weight=-1
--
local _M = {}

local current = ...
local parent = current:match("(.-)[^%.]+$")
local root = parent:sub(1, parent:len()-1):match("(.-)[^%.]+$")

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
