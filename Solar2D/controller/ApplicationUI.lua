local M = {}

--local Application = require("Application")
local handlerCommon = require("controller.commonComponentHandler")
local handlerScene = require("controller.sceneHandler")
local handlerComponent = require("controller.componentHandler")
local handlerComponentLocal = require("controller.componentLocalHandler")


function M.create(scene, model)
    local UI = {}
    UI.scene            = scene
    UI.sceneGroup       = display.newGroup()
    UI.commmonHandler = handlerCommon.new(UI)
    UI.sceneHandler = handlerScene.new(UI)
    UI.componentHandler = handlerComponent.new(UI)
    UI.componentLocalHandler = handlerComponentLocal.new(UI)
    --UI.currentBook       = model.appName
    --print("0000000000000000", UI.currentBook)
    UI.page              = model.page
    UI.curPage           = model.pageNum
    -- All components on a table
    UI.props = {}  -- this is appProps. This is set when scene.book01.index is created in ApplicationContext.lua
    UI.layers = {}
    -- All audio files on a table
    UI.audios           = {}
    UI.audios.kAutoPlay = 0
    UI.tSearch          = nil
    UI.taben            = {}
    UI.tabjp            = {}
    UI.tSearch          = nil

    ---
    function UI:dispatchEvent(params)
      params.name = self.page .."."..params.name
     self.scene.app:dispatchEvent(params)
    end
    ---
    --UI.numberOfPages         = #Application.scenes -- number of pages in the project
    --
    function UI:setLanguge()
        if self.props.lang == "" then self.props.lang = "en" end
        -- Language switch
        if (self.props.lang == "en") then self.tSearch = self.taben end
        -- Language switch
        if (self.props.lang == "jp") then self.tSearch = self.tabjp end
    end

    local function callComponentsLayersHandler(models, handler, funcName)
        -- print("callComponentsLayersHandler")
        local function iterator(handler, parent, layers, path)
            --print("callComponentsLayersHandler", #layers)
            local classEntries = {}
            if type(layers) == "table" then
                local parentPath = path or ""
                for i = 1, #layers do  -- { {childOne = {}}, {childTwo={class={"linear"}}, {childThree = {{childFour={}}}} }
                    local layer = layers[i]
                    for name, value in pairs(layer) do  --
                        -- print("", name, value)
                        -- print("", "string")
                        if type(value)=="table" and #value > 0 then
                          if funcName == "_init" then
                            handler[funcName](handler, nil,
                                            parentPath .. name .. ".index", false, value) -- value is array of children
                          else
                            handler[funcName](handler, nil,
                                            parentPath .. name .. ".index", false)
                          end
                          local ret = iterator(handler, name, value, -- value is array of children
                                                parentPath .. name .. ".")

                          for j = 1, #ret do
                              handler[funcName](handler, ret[j].class, ret[j].path,
                                              false)
                          end
                        else
                          if value.class then
                            for k, class in pairs(value.class) do
                                --print("", class, parentPath .. name)
                                table.insert(classEntries, {
                                    class = class,
                                    path = parentPath .. name
                                })
                                -- handler[funcName](handler, class, parentPath .. name, false)
                            end
                          end
                          handler[funcName](handler, nil, parentPath .. name, false)
                        end
                        -- print("", value, parent)
                    end
                end
            end
            return classEntries
        end
        local ret = iterator(handler, nil, models, nil)
        for j = 1, #ret do
            handler[funcName](handler, ret[j].class, ret[j].path, false)
        end
    end

    local function callComponentsHandler(models, handler, funcName)
        for class, entries in pairs(models) do
            -- print("", class, #entries) -- ex name:pages, entries:{"bookstore"}
            if class == "audios" then
              if entries.long then
              for k=1, #entries.long do
                handler[funcName](handler, "audios.long", entries.long[k], false)
              end
              end
              if entries.short then
                for k=1, #entries.short do
                  handler[funcName](handler, "audios.short", entries.short[k], false)
                end
              end
            elseif (class ~="layers") then
              -- fonts? particles, sprites, videos
              for k=1, #entries do
                handler[funcName](handler, class, entries[k], false)
              end
            end
        end
    end

    local function callCommonComponentHandler(models, handler, funcName)
      for k=1, #models do
        handler[funcName](handler, nil, models[k], false)
      end
  end

    --[[
      main.lua
      -----
      local common = {commands = {"myEvent"}, components = {"myComponent"}}
      require("controller.index").bootstrap({name="book", sceneIndex = 1, position = {x=0, y=0}, common =common}) -- scenes.index
      ----

      this boostrap's props is attached to scene by scene:setProps in ApplicationContext.lua

      --]]


    function UI:init()
        --print("ApplicationUI:init")
        --for k, v in pairs( model.components) do print(k, v) end
        --print ("---------------")
        callComponentsLayersHandler(model.components.layers, self.sceneHandler, "_init")
        callComponentsHandler(model.components, self.componentLocalHandler, "_init")
        if self.scene.UI.props.common then
          callCommonComponentHandler(self.scene.UI.props.common.components, self.commmonHandler, "_init")
        end
    end
    --
    function UI:create(params)
        -- self:_create("common", const.page_common, false)
        self:init()
        self:setLanguge()
        self.sceneEventParams = params
        callComponentsLayersHandler(model.components.layers, self.sceneHandler, "_create")
        callComponentsHandler(model.components, self.componentLocalHandler, "_create")
        if self.scene.UI.props.common then
          callCommonComponentHandler(self.scene.UI.props.common.components, self.commmonHandler, "_create")
        end
    end
    --
    function UI:willShow(params)
        -- self:_didShow("common", const.page_common, false)
        self.sceneEventParams = params
        callComponentsLayersHandler(model.components.layers, self.sceneHandler, "_willShow")
        callComponentsHandler(model.components, self.componentLocalHandler, "_willShow")
        if self.scene.UI.props.common then
          callCommonComponentHandler(self.scene.UI.props.common.components, self.commmonHandler, "_willShow")
        end
    end
    --
    function UI:didShow(params)
        -- self:_didShow("common", const.page_common, false)
        self.sceneEventParams = params
        callComponentsLayersHandler(model.components.layers, self.sceneHandler, "_didShow")
        callComponentsHandler(model.components, self.componentLocalHandler, "_didShow")
        if self.scene.UI.props.common then
          callCommonComponentHandler(self.scene.UI.props.common.components, self.commmonHandler, "_didShow")
        end
        if self.onComplete then
            -- for unit test, see suite_page1_group
            timer.performWithDelay(500, self.onComplete)
        end
    end
    function UI:willHide(params)
        -- self:_didShow("common", const.page_common, false)
        self.sceneEventParams = params
        callComponentsLayersHandler(model.components.layers, self.sceneHandler, "_willHide")
        callComponentsHandler(model.components, self.componentLocalHandler, "_willHide")
        if self.scene.UI.props.common then
          callCommonComponentHandler(self.scene.UI.props.common.components, self.commmonHandler, "_willHide")
        end
    end
    --
    function UI:didHide(params)
        self.sceneEventParams = params
        callComponentsLayersHandler(model.components.layers, self.sceneHandler, "_didHide")
        callComponentsHandler(model.components, self.componentLocalHandler, "_didHide")
        if self.scene.UI.props.common then
          callCommonComponentHandler(self.scene.UI.props.common.components, self.commmonHandler, "_didHide")
        end
    end
    --
    function UI:destroy(params)
        self.sceneEventParams = params
        callComponentsLayersHandler(model.components.layers, self.sceneHandler, "_destroy")
        callComponentsHandler(model.components, self.componentLocalHandler, "_destroy")
        if self.scene.UI.props.common then
          callCommonComponentHandler(self.scene.UI.props.common.components, self.commmonHandler, "_destroy")
        end
    end
    --
    function UI:touch(event) print("event.name: " .. event.name) end

    function UI:resume(params)
        self.sceneEventParams = params
        callComponentsLayersHandler(model.components.layers, self.sceneHandler, "_resume")
        callComponentsHandler(model.components, self.componentLocalHandler, "_resume")
        if self.scene.UI.props.common then
          callCommonComponentHandler(self.scene.UI.props.common.components, self.commmonHandler, "_resume")
        end
    end
    --
    return UI
end

return M