local sceneName = ...
--
local model = {
  --name = "landscape",
	components = {
		layers = {
			{
				background = {
					class = {  }
				}
			},
			{
				bg = {
					class = {  }
				}
			},
			{
				copyright = {
					class = {  }
				}
			},
			{
				GroupA = {
					class = {  }
				}
			},
			{
				star = {
					class = {
						"properties",
					}
				}
			},
			{
				hello = {
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