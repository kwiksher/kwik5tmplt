local Context = require "extlib.robotlegs.Context"
local Class = {}
--
function Class.new()
    local context = Context:new()
    context.Router = {}
    --
    function context:init(scenes)
        --
        -- creat all the contexts of scenes
        --
        for i=1, #scenes do
            print(scenes[i])
            local scene = require("scenes."..scenes[i]..".index")
            local model = scene.model
            model.pageNum = k
            --
            local events = scene:getEvents()
            --
            self:mapMediator("scenes."..model.name..".index", "mediators."..model.name.."Mediator")
            --
            for k, eventName in pairs(events) do
                self:mapCommand(model.name.."."..eventName, "commands."..model.name.."."..eventName)
            end
        end
        -- app init command
        self:mapCommand("app.Ads", "commands.app.Ads")
        self:mapCommand("app.bookmark", "commands.app.bookmark")
        -- self:mapCommand("app.coronaViewer", "commands.app.coronaViewer")
        self:mapCommand("app.droidHWKey", "commands.app.droidHWKey")
        -- self:mapCommand("app.expDir",       "commands.app.expDir")
        self:mapCommand("app.extCodes", "commands.app.extCodes")
        self:mapCommand("app.kwkVar", "commands.app.kwkVar")
        -- self:mapCommand("app.loadLib",      "commands.app.loadLib")
        -- self:mapCommand("app.memoryCheck",  "commands.app.memoryCheck")
        self:mapCommand("app.statusBar", "commands.app.statusBar")
        self:mapCommand("app.suspend", "commands.app.suspend")
        -- self:mapCommand("app.variables",    "commands.app.variables")
        -- self:mapCommand("app.versionCheck", "commands.app.versionCheck")
        --
        self:mapMediator("Application", "contexts.ApplicationMediator")
        --
        Runtime:dispatchEvent({name = "startup"})
    end
    --
    function context:addInitializer(t)
        local t = require(t)
        for k, v in pairs(t) do self.Router[k] = v end
    end
    --
    return context
end
--
return Class
