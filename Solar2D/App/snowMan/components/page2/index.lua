local sceneName = ...
--
local model = {
  --name = "page2",
	components = {
		layers = {
			{
				Layer_1 = {
					class = {  }
				}
			},
			{
				ground = {
					class = {  }
				}
			},
			{
				snowman = {
					class = {  }
				}
			},
			{
				hat = {
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