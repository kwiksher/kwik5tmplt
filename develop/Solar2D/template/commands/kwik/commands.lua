local M = {}
local marker = require("extlib.marker")

M.copyDisplayObject(src, dst, id, group)
    local obj = display.newImageRect(_K.imgDir .. src.imagePath, _K.systemDir, src.width, src.height)
    if obj == nil then
        print("copyDisplay object fail", id)
    end
    if dst then
        obj.x = dst.x + src.x - _W / 2
        obj.y = dst.y + src.y - _H / 2
    else
        obj.x = src.x
        obj.y = src.y
    end
    src.alpha = 0
    obj.alpha = 0
    obj.selectedPurchase = id
    group:insert(obj)
    obj.fsm = VIEW.fsm
    return obj
end

local function setUpdateMark(dst, group)
    marker.new(dst, group)
end

return M