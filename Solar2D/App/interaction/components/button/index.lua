local sceneName = ...
--
local model = {
  --name = "button",
	components = {
		layers = {
			{
				kwkcover = {
					class = {  }
				}
			},
			{
				kwkwitch = {
					class = {  }
				}
			},
			{
				kwkmask = {
					class = {  }
				}
			},
			{
				readMe = {
					{
						en = {
							class = {  }
						}
					},
					{
						ja = {
							class = {  }
						}
					},
					{
						pt = {
							class = {  }
						}
					},
					{
						sp = {
							class = {  }
						}
					},
					class = {  }
				}
			},
			{
				Candice = {
					class = {  }
				}
			},
			{
				langTxt = {
					class = {  }
				}
			},
			{
				over = {
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