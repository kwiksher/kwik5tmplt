local M = require("editor.parts.baseProps").new()
---------------------------
local assetTable = require("editor.asset.assetTable")

M.name = "textProps"
M.class = "audio"
local obj

function M:setActiveProp(value)
  assetTable:hide()
  local name =self.activeProp or ""
  for i,v in next, self.objs or {} do
    if v.text == name then -- should be _filename
      v.field.text = value
    elseif v.text == "sentenceDir" then
      v.field.text = value:sub(1, value:len()-4)
    end
    print(v.text)
  end
  --print("Warning activeProp name is not found for", self.activeProp)

  -- TODO
  --  update listbox by reading timecodes txt
  --    check word.mp3 in sentenceDir
end


function M:read(path)
  -- Read the file
  local path = system.pathForFile( path, system.ResourceDirectory)

  local file = io.open(path, "r")

  if not file then
      print("Error opening file: " .. path)
      return
  end

  -- Initialize an empty table to store the data
  local data = {}

  -- Read each line and split by spaces
  for line in file:lines() do
      local startTime, endTime, name = line:match("(%S+)%s+(%S+)%s+(%S+)")
      if startTime and endTime and name then
          table.insert(data, {start = tonumber(startTime), out = tonumber(endTime), name = name, file=name..".mp3", action=""})
      else
          print("Invalid line format: " .. line)
      end
  end

  -- Close the file
  file:close()

  -- Print the parsed data (you can modify this part as needed)
  for _, entry in ipairs(data) do
      print(string.format("start: %.3f, end: %.3f, name: %s", entry.startTime, entry.endTime, entry.name))
  end
  return data
end

return M