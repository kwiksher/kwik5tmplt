local sceneName = ...
--
local model = {
  --name = "animation",
	components = {
		layers = {
			{
				background = {
					class = {  }
				}
			},
			{
				star = {
					class = {  }
				}
			},
			{
				counter = {
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
	end
}

local scene = require('controller.scene').new(sceneName, model)
--
return scene