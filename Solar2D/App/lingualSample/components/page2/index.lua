local sceneName = ...
--
local model = {
  --name = "page2",
	components = {
		layers = {
			{
				kwkcover = {
					class = {  }
				}
			},
			{
				witch = {
					{
						pt = {
							class = {  }
						}
					},
					{
						ja = {
							class = {  }
						}
					},
					{
						sp = {
							class = {  }
						}
					},
					{
						en = {
							class = {
								"linear",
							}
						}
					},
					class = {
						"lang",
					}
				}
			},
			{
				fly = {
					{
						en = {
							class = {
								"button",
							}
						}
					},
					{
						sp = {
							class = {  }
						}
					},
					{
						pt = {
							class = {  }
						}
					},
					{
						ja = {
							class = {  }
						}
					},
					class = {
						"lang",
					}
				}
			},
			{
				flyOver = {
					{
						en = {
							class = {  }
						}
					},
					{
						sp = {
							class = {  }
						}
					},
					{
						pt = {
							class = {  }
						}
					},
					{
						ja = {
							class = {  }
						}
					},
					class = {
						"lang",
					}
				}
			},
			{
				father = {
					{
						en = {
							class = {
								"sync",
							}
						}
					},
					{
						sp = {
							class = {  }
						}
					},
					{
						pt = {
							class = {  }
						}
					},
					{
						ja = {
							class = {  }
						}
					},
					class = {
						"lang",
					}
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
	commands = {
		"flyAnim",
	},
	onInit = function(scene)
		print("onInit")
	end
}

local scene = require('controller.scene').new(sceneName, model)
--
return scene