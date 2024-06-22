local M = require("editor.parts.baseProps").new()
---------------------------
M.name = "audioProps"
M.class ="audio"

local assetTable = require("editor.asset.assetTable")

function M:showThumnail()
end

function M:setActiveProp(value)

  assetTable:hide()
  print("@@@", value)

  local name =self.activeProp or ""
  for i,v in next, self.objs or {} do
    if v.text == name then
      v.field.text = value
      print("###", self.activeProp, value, #self.objs, self)
      return
    end
  end
  print("Warning activeProp name is not found for", self.activeProp)
end


return M