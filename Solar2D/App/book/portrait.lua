local sceneName = ...
--
local model = {
  --name = "portrait",
	components = {
		layers = {
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
					{
						SubA = {
							{
								Triangle = {
									class = {
										"linear",
									}
								}
							},
							class = {  }
						}
					},
					{
						Ellipse = {
							class = {
								"button",
							}
						}
					},
					class = {  }
				}
			},
			{
				star = {
					class = {  }
				}
			},
			{
				hello = {
					class = {
						"sprite",
					}
				}
			},
		},
		audios = {
			long = {  },
			short = {
				"Thunder",
			}
		},
		groups = {
			{
				group0 = {
					class = {
						"linear",
						"button",
					}
				}
			},
		},
		timers = {
			"timer1",
		},
		variables = {  },
		joints = {  },
		page = {  }
	},
	commands = {
		"audioAction",
		"playAnim",
		"testAction",
	},
	onInit = function(scene)
	end
}

local scene = require('controller.scene').new(sceneName, model)
--
return scene