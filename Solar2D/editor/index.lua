local path = system.pathForFile( "", system.ResourceDirectory)
package.path = package.path..';'..path..'./editor/lib/?.lua;'
-- print(package.path)

local M = {}
local current = ...
local parent = current:match("(.-)[^%.]+$")
local root = parent:sub(1, parent:len()-1):match("(.-)[^%.]+$")
--
local json = require("json")
local bt = require(parent..'controller.BTree.btree')
local tree = require(parent.."controller.BTree.selectorsTree")
--
M.lastSelection = { book="book", page="page3"}

local unitTestOn = true
local httpServerOn = true

M.rootGroup = display.newGroup()
M.viewStore = {}
--
-- print(current, parent ,root)
--
-- commonents[i].id like "animation" calls for view.animation
--
local layerTools = require(parent.."model").layerTools
local pageTools = require(parent.."model").pageTools
local assetTool = require(parent.."model").assetTool
--
-- editor is singleton
--
M.commands = {
  {name="selectApp", btree=nil},
  {name="selectBook", btree="load book"},
  {name="selectPage", btree="load page"},
  {name="selectLayer", btree="load layer"},
  {name="selectPageProps", btree=nil},
  -- {name="selectAction", btree=""},
  {name="selectTool", btree="editor component"},
  -- {name="selectActionCommand", btree=""}
  {name="selectAudio", btree="load audio"},
  {name="selectGroup", btree="load group"},
  {name="selectTimer", btree="load timer"},
  {name="selectVariable", btree="load variable"},
  {name="selectJoint", btree="load joint"},

  -- {name="selectVideo", btree="load video"},

}

-- connects with BTree ----
local BTMap = {}
for i=1, #M.commands do
  if M.commands[i].btree then
    BTMap[M.commands[i].btree] ={eventName = "editor.selector."..M.commands[i].name, name = M.commands[i].name}
  end
end
-- BTree calls this when activating actionNode
M.BThandler = function(name, status)
  print("#BTHandler: dispathEvent")
  --  print("", name,  bt.getFriendlyStatus( nil,status ))
  local target = BTMap[name]
  -- print("", target)
  if  target and M.UI then
    print("", target.eventName)
    --local obj = M.UI.editor.rootGroup[target.name]
    local params = {
      name = target.eventName,
      UI = M.UI, -- beaware UI is belonged to a page
      -- show = not obj.isVisible,
    }
    if tree.backboard then
      for k, v in pairs(tree.backboard) do
        print("", k, v)
        params[k] = v
      end
    end
    M.UI.scene.app:dispatchEvent(params)
  end
  return bt.SUCCESS
end
--
-- See selects.lua selectorBase.new, store = "xxxTable"
--
M.models = {
 "selectors",
 "bookTable",
 "pageTable",
 "layerTable",
 "propsTable",
 "propsButtons",
 "toolbar",
  -- "audioTable",
  -- "groupTable",
  -- "timerTable",
  -- "variableTable"
}

M.actionViews = require(parent.."action.index").views

M.views = nil
M.rootGroup = nil

local nanostores         = require("extlib.nanostores.index")
-- local books              = nanostores.createStore()
-- local pages              = nanostores.createStore()
local layers             = nanostores.createStore()
local layerJson         = nanostores.createStore()
local groupLayers        = nanostores.createStore()
--
local props              = nanostores.createStore()
local actions            = nanostores.createStore()
local actionProps        = nanostores.createStore()
local actionCommandProps = nanostores.createStore()
--
local assets             = nanostores.createStore()
local labels             = nanostores.createStore()
--
local audios            = nanostores.createStore()
local groups            = nanostores.createStore()
local timers            = nanostores.createStore()
local variables         = nanostores.createStore()

local joints            = nanostores.createStore()


--
local App = require("Application")

local mui = require("materialui.mui")

--
-- this returns a tool obj
function M:getClassModule (class)
  local v = self.classMap[class:lower()] or class
  -- for k, v in pairs(self.editorTools) do print(k) end
  local mod = self.editorTools[v]
  if mod == nil then
    -- print("@@@@ Error to find", v)
    return self.editorTools['editor.parts.baseTable-'..v]
  end
  return mod
end

function M:getClassFolderName (class)
  print(class)
  return self.classMap[class:lower()]
