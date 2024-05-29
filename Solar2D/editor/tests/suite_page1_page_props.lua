local M = {}

local selectors
local UI
local bookTable
local pageTable
local layerTable

function M.init(props)
  selectors = props.selectors
  UI        = props.UI
  bookTable = props.bookTable
  pageTable = props.pageTable
  layerTable = props.layerTable
end

function M.suite_setup()
  selectors.projectPageSelector:show()
  selectors.projectPageSelector:onClick(true)
  --
  -- UI.scene.app:dispatchEvent {
  --   name = "editor.selector.selectApp",
  --   UI = UI
  -- }
  -- appFolder = system.pathForFile("App", system.ResourceDirectory) -- default
  -- useTinyfiledialogs = false -- default
  ---
  bookTable.commandHandler({book="book"}, nil,  true)
  pageTable.commandHandler({page="page1"},nil,  true)
  selectors.componentSelector.iconHander()
  -- selectors.componentSelector:onClick(true,  "layerTable")
end

local function selectIcon(toolGroup, tool)
  local toolbar = UI.editor.toolbar
  local obj = toolbar.layerToolMap[toolGroup]
  obj.callBack{target=obj}
  if tool then
    local obj = toolbar.toolMap[obj.id.."-"..tool]
    obj.callBack{target=obj}
  end
end

function M.setup()
end

function M.teardown()
end

---[[
function M.test_settings()
  --timer.performWithDelay(1000,function()
   selectIcon("Page", "addPage")
  --selectIcon("Page", "Properties")
  -- selectIcon("Page", "Language")
  --selectIcon("Page", "setLanguage")
  -- end)

    -- UI.scene.app:dispatchEvent(
    --   {
    --     name = "editor.selector.selectPageProps",
    --     UI = UI,
    --   }
    -- )

    -- print("------")
    -- for k, v in pairs(event) do print(k, v) end
    -- print(currentOrientation, display.contentCenterX, display.contentCenterY)
    -- print("content", display.contentWidth, display.contentHeight)
    -- print("actural", display.actualContentWidth, display.actualContentHeight)
    -- print("safe", display.safeActualContentWidth, display.safeActualContentHeight)
    -- print("1920x1280", 1920/4, 1280/4)
    -- print("scene", rootGroup.x, rootGroup.y)
    -- print("scene bounds",rootGroup.contentBounds.xMin, rootGroup.contentBounds.xMax, rootGroup.contentBounds.yMin, rootGroup.contentBounds.yMax)
    -- print("anchor", rootGroup.anchorX, rootGroup.anchorY)

  --rootGroup.anchorChildren = true
  --rootGroup.x, rootGroup.y = display.contentCenterX, display.contentCenterY

    --rootGroup:rotate(10)
  --rootGroup.x, rootGroup.y = -(display.contentHeight/2-display.contentCenterX), -(display.contentWidth/2-display.contentCenterY)
  -- rootGroup.anchorX = rootGroup.x/480
  -- rootGroup.anchorY = -rootGroup.y/320
  --rootGroup:scale(reverse, re)

  -- rootGroup.anchorX = (display.contentCenterX-rootGroup.contentBounds.xMin) / (rootGroup.contentBounds.xMax-rootGroup.contentBounds.xMin)
  -- rootGroup.anchorY = (display.contentCenterY-rootGroup.contentBounds.yMin) / (rootGroup.contentBounds.yMax-rootGroup.contentBounds.yMin)

        --------------------
    -- local rootGroup = self.UI.rootGroup
    -- local center = display.newCircle(display.contentCenterX-rootGroup.contentBounds.xMin, display.contentCenterY-rootGroup.contentBounds.yMin, 10)

    -- local w = rootGroup.contentBounds.xMax-rootGroup.contentBounds.xMin
    -- local h = rootGroup.contentBounds.yMax-rootGroup.contentBounds.yMin
    -- -- local anchor = display.newCircle(rootGroup.contentBounds.xMin + w/2, rootGroup.contentBounds.yMin + h/2, 10)
    -- local anchor = display.newCircle(rootGroup.x, rootGroup.y, 10)

    -- -- rootGroup:rotate(10)

    -- anchor:setFillColor(1,0,0)
    -- local rect = display.newRect(rootGroup.x, rootGroup.y, w, h)
    -- rect:setFillColor(0,0,1)
    -- rect.alpha = 0.3

  end
--]]



return M