-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local particleDesigner = {}

local json = require( "json" )
local _K = require "Application"

function particleDesigner.newEmitter( fileName, baseDir )
	print(fileName)
   local filePath = system.pathForFile( fileName, baseDir )
   local f = io.open( filePath, "r" )
   local fileData = f:read( "*a" )
   f:close()

   local emitterParams = json.decode( fileData )
   emitterParams.textureFileName = _K.particleDir .. emitterParams.textureFileName
   local emitter = display.newEmitter( emitterParams , baseDir)

   return emitter
end

return particleDesigner