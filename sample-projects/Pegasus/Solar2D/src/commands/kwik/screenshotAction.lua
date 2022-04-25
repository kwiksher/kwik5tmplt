-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K = require("Application")
--
function _M:takeScreenShot(layer, ptit, pmsg, shutter, buttonArr)
    _K.screenshot:takeScreenShot(layer, ptit, pmsg, shutter, buttonArr)
end
--

_K.asmModel = {
  sandboxPath = system.pathForFile( nil, _K.DocumentsDir ),
  projPath    = _K.kwikDir,
  APNG        = {},
  AGIF        = {}
}
--
function _M:saveToFile(delay, _target, _filename, numFrames)
  if system.getInfo("environment") == "simulator" then
    local index     = 1
    local fileName  = _filename
    local target    = _target
    local fps       = 1000/200
    local delayGM   = delay/10
    local loop      = 0
    --
    function APNGGen()
      display.save(target, {filename = fileName.."_"..index..".png"})
      index = index + 1
      if index == numFrames then
            table.insert(_K.asmModel.APNG, {
                fileName    = fileName,
                fps         = fps,
                delay       = delayGM,
                loop        = loop
            })
            --
            table.insert(_K.asmModel.AGIF, {
                fileName    = fileName,
                fps         = fps,
                delay       = delayGM,
                loop        = loop
            })
            --
            local ext = "command"
            if system.getInfo("platform") == "win32" then
                ext = "bat"
            end
            local path = system.pathForFile( "assemble."..ext, system.ResourceDirectory )
            local file, errorString = io.open( path, "r" )
            if not file then
                print( "File error: " .. errorString )
            else
                local contents = file:read( "*a" )
                io.close( file )
                local lustache = require "extlib.lustache"
                output = lustache:render(contents, _K.asmModel)

                local path = _K.kwikDir.."/../assemble."..ext
                local file, errorString = io.open( path, "w" )
                if not file then
                    print( "File error: " .. errorString )
                else
                    output = string.gsub(output, "\r\n", "\n")
                    file:write( output )
                    io.close( file )
                end
            end
        end
    end
    _K.timerStash.scrnRecord = timer.performWithDelay( delay, APNGGen , numFrames )
  end
end
--
return _M
