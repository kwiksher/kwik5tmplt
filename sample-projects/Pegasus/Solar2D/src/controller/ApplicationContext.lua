local dir = ...
local parent = dir:match("(.-)[^%.]+$")
local root = parent:sub(1, parent:len()-1):match("(.-)[^%.]+$")


local function getParentPath(path)
    pattern1 = "^(.+)//"
    pattern2 = "^(.+)\\"

    if (string.match(path,pattern1) == nil) then
        return string.match(path,pattern2)
    else
        return string.match(path,pattern1)
    end
end

print("",getParentPath(parent))

local Context = require "extlib.robotlegs.Context"
local Class = {}
--
function Class.new(app)
    local appName = app.props.appName

    --app:addEventListener("onRobotlegsViewCreated", function(e) print("test") end)

    local context = Context.new(app)
    context.Router = {}

    local appDir = "App."..appName .."."
    --
    function context:init(scenes, props)
        --
        -- creat all the contexts of scenes
        --
        for i=1, #scenes do
            print(scenes[i])
            local scene = require(appDir.."scenes."..scenes[i]..".index")
            scene:setProps(props)
            scene.app = app

            local model = scene.model
            model.pageNum = i

            --
            local events = scene:getEvents()
            --
            print(appDir.."scenes."..model.name..".index", appDir.."mediators."..model.name.."Mediator")
            self:mapMediator(appDir.."scenes."..model.name..".index", appDir.."mediators."..model.name.."Mediator")
            --
            for k, eventName in pairs(events) do
                self:mapCommand(model.name.."."..eventName, appDir.."commands."..model.name.."."..eventName)
            end
            --
            print("context:init", scenes[i], scene)
            self.Router["scenes."..scenes[i]..".index"] = scene
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
        self:mapMediator(appDir.."scenes.index", "controller.ApplicationMediator") -- "Application" is a classType in Application.lua
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
