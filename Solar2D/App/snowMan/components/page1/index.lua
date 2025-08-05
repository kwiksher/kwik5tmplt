local sceneName = ...
--
local model = {
  --name = "page1",
	components = {
		layers = {
			{
				Layer_1 = {
					class = {  }
				}
			},
			{
				tree = {
					class = {  }
				}
			},
			{
				tree2 = {
					class = {  }
				}
			},
			{
				tree1 = {
					class = {  }
				}
			},
			{
				tree3 = {
					class = {  }
				}
			},
			{
				tree4 = {
					class = {  }
				}
			},
			{
				mytext = {
					class = {  }
				}
			},
			{
				ground = {
					class = {  }
				}
			},
			{
				snowFlake = {
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