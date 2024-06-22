local current = ...
local parent, root = newModule(current)
local M = require("editor.parts.baseProps").new()
---------------------------
local assetTable = require("editor.asset.assetTable")

M.name = "textProps"
M.class = "audio"
M.type = "line" -- sequenceData
local obj, sentenceDir

function M:setActiveProp(value)
  local UI = self.UI
  assetTable:hide()
  local name =self.activeProp or ""
  for i,v in next, self.objs or {} do
    if v.text == name then -- should be _filename
      v.field.text = value
    elseif v.text == "sentenceDir" then
      sentenceDir = value:sub(1, value:len()-4)
      v.field.text = sentenceDir
    end
    print(v.text)
  end
  --print("Warning activeProp name is not found for", self.activeProp)

  --  update listbox by reading timecodes txt
  --    check word.mp3 in sentenceDir
  local listbox = require(parent.."listbox")

  local path = "App/" .. UI.book.."/assets/audios/"..value
  local sentenceDirPath = "App/"..UI.book.."/assets/audios/"..sentenceDir


  local entries = self:read(path)
  for i, v in next, entries do
    print(sentenceDir.."/"..v.file)
    if system.pathForFile(sentenceDirPath.."/"..v.file,  system.ResourceDirectory ) == nil then
      v.file =""
    end
    listbox:setValue(entries, self.type)
  end

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
          table.insert(data, {start = string.format("%.3f",tonumber(startTime)), out = string.format("%.3f",tonumber(endTime)), name = name, file=name:lower()..".mp3", action=""})
      else
          print("Invalid line format: " .. line)
      end
  end

  -- Close the file
  file:close()

  -- Print the parsed data (you can modify this part as needed)
  for _, entry in ipairs(data) do
      print(string.format("start: %.3f, end: %.3f, name: %s", entry.start, entry.out, entry.name))
  end
  return data
end

function M:getValue()
  local ret = {}
  for i, v in next, self.objs do
    local key, value = v.text,  v.field.text
    if key == "_filename" then
      key = "filename"
    end
    ret[key] = value
    print("", key, value)
  end
  return ret
end

function M:showThumnail()
end

return M