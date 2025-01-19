local sceneName = ...
--
local model = {
  --name = "infinity",
	components = {
		layers = {
			{
				background4 = {
					class = {  }
				}
			},
			{
				cloud2 = {
					class = {  }
				}
			},
			{
				cloud1 = {
					class = {  }
				}
			},
			{
				background3 = {
					class = {  }
				}
			},
			{
				background2 = {
					class = {  }
				}
			},
			{
				background1 = {
					class = {  }
				}
			},
			{
				boo = {
					class = {  }
				}
			},
			{
				car = {
					class = {  }
				}
			},
			{
				wheel2 = {
					class = {  }
				}
			},
			{
				wheel1 = {
					class = {  }
				}
			},
			{
				text = {
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