end

function M:initStores()
      --
    -- selectors.lua will set values of each stores
    --
    self.bookStore = nanostores.createStore()
    self.pageStore =  nanostores.createStore()
    self.layerStore = layers
    self.layerJsonStore = layerJson
    self.propsStore = props
    self.actionStore = actions
    self.actionCommandStore = actionProps

    self.assetStore = assets
    self.labelStore = labels
    self.actionCommandPropsStore = actionCommandProps
    self.groupLayersStore = groupLayers    -- layer linkboxMulti(layersbox) is listening or set it for memberTable
    -- linkboxMulti to show not selected, memberTable shows them with true
    -- {name="layerA", selected = true}
    -- {name="layerB", selected = false}
    --
    self.audioStore = audios
    self.groupStore = groups -- TBI
    self.timerStore = timers -- TBI
    self.variableStore = variables -- TBI
    self.jointStore   = joints
end
---
function M:init(UI)
  if self.views == nil then
    self.rootGroup = display.newGroup()
    self.views = {}
    self.classMap = {}
    self.assets = {}
    --
    local app = App.get()
    for i=1, #self.commands do
      app.context:mapCommand("editor.selector."..self.commands[i].name, "editor.controller.selector."..self.commands[i].name)
    end
    for i=1, #self.models do
      self.views[i] = require(parent.."parts."..self.models[i])
    end
    for i=1, #self.actionViews do
      -- print(parent.."action."..self.actionViews[i])
      self.views[#self.views + 1] = require(parent.."action."..self.actionViews[i])
    end
    -- Here linking toolbar-xx with view.animation, ...
    self.editorTools = {}
    ------
    -- layer tool
    for i=1, #layerTools do
      if layerTools[i].id then
        local module = require(parent..layerTools[i].id..".index")
        module.id = layerTools[i].id
        self.views[#self.views + 1] = module
        self.editorTools[layerTools[i].id] = module
        for j=1, #layerTools[i].tools do
          if layerTools[i].tools[j].id then
            -- Aditional editor for particles
            self.classMap[layerTools[i].tools[j].name:lower()] = layerTools[i].id.."."..layerTools[i].tools[j].id
            -- print("@", layerTools[i].tools[j].name:lower(), layerTools[i].id.."."..layerTools[i].tools[j].id)
            --
            local module = require(parent..layerTools[i].id.."."..layerTools[i].tools[j].id..".index")
            self.views[#self.views + 1] = module
            self.editorTools[layerTools[i].id.."."..layerTools[i].tools[j].id] = module

          else
            self.classMap[layerTools[i].tools[j].name:lower()] = layerTools[i].id
            -- print("@", layerTools[i].tools[j].name:lower(), layerTools[i].id)

          end
          --print(layerTools[i].tools[j].name, layerTools[i].id)
        end
      end
    end
    -----
    -- page tool
    for k, v in pairs(pageTools) do
      if v.id then
        -- print("@@@", parent..v.id..".index")
        local module = require(parent..v.id..".index")
        self.views[#self.views + 1] = module
        self.editorTools['editor.parts.baseTable-'..v.id] = module
      end
    end

    ------
    -- asset tool
    local mod  = require(parent..assetTool.id..".index")
    self.views[#self.views + 1] = mod
    self.editorTools['editor.parts.baseTable-'..assetTool.id] = mod

    self:initStores()
    --
   UI.editor = self
   for i=1, #self.views do
    self.views[i]:init(UI)
   end
   --
    -- display.setDefault( "fillColor", 1, 0, 0 )
    -- display.setDefault( "background", 1, 1, 1, 0.01 )
    mui.init(nil, {parent = self.rootGroup, useSvg = true})

    tree:init(self.BThandler)
    tree:setConditionStatus("select book", bt.SUCCESS, true)
    tree:tick()

  end
end
--
function M:create(UI)
  UI.editor = self
  for i=1, #self.views do
    self.views[i]:create(UI)
  end
end
--

local selectors = require(parent .. "parts.selectors")
local bookTable = require(parent.."parts.bookTable")
local pageTable = require(parent.."parts.pageTable")
local layerTable = require("editor.parts.layerTable")

function M:runTest()
  local actionTable = require("editor.action.actionTable")
  require("editor.tests.index").run{
    selectors = selectors,
    UI = self.UI,
    bookTable = bookTable,
    pageTable = pageTable,
    layerTable = layerTable,
    actionTable = actionTable,
  }
  if self.UI.testCallback then
    self.UI.testCallback()
  end
end


function M:gotoLastSelection(_props)
  local UI = self.UI
  local props = {book="book", page="page1", selections={layer="cat", class="linear"}}
  -- Path for the file to read
  local path = system.pathForFile( "kwik.json", system.ApplicationSupportDirectory )
  -- Open the file handle
  local file, errorString = io.open( path, "r" )
  --
  --
  if _props then
      -- Error occurred; output the cause
      props = _props
  else
      -- Read data from file
      local contents = file:read( "*a" )
      -- Output the file contents
      -- print( "Contents of " .. path .. "\n" .. contents )
      -- Close the file handle
      io.close( file )
      props = json.decode(contents)
  end
  file = nil

  local helper = require("editor.tests.helper")
  local bookTable = require("editor.parts.bookTable")
  local pageTable = require("editor.parts.pageTable")
  local layerTable = require("editor.parts.layerTable")
  local Shapes = require("editor.controller.index").Shapes

  helper.init({bookTable = bookTable, pageTable=pageTable, layerTable=layerTable})
  --
  selectors.projectPageSelector:show()
  selectors.projectPageSelector:onClick(true)
  -- UI.scene.app:dispatchEvent {
  --   name = "editor.selector.selectApp",
  --   UI = UI
  -- }

  local obj = helper.getBook(props.book)
  bookTable.commandHandler(obj, {phase="ended"},  true)

  pageTable.commandHandler({page=props.page},{},  true)

  selectors.componentSelector.iconHander()
  selectors.componentSelector:onClick(true,  "layerTable")

  if props.selections then
    if Shapes[props.selections[1].class] then
      helper.selectLayer(props.selections[1].name)
    else
      helper.selectLayer(props.selections[1].name, props.selections[1].class)
    end
  end

  return false
end

function M:didShow(UI)
  self.UI = UI
  UI.editor = self
  for i=1, #self.views do
    self.views[i]:didShow(UI)
  end

    --
    -- default or reload
    --
    UI.editor.currentBook = UI.book
    -- UI.editor.currentPage = "page2"
    local showComponentSelector = true
    local showProjectSelector = false
    if showProjectSelector then
          selectors.projectPageSelector:show()

          -- UI.scene.app:dispatchEvent {
          --   name = "editor.selector.selectApp",
          --   UI = UI
          --   -- appFolder = system.pathForFile("App", system.ResourceDirectory) -- default
          --   -- useTinyfiledialogs = false -- default
          -- }

          -- bookTable.commandHandler({book="bookFree"},nil,  true)

          -- UI.scene.app:dispatchEvent {
          --   name = "editor.selector.selectBook",
          --   UI = UI,
          --   book = "bookFree"
          -- }
    elseif showComponentSelector then
      if not self.isReloaded then
        self.isReloaded = true
        ----------------------------
        self:gotoLastSelection(self.lastSelection)
        --------- unit test --------
        if unitTestOn then
          self:runTest()
        end
        if httpServerOn then
        --------- pegasus init with  --------
          require("server.index").run{
            selectors = selectors,
            UI = UI,
            bookTable = bookTable,
            pageTable = pageTable,
            layerTable = layerTable
          }
        end
      end
    end

    UI.editor.rootGroup:dispatchEvent{name="labelStore",
      currentBook= UI.editor.currentBook,
      currentPage= UI.page,
      currentLayer = UI.editor.currentayer}
    -- print ("------------ UI.editor.rootGroup ---------")
    -- for k, v in pairs(UI.editor.rootGroup) do print("", k) end
    -- print ("------------ UI.editor.viewStore ---------")
    -- for k, v in pairs(UI.editor.viewStore) do print("", k) end
  end
--
function M:didHide(UI)
  UI.editor = self
  for i=1, #self.views do
    self.views[i]:didHide(UI)
  end
end
--
function M:destroy(UI)
  UI.editor = self
  for i=1, #self.views do
    self.views[i]:destroy(UI)
  end
end
--
return M
