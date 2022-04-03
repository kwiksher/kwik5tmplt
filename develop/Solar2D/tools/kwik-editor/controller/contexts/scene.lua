local M = {}
local UI = require("contexts.ApplicationUI")

local composer = require("composer")
composer.recycleOnSceneChange = true

M.new = function(sceneName, model)
    local scene = composer.newScene(sceneName)
    scene._composerFileName = nil
    local componentFolder = sceneName:gsub(".index", "")
    scene.classType = "scenes." .. sceneName
    scene.UI = UI.create(scene, model)
    scene.model = model
    ------------------------------------------------------------
    ------------------------------------------------------------
    function scene:create(event)
        local sceneGroup = self.view
        if self.model.onInit then self.model.onInit(self) end
        self.UI:create(self, event.params)
        Runtime:dispatchEvent({name = "onRobotlegsViewCreated", target = self})
    end
    --
    function scene:show(event)
        local sceneGroup = self.view
        if event.phase == "will" then
            self.UI:willShow(self, event.params)
        elseif event.phase == "did" then
            self.UI:didShow(self, event.params)
        end
    end
    --
    function scene:hide(event)
        if event.phase == "will" then
            if event.parent then event.parent.UI:resume() end
            self.UI:didHide(self, event.params)
        elseif event.phase == "did" then
        end
    end
    --
    function scene:destroy(event)
        self.UI:destroy(self, event.params)
        Runtime:dispatchEvent({name = "onRobotlegsViewDestroyed", target = self})
    end
    --
    scene:addEventListener("create", scene)
    scene:addEventListener("show", scene)
    scene:addEventListener("hide", scene)
    scene:addEventListener("destroy", scene)
    --
    function scene:getEvents()
        local events = {}
        -- local events = {"initMenu","printStack",
        --    "layersList.select", "layersList.drag",
        --    "layerProps.new", "layerProps.update","layerProps.attachFile", "layerProps.drag"
        -- }
        local function iterator(layers)
            if type(layers) == "table" then
                for i = 1, #layers do
                    local layer = layers[i]
                    for name, value in pairs(layer) do
                        --print(name, #value)
                        -- print("", "string")
                        if value.events then
                            for k, eventName in pairs(value.events) do
                               -- print("", name .. "." .. eventName)
                                table.insert(events,
                                             name .. "." .. eventName)
                            end
                        elseif value.types then
                            -- do nothing
                        else
                            if #value == 0 then
                                -- do nothing
                            else
                                iterator(value)
                            end
                            -- print("", value, parent)
                        end
                    end
                end
            end
        end
        -- for layers
        iterator(self.model.layers)
        for i=1, #self.model.events do
            table.insert(events, self.model.events[i])
        end
        return events
    end
    return scene

end

return M
