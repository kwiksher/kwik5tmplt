local sceneName = ...
--
local model = {
  --name = "scroll",
	components = {
		layers = {
			{
				bg = {
					class = {  }
				}
			},
			{
				rect1 = {
					class = {  }
				}
			},
			{
				rect2 = {
					class = {  }
				}
			},
			{
				rect3 = {
					class = {  }
				}
			},
			{
				article = {
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
}

local scene = require('controller.scene').new(sceneName, model)
--
return scene