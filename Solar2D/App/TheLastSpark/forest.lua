local sceneName = ...
--
local model = {
  --name = "forest",
	components = {
		layers = {
			{
				cabin_exterior = {
					class = {  }
				}
			},
			{
				cabin_interior = {
					class = {  }
				}
			},
			{
				bg_forest = {
					class = {  }
				}
			},
			{
				elara_neutral = {
					class = {  }
				}
			},
			{
				elara_scared = {
					class = {  }
				}
			},
			{
				elara_determined = {
					class = {  }
				}
			},
			{
				elara_happy = {
					class = {  }
				}
			},
			{
				wolf_normal = {
					class = {  }
				}
			},
			{
				wolf_aggressive = {
					class = {  }
				}
			},
			{
				wolf_calm = {
					class = {  }
				}
			},
			{
				wolf_retreating = {
					class = {  }
				}
			},
			{
				lumin_seed = {
					class = {  }
				}
			},
			{
				lumin_seed_glowing = {
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