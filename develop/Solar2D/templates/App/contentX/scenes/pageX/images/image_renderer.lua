-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K = require "Application"

-- Infinity background animation
local function infinityBack(self, event)
    local xd, yd = self.x, self.y
    if (self.direction == "left" or self.direction == "right") then
        xd = self.width
        if (self.distance ~= nil) then
            xd = self.width + self.distance
        end
    elseif (self.direction == "up" or self.direction == "down") then
        yd = self.height
        if (self.distance ~= nil) then
            yd = self.height + self.distance
        end
    end
    if (self.direction == "left") then --horizontal loop
        if self.x < (-xd + (self.speed * 2)) then
            self.x = xd
        else
            self.x = self.x - self.speed
        end
    elseif (self.direction == "right") then --horizontal loop
        if self.x > (xd - (self.speed * 2)) then
            self.x = -xd
        else
            self.x = self.x + self.speed
        end
    elseif (self.direction == "up") then --vertical loop
        if self.y < (-yd + (self.speed * 2)) then
            self.y = yd
        else
            self.y = self.y - self.speed
        end
    elseif (self.direction == "down") then --vertical loop
        if self.y > (yd - (self.speed * 2)) then
            semlf.y = -yd
        else
            self.y = self.y + self.speed
        end
    end
end


local function createInifinityImage(model)
    local obj_2 = display.newImageRect(_K.imgDir .. model.image, _K.systemDir, model.width, model.height)
    return obj_2
end

local function setInifinityImage(obj_2, model)
    if obj_2 == nil then
        return
    end

    obj_2.blendMode = model.blend
    obj_2.anchorX = 0
    obj_2.anchorY = 0

    _K.repositionAnchor(obj_2, 0, 0)

    if model.up then
        if model.distnace then
            obj_2.y = obj.height + model.distance
            obj_2.x = obj.oriX
            obj.distance = model.distance
            obj_2.distance = model.distance
        else
            obj_2.y = obj.height
            obj_2.x = obj.oriX
        end
        obj_2.enterFrame = infinityBack
        obj_2.speed = model.infinitySpeed
        obj_2.direction = model.direction
    end

    if model.down then
        if model.distnace then
            obj_2.y = -obj.height - model.distance
            obj_2.x = obj.oriX
            obj.distance = model.distance
            obj_2.distance = model.distance
        else
            obj_2.y = -obj.height
            obj_2.x = obj.oriX
        end
        obj_2.enterFrame = infinityBack
        obj_2.speed = model.infinitySpeed
        obj_2.direction = model.direction
    end

    if model.right then
        if model.distnace then
            obj_2.x = -obj.width + model.distance
            obj_2.y = obj.oriY
            obj.distance = model.distance
            obj_2.distance = model.distance
        else
            obj_2.x = -obj.width
            obj_2.y = obj.oriY
        end
        obj_2.enterFrame = infinityBack
        obj_2.speed = model.infinitySpeed
        obj_2.direction = model.direction
    end

    if model.left then
        if model.distance then
            obj_2.x = obj.width + model.distance
            obj_2.y = obj.oriY
            obj.distance = model.distance
            obj_2.distance = model.distance
        else
            obj_2.x = obj.width
            obj_2.y = obj.oriY
        end
        obj_2.enterFrame = infinityBack
        obj_2.speed = model.infinitySpeed
        obj_2.direction = model.direction
    end
    return obj_2
end

local function createImage(model)
    local obj = display.newImageRect(_K.imgDir .. model.image, _K.systemDir, model.width, model.height)
    --
    return obj
end

local function setImage(obj, model)
    if obj == nil then
        return
    end
    --
    obj.imagePath = model.image
    obj.x = model.x
    obj.y = model.y
    obj.alpha = model.alpha
    obj.oldAlpha = model.alpha
    obj.blendMode = model.blend

    if model.randXStart then
        obj.x = math.random(model.randXStart, model.randXEnd)
    end

    if model.randYStart then
        obj.y = math.random(model.randYStart, model.randYEnd)
    end

    if model.scaleW then
        obj.xScale = model.scaleW
    end

    if model.scaleH then
        obj.yScale = model.scaleH
    end

    if model.rotate then
        obj:rotate(model.rotate)
    end

    obj.oriX = obj.x
    obj.oriY = obj.y
    obj.oriXs = obj.xScale
    obj.oriYs = obj.yScale
    obj.name = model.name

    --
    if model.infinity then
        obj.anchorX = 0
        obj.anchorY = 0

        _K.repositionAnchor(obj, 0, 0)

        if model.up then
            obj.x = obj.oriX
            obj.y = 0
            obj.enterFrame = infinityBack
            obj.speed = model.infinitySpeed
            obj.direction = model.direction
        end

        if model.down then
            obj.x = obj.oriX
            obj.y = 0
            obj.enterFrame = infinityBack
            obj.speed = model.infinitySpeed
            obj.direction = model.direction
        end

        if model.right then
            obj.x = 0
            obj.y = obj.oriY
            obj.enterFrame = infinityBack
            obj.speed = model.infinitySpeed
            obj.direction = model.direction
        end

        if model.left then
            obj.x = 0
            obj.y = obj.oriY
            obj.enterFrame = infinityBack
            obj.speed = model.infinitySpeed
            obj.direction = model.direction
        end
    end

    return obj
end

--
function _M:localVars(UI)
    local model = UI.model

    if model.commonAsset then
        model.image = "p" .. UI.imagePage .. model.image
    end

    if model.bookTmplt then
        model.x, model.y, model.width, model.height, model.image = _K.getModel(model.name, model.image, UI.dummy)
    end
end

function _M:localPos(UI)
    local model      = UI.model
    local sceneGroup = UI.scene.view
    local layer      = UI.layer

    if not model.commonAsset then
        model.image = "p" .. UI.imagePage .. model.image
    end
    --
    local obj = createImage(model)
    if setImage(obj,model) then
        layer[model.name] = obj
        sceneGroup[model.name] = obj

        if model.layerAsBg then
            sceneGroup:insert(1, obj)
        else
            sceneGroup:insert(obj)
        end
    end

    if model.infinity then
        local obj_2 = createInifinityImage(model)
        if setInfinityImage(obj_2, model) then
            sceneGroup:insert(obj_2)
            sceneGroup[model.name .. "_2"] = obj_2
        end
    end
    --
end
--
function _M:didShow(UI)
    local model      = UI.model
    local sceneGroup = UI.scene.view
    local layer      = UI.layer

    _K.activateState(obj, setImage)

    if model.infinity then
        local obj, obj_2 = layer[model.name], layer[model.name .. "_2"]
        -- Infinity background
        if obj == nil or obj_2 == nil then
            return
        end

        _K.activateState(obj_2, setInifinityImage)
        Runtime:addEventListener("enterFrame", obj)
        Runtime:addEventListener("enterFrame", obj_2)
    end
end
--
function _M:toDispose(UI)
    local model      = UI.model
    local sceneGroup = UI.scene.view
    local layer      = UI.layer

    _K.deactivateState(obj)

    if model.infinity then
        local obj, obj_2 = layer[model.name], layer[model.name .. "_2"]
        if obj == nil or obj_2 == nil then
            return
        end

        _K.deactivateState(obj_2)
        Runtime:removeEventListener("enterFrame", obj)
        Runtime:removeEventListener("enterFrame", obj_2)
    end
end
--
function _M:toDestory()
end
--
return _M
