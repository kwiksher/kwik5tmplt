local sceneName = ...
--
local model = {
  --name = "cabin",
	components = {
		layers = {
			{
				bg_cabin_exterior = {
					class = {  }
				}
			},
			{
				bg_cabin_interior = {
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
				elara_shocked = {
					class = {  }
				}
			},
			{
				elara_panicking = {
					class = {  }
				}
			},
			{
				lumin_seed_normal = {
					class = {  }
				}
			},
			{
				lumin_seed_glowing = {
					class = {  }
				}
			},
			{
				lumin_seed_dim = {
					class = {  }
				}
			},
			{
				lumin_seed_pulsing = {
					class = {  }
				}
			},
			{
				lumin_seed_collected = {
					class = {  }
				}
			},
			{
				door_closed = {
					class = {  }
				}
			},
			{
				door_open = {
					class = {  }
				}
			},
			{
				door_broken = {
					class = {  }
				}
			},
			{
				door_sealed = {
					class = {  }
				}
			},
			{
				chest_locked = {
					class = {  }
				}
			},
			{
				chest_unlocked = {
					class = {  }
				}
			},
			{
				chest_open = {
					class = {  }
				}
			},
			{
				chest_empty = {
					class = {  }
				}
			},
			{
				iron_key_hidden = {
					class = {  }
				}
			},
			{
				iron_key = {
					class = {  }
				}
			},
			{
				iron_key_collected = {
					class = {  }
				}
			},
			{
				brass_key_hidden = {
					class = {  }
				}
			},
			{
				brass_key = {
					class = {  }
				}
			},
			{
				brass_key_collected = {
					class = {  }
				}
			},
			{
				floorboard_normal = {
					class = {  }
				}
			},
			{
				floorboard_highlighted = {
					class = {  }
				}
			},
			{
				floorboard_open = {
					class = {  }
				}
			},
			{
				window_boarded = {
					class = {  }
				}
			},
			{
				markings_arcane = {
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