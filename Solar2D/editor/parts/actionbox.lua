-- local M = require("editor.parts.linkTable")
local M = require("editor.baseProps").new()

---------------------------
M.name = "onComplete"
M.selectedTextLabel = ""
M.props = {
  -- {name="onComplete", value=""}
}
-- M.activeProp = M.props[1].name
--
-- load(UI, type, x, y, selectedValue)
--    type = {"action", "animation", "group", "audio"}
--    type.animation loads pageX/index.json to list layers
--    type.action loads the list of files in pageX/commands folder
--  see editor/util.lua read
--        setFiles(ret.audios, "/audios/short")
--        setFiles(ret.audios, "/audios/long")
--        setFiles(ret.groups, "/groups")
--        setFiles(ret.groups, "/commands")

function M:setActiveProp(value)
  local name =self.activeProp or ""
  for i,v in next, self.objs or {} do
    if v.text == name then
      v.field.text = value
      return
    end
  end
end

    -- if self.objs then
    --   for i,v in next, self.objs do
    --     print("@@@@@@@", v.text)
    --     if v.text == name then
    --       v.field.text = value
    --     end
    --   end
    -- end

function M:setValue(_name, value)
  local name = _name or self.activeProp
  for i,v in next, self.props do
        if v.name == name then
          v.value = value
          return
        end
      end
end

function M:getValue(name)
  if self.objs then
    for i,v in next, self.objs do
      if v.text == name then
        return v.field.text
      end
    end
  end
end

return M