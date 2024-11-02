local M = {}

local _LCD     = "LCD"
local _numDica = "numDica"
local _Win     = "Win"

local Texto_dynamictext = require("App.keyboard.components.page1.layers.Texto_dynamictext")
local textodica_dynamictext = require("App.keyboard.components.page1.layers.textodica_dynamictext")

-- checkLCD is an ext code for editVar function
--   editor.model = {expression ="value+1", type="function"}
--   =>
--     editVar("myVar", function(value) return value+1 end)
--
--   editor.model = {expression="112233", type="string"}
--   =>
--     editVar("myVar", "112233")
--
--   editor.model = {expression="112233", type="number/table"}
--   =>
--     editVar("myVar", 112233)
--[[
  function editVar(name, expression)
    local value = UI:getVariable(name)
    if type(expression) == "function" then
      value = expression(value)
    else
      value = expression
    end
    UI:setVariable(name, value)
  end
--]]

function M.checkLCD(value)
  if string.len(value) > 7 then  --check if string lenght is larger than 8 (maximum number to be displayed in the LCD
    return string.sub(value, -7) -- shows the last 8 digits of the string only
  end
  return value
end
--
-- createDica, onButton[1..3], onOK, onClear can be created in action editor
--
--   edit variable if associated with dynamic text, update the text too
--   editVar("LCD", UI.mycode.checkLCD(value), "function")
--      look for layer with dynamictext
--       layer_dynamictext:update()
--
-- editVar("numDica", function(value) return math.random(1.3) ..math.random(1,3) end)
-- hide("Win")
function M:createDica(UI)
  local value = math.random(1,3)..math.random(1,3)..math.random(1,3)..math.random(1,3)..math.random(1,3)..math.random(1,3)..math.random(1,3)..math.random(1,3)
  textodica_dynamictext:update(value)
  --
  -- hide Win
  --
  local obj    = UI.sceneGroup[_Win]
  obj.isVisible = false
end

-- see here UI.mucode is used
--   editor.model = {expression ="UI.mycode.checkLCD(value..'1')", type="function"}
--   =>
--     editVar("LCD", function(value) return UI.mycode.checkLCD(value..'1') end)
function M:onButton1(UI)
  local value = UI:getVariable(_LCD)
  value = self.checkLCD(value.."1")
  Texto_dynamictext:update(value)
end

-- editVar("LCD", function (value) return UI.mycode.checkLCD(value..'2')end)
function M:onButton2(UI)
  local value = UI:getVariable(_LCD)
  value = self.checkLCD(value.."2")
  Texto_dynamictext:update(value)
end

-- editVar("LCD", function(value) return UI.mycode.checkLCD(value..'3')end)
function M:onButton3(UI)
  local value = UI:getVariable(_LCD)
  value = self.checkLCD(value.."3")
  Texto_dynamictext:update(value)
end

-- if isEqual("LCD", "numDica") then
--    show("Win")
function M:onOK(UI)
  local obj        = UI.sceneGroup[_Win]
  local value1, value2 = UI:getVariable(_LCD), UI:getVariable(_numDica)
  if value1 == value2 then
    --
    -- show Win
    --
    obj.isVisble = true
  end
end

-- editVar("LCD", "")
function M:onClear(UI)
  Texto_dynamictext:update("")
end

return M