local sceneName = ...
--
local scene = require('controller.scene').new(sceneName, {
    --name = "path",
	components = {
		layers = {
			{
				SnowFlake = {
					class = {  }
				}
			},
			{
				star = {
					class = {  }
				}
			},
		},
		audios = {
			long = {  },
			short = {   }
		},
		groups = {
      },
		timers = {  },
		variables = {  },
		joints = {  },
		page = {  }
	},
	commands = {  },
	onInit = function(scene)
		print("onInit")
	end
})
--
return scene