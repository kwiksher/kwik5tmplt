local M = {}

local _LCD     = "LCD"
local _numDica = "numDica"
local _Win     = "Win"

local Texto_dynamictext = require("App.keyboard.components.page1.layers.Texto_dynamictext")
local textodica_dynamictext = require("App.keyboard.components.page1.layers.Texto_dynamictext")

-- checkLCD is an ext code
function M:checkLCD(value)
  if string.len(value) > 7 then  --check if string lenght is larger than 8 (maximum number to be displayed in the LCD
    return string.sub(value, -7) -- shows the last 8 digits of the string only
  end
  return value
end
--
-- createDica, onButton[1..3], onOK, onClear can be created in action editor
--
--   edit variable if associated with dynamic text, update the text too
--   editVar("LCD")
--      look for layer with dynamictext
--       layer_dynamictext:update()
--
function M:createDica(UI)
  local value = math.random(1,3)..math.random(1,3)..math.random(1,3)..math.random(1,3)..math.random(1,3)..math.random(1,3)..math.random(1,3)..math.random(1,3)
  textodica_dynamictext:update(value)
  --
  -- hide Win
  --
  local obj    = UI.sceneGroup[_Win]
  obj.isVisble = false
end

function M:onButton1(UI)
  local value = UI:getVariable(_LCD)
  value = self:checkLCD(value.."1")
  Texto_dynamictext:update(value)
end

function M:onButton2(UI)
  local value = UI:getVariable(_LCD)
  value = self:checkLCD(value.."2")
  Texto_dynamictext:update(value)
end

function M:onButton3(UI)
  local value = UI:getVariable(_LCD)
  value = self:checkLCD(value.."3")
  Texto_dynamictext:update(value)
end

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

function M:onClear(UI)
  Texto_dynamictext:update("")
end

return M