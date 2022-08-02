--
-- http://p-monster.hatenablog.com/entry/2013/02/22/215402
--
-- Const = require "const"
-- test = Const:new{"aa", "bb", cc = 100}
-- print(test.aa)  --> "aa"
-- print(test.bb)  --> "bb"
-- print(test.cc)  --> 100
-- print(#test)  --> 0 (Lua5.1) or 3 (Lua5.2)
-- print(test:len())  --> 3
--print(test.dd)  --> error : "dd" is undefined constrator.
--test.aa = 10  --> error : Enum is read-only.
--
--
local Const = {}
local lenKey = "len"
local _ = {}
setmetatable(_, {__mode = "k"})

function Const:__len()
	local i = 0
	for k, v in pairs(_[self]) do
		if k ~= lenKey then
			i = i + 1
		end
	end
	return i
end

function Const:new(o)
	local t = {}
	_[t] = {[lenKey] = Const.__len}
	for k, v in pairs(o) do
		-- print (k, v)
		if _[t][v] ~= nil then
			error('"' .. v .. '" can not be set.', 2)
		end
		_[t][v] = v
	end
	t.attrs = o
	return setmetatable(t, self)
end

function Const:__index(k)
	if _[self][k] == nil then
		error('"' .. k .. '" is undefined constrator.', 2)
	end
	return _[self][k]
end

function Const:__newindex()
	error("Const is read-only.", 2)
end

function Const:getValue(table)
	local t = {}
  for pos,val in pairs(_[table]) do
      if (type(val)=="table") then
      	table.print(val)
      end
  end
  return t
end

return Const
