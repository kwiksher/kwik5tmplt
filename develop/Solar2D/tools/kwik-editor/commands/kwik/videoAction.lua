-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
local app            = require "Application"

--
function _M:playVideo(obj)
    if obj.player then
        if obj.player.playing == nil then
            obj.player:play({loop=obj.loop, onComplete = function()
                    print("completed")
                    if obj.videoListener then
                        obj.videoListener({phase="ended"})
                    end
                    obj.player:stop()
                end
            })
        elseif obj.player.isPaused then
            obj.player:resume()
        end
    else
	obj:play()
end
end
--
function _M:pauseVideo(obj)
    if obj.player then
        obj.player:pause()
    else
	obj:pause()
end
end
--
function _M:rewindVideo(obj)
    if obj.player then
    else
	obj:seek(0)
    end
end
--
function _M:muteVideo(obj, videos)
    if #videos > 0 then
        for i=1, #videos do
            videos[i].isMuted = true
            app.muteVideos[videos[i].name] = true
        end
    else
        obj.isMuted = true
        app.muteVideos[obj.name] = true
    end
end
--
function _M:unmuteVideo(obj, videos)
    if #videos > 0 then
        for i=1, #videos do
            videos[i].isMuted = false
            app.muteVideos[videos[i].name] = false
        end
    else
        obj.isMuted = false
        app.muteVideos[obj.name] = false
    end
end
--
return _M