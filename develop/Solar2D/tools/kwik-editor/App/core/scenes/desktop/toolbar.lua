local M = {}
M.name = ...
M.weight = 1
---
local muiIcon = require("components.mui.icon").new()
local util = require("lib.util")
local mui = require("materialui.mui")


---
function M:init(UI) end
--
function M:create(UI)
    print("create", self.name)

    local models = {
        {
            name = "Properties",
            icon = "toolPage",
            tools = {
                {name = "Properties", icon = "LayerProp"},
                {name = "Language", icon = "Lang"},
                {name = "setLanguage", icon = "setLang"}
            }
        }, {
            name = "Replacements",
            icon = "toolLayer",
            tools = {
                {name = "Particles", icon = "repParticles"},
                {name = "Counter", icon = "repCounter"},
                {name = "DynamicText", icon = "repDyn"},
                {name = "InputText", icon = "repInput"},
                {name = "Map", icon = "repMap"},
                {name = "Mask", icon = "repMask"},
                {name = "Multiplier", icon = "repMultiplier"},
                {name = "Spritesheet", icon = "repSprite"},
                {name = "SyncTextAudio", icon = "repSync"},
                {name = "Text", icon = "repText"},
                {name = "Vector", icon = "repVector"},
                {name = "Video", icon = "repVideo"},
                {name = "Web", icon = "repWeb"}
            }
        }, {
            name = "Animations",
            icon = "toolAnim",
            tools = {
                {name = "Linear", icon = "animLinear"},
                {name = "Blink", icon = "animBlink"},
                {name = "Bounce", icon = "animBounce"},
                {name = "Filter", icon = "animFilter"},
                {name = "Path", icon = "animPath"},
                {name = "Pulse", icon = "animPulse"},
                {name = "Rotation", icon = "animRotation"},
                {name = "Shake", icon = "animShake"},
                {name = "Switch", icon = "animSwitch"}
            }
        }, {
            name = "Interactions",
            icon = "toolInter",
            tools = {
                {name = "Button", icon = "intButton"},
                {name = "Canvas", icon = "intCanvas"},
                {name = "Drag", icon = "intDrag"},
                {name = "Pinch", icon = "intPinch"},
                {name = "Parallax", icon = "intParallax"},
                {name = "Scroll", icon = "intScroll"},
                {name = "Spin", icon = "intSpin"},
                {name = "Shake", icon = "intShake"},
                {name = "Swipe", icon = "intSwipe"}
            }
        }, {
            name = "Physics",
            icon = "toolPhysics",
            tools = {
                {name = "Properites", icon = "PhyProp"},
                {name = "Body", icon = "PhyBody"},
                {name = "Collision", icon = "PhyColl"},
                {name = "Forcwe", icon = "PhyForce"},
                {name = "Joint", icon = "PhyJoint"}
            }
        }
    }

    local categoryMap = {}
    local toolMap = {}

	local toolListener = function(event)
        print(event.target.muiOptions.name)
		for k, v in pairs(toolMap) do
            if k ~= event.target.muiOptions.name then
                mui.turnOnButtonByName(k)
			else
				--
				-- dispatchEvent to display AnimationEditor, overlay?
				--   hide EditpPropsTable (Layer Props)?

                UI.currentTool = event.target.muiOptions.name

                UI.scene:dispatchEvent({
                    name = "sidepanel.selectTool",
                    UI = UI
                })

				--
			end
		end
	end

    local lastTool
    --
    local listener = function(event)
        print(event.target)
		--
		for k, v in pairs(toolMap) do
			v:removeSelf()
		end
		toolMap = {}
        -- for k, v in pairs(event.target.muiOptions) do print(k, v) end
        for k, v in pairs(categoryMap) do
            if k ~= event.target.muiOptions.name then
                mui.turnOnButtonByName(k)
			else
				for i=1, #v.tools do
					local tool = v.tools[i]
					local obj = muiIcon:createToolImage{
						icon = tool.icon,
						name = self.name .. "-" .. tool.name,
                        --text = tool.name,
                        hoverText = tool.name,
						x = lastTool.x + lastTool.width + i * 30,
						y = 0,
						width = 36,
						height = 36,
						listener =toolListener
					}
					toolMap[self.name .. "-" .. tool.name] =  obj
				end
            end
        end

		--
    end

    for k, v in pairs(models) do
        local obj = muiIcon:createImage{
            icon = v.icon,
            name = self.name .. "-" .. v.icon,
            x = display.contentCenterX/4 + k * 30,
            y = 0,
            width = 36,
            height = 36,
            listener = listener
        }
		obj.tools = v.tools
        categoryMap[self.name .. "-" .. v.icon] = obj
        lastTool = obj
    end

end
--
function M:didShow(UI) end
--
function M:didHide(UI) end
--
function M:destroy() end
--
return M

