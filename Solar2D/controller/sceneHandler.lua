local M = {}
--
local dir = ...
local parent = dir:match("(.-)[^%.]+$")
local root = parent:sub(1, parent:len()-1):match("(.-)[^%.]+$")


function M:setMod(class, layer, custom)
  local fileName = layer
  local classOption = {}
  if class then
    -- print(type(class))
    classOption = class:split('.')
    fileName = layer .."_"..classOption[1]
  end
  if custom then
    --print("custom.components."..self.page.."."..fileName)
    self.mod = require("App."..self.UI.props.appName..".custom.components."..self.UI.page..".layers."..fileName)
  else
    --print("components."..self.UI.page.."."..fileName)
    self.mod = require("App."..self.UI.props.appName..".components."..self.UI.page..".layers."..fileName)
  end
  self.mod.classOption = classOption[2]
end
--
function M:_init(class, layer, custom, children)
  self:setMod(class, layer, custom)
  if self.mod.init then
    self.mod.children = children
    self.mod:init(self.UI)
  end
end
--
local typesForPageCurl = {
  button=true, image=true, filter=true
}
--
function M:_create(class, layer, custom)
  self:setMod(class, layer, custom)
  -- dummy is pageCurl UI creation
  if self.mod.create and (self.dummy == nil or typesForPageCurl[class])  then
    self.mod:create(self.UI)
  end
end
--
function M:_willShow(class, layer, custom)
  self:setMod(class, layer, custom)
  if self.mod.willShow then
    self.mod:willShow(self.UI)
  end
end
--
function M:_willHide(class, layer, custom)
  self:setMod(class, layer, custom)
  if self.mod.willHide then
    self.mod:willHide(self.UI)
  end
end
--
function M:_didShow(class, layer, custom)
  self:setMod(class, layer, custom)
  if self.mod.didShow then
    self.mod:didShow(self.UI)
  end
end
--
function M:_didHide(class, layer, custom)
  self:setMod(class, layer, custom)
  if self.mod.didHide then
    self.mod:didHide(self.UI)
  end
end
--
function M:_destroy(class, layer, custom)
  self:setMod(class, layer, custom)
  if self.mod.destroy then
    self.mod:destroy(self.UI)
  end
end
--
function M:_resume(class, layer, custom)
  self:setMod(class, layer, custom)
  if self.mod.resume then
    self.mod:resume(self.UI)
  end
end
--
M.new = function(_UI)
  local handler = {UI=_UI}
	return setmetatable(handler, {__index=M})
end
--
return M