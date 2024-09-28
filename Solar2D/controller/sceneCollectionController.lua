local M = {}

local bookTable = require("editor.parts.bookTable")
local pageTable = require("editor.parts.pageTable")
local selectors = require("editor.parts.selectors")

function M.onClick(event)
  local page = event.target._sceneName
  local book = M.book
  printKeys(event.target)
  --
  selectors.projectPageSelector:show()
  selectors.projectPageSelector:onClick(true)
  bookTable.commandHandler({book=book}, nil,  true)
  pageTable.commandHandler({page=page},nil,  true)
  selectors.componentSelector.iconHander()
end

return M