-- $weight=-1
--
local _M = {}

local current = ...
local parent = current:match("(.-)[^%.]+$")
local root = parent:sub(1, parent:len()-1):match("(.-)[^%.]+$")

-- print(current, parent ,root)

local editor = require("editor.index")

-- local screen = require(parent.."screen")

--
function _M:init(UI)
  editor:init(UI)
end
--
function _M:create(UI)
  editor:create(UI)
end
--
function _M:didShow(UI)
  editor:didShow(UI)
end
--
function _M:didHide(UI)
  editor:didHide(UI)
end
--
function _M:destroy(UI)
  editor:destroy(UI)
end
--
return _M
