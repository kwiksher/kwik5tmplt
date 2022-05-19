local M = {}

--local Application = require("Application")
local handlerScene = require("controller.sceneEventHandler")
local handlerComponent = require("controller.componentEventHandler")

function M.create(scene, model)
    local UI = {}
    UI.scene            = scene
    UI.sceneEventHandler = handlerScene.new(UI)
    UI.componentEventHandler = handlerComponent.new(UI)
    UI.page              = model.name
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
    --UI.numPages         = #Application.scenes -- number of pages in the project
    --
    function UI:setLanguge()
        if self.props.lang == "" then self.props.lang = "en" end
        -- Language switch
        if (self.props.lang == "en") then self.tSearch = self.taben end
        -- Language switch
        if (self.props.lang == "jp") then self.tSearch = self.tabjp end
    end

    local function callEventHandler(models, self, funcName)
        -- print("callEventHandler")
        local function iterator(self, parent, layers, path)
            --print("callEventHandler", #layers)
            local children = {}
            if type(layers) == "table" then
                local parentPath = path or ""
                for i = 1, #layers do
                    local layer = layers[i]
                    for name, value in pairs(layer) do
                       -- print("", name, value)
                        -- print("", "string")
                        if value.events then
                            -- do nothing
                        end
                        if value.types then-- TODO change it to value.class
                            for k, type in pairs(value.types) do
                                -- print("", type, parentPath .. name)
                                table.insert(children, {
                                    type = type,
                                    path = parentPath .. name
                                })
                                -- self[funcName](self, type, parentPath .. name, false)
                            end
                        end

                        if #value == 0 then
                            self[funcName](self, nil, parentPath .. name, false)
                        else
                            self[funcName](self, nil,
                                           parentPath .. name .. ".index", false)
                            local ret = iterator(self, name, value,
                                                 parentPath .. name .. ".")

                            for j = 1, #ret do
                                self[funcName](self, ret[j].type, ret[j].path,
                                               false)
                            end

                        end
                        -- print("", value, parent)
                    end
                end
            end
            return children
        end
        local ret = iterator(self, nil, models, nil)
        for j = 1, #ret do
            self[funcName](self, ret[j].type, ret[j].path, false)
        end
    end

    function UI:init()
        print("##### UI:init", #model.components)
        callEventHandler(model.layers, self.sceneEventHandler, "_init")
        callEventHandler(model.components, self.componentEventHandler, "_init")
    end
    --
    function UI:create(params)
        -- self:_create("common", const.page_common, false)
        self:init()
        self:setLanguge()
        self.sceneEventParams = params
        callEventHandler(model.layers, self.sceneEventHandler, "_create")
        callEventHandler(model.components, self.componentEventHandler, "_create")
    end
    --
    function UI:willShow(params)
        -- self:_didShow("common", const.page_common, false)
        self.sceneEventParams = params
        callEventHandler(model.layers, self.sceneEventHandler, "_willShow")
        callEventHandler(model.components, self.componentEventHandler, "_willShow")
    end
    --
    function UI:didShow(params)
        -- self:_didShow("common", const.page_common, false)
        self.sceneEventParams = params
        callEventHandler(model.layers, self.sceneEventHandler, "_didShow")
        callEventHandler(model.components, self.componentEventHandler, "_didShow")
    end
    function UI:willHide(params)
        -- self:_didShow("common", const.page_common, false)
        self.sceneEventParams = params
        callEventHandler(model.layers, self.sceneEventHandler, "_willHide")
        callEventHandler(model.components, self.componentEventHandler, "_willHide")
    end
    --
    function UI:didHide(params)
        self.sceneEventParams = params
        callEventHandler(model.layers, self.sceneEventHandler, "_didHide")
        callEventHandler(model.components, self.componentEventHandler, "_didHide")
    end
    --
    function UI:destroy(params)
        self.sceneEventParams = params
        callEventHandler(model.layers, self.sceneEventHandler, "_destroy")
        callEventHandler(model.components, self.componentEventHandler, "_destroy")
    end
    --
    function UI:touch(event) print("event.name: " .. event.name) end

    function UI:resume(params)
        self.sceneEventParams = params
        callEventHandler(model.layers, self.sceneEventHandler, "_resume")
        callEventHandler(model.components, self.componentEventHandler, "_resume")
    end
    --
    return UI
end

return M