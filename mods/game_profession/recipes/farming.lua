-- chunkname: @/modules/game_profession/recipes/farming.lua

recipes = recipes or {}
recipes[ProfessionFarming] = {
	{
		name = "Potatoes",
		experience = 200,
		growingTime = 3600,
		skillRequired = 1,
		id = 25131,
		items = {
			{
				name = "Potato",
				id = 28874,
				count = {
					2,
					4
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Cotton Tree",
		experience = 3445,
		growingTime = 16200,
		skillRequired = 1,
		id = 34249,
		items = {
			{
				name = "Cotton",
				id = 28879,
				count = {
					4,
					8
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Corn",
		experience = 2585,
		growingTime = 54000,
		skillRequired = 3,
		id = 25130,
		items = {
			{
				name = "Corn",
				id = 28866,
				count = {
					6,
					9
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Wheat",
		experience = 1130,
		growingTime = 21600,
		skillRequired = 5,
		id = 30284,
		items = {
			{
				name = "Wheat",
				id = 28881,
				count = {
					3,
					9
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Apple Tree",
		experience = 5565,
		growingTime = 27000,
		skillRequired = 7,
		id = 34246,
		items = {
			{
				name = "Apple",
				id = 28822,
				count = {
					3,
					6
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Carrots",
		experience = 395,
		growingTime = 7200,
		skillRequired = 10,
		id = 25133,
		items = {
			{
				name = "Carrot",
				id = 28865,
				count = {
					2,
					4
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Grapes",
		experience = 1130,
		growingTime = 21600,
		skillRequired = 15,
		id = 30255,
		items = {
			{
				name = "Grape",
				id = 28831,
				count = {
					2,
					4
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Blueberries",
		experience = 1130,
		growingTime = 21600,
		skillRequired = 17,
		id = 30246,
		items = {
			{
				name = "Blueberry",
				id = 28825,
				count = {
					9,
					15
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Cabbages",
		experience = 1130,
		growingTime = 21600,
		skillRequired = 20,
		id = 30225,
		items = {
			{
				name = "Cabbage",
				id = 28864,
				count = {
					2,
					4
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Peppers",
		experience = 4285,
		growingTime = 102600,
		skillRequired = 21,
		id = 25129,
		items = {
			{
				name = "Pepper",
				id = 28872,
				count = {
					9,
					15
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Cherries",
		experience = 13620,
		growingTime = 75600,
		skillRequired = 21,
		id = 34248,
		items = {
			{
				name = "Cherry",
				id = 28830,
				count = {
					6,
					12
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Orange Tree",
		experience = 10330,
		growingTime = 54000,
		skillRequired = 22,
		id = 34250,
		items = {
			{
				name = "Orange",
				id = 28832,
				count = {
					3,
					6
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Onions",
		experience = 1645,
		growingTime = 32400,
		skillRequired = 25,
		id = 25128,
		items = {
			{
				name = "Onion",
				id = 28870,
				count = {
					3,
					6
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Strawberries",
		experience = 1395,
		growingTime = 27000,
		skillRequired = 27,
		id = 30261,
		items = {
			{
				name = "Strawberry",
				id = 28827,
				count = {
					6,
					12
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Beans",
		experience = 2585,
		growingTime = 54000,
		skillRequired = 30,
		id = 30219,
		items = {
			{
				name = "Bean",
				id = 28878,
				count = {
					9,
					15
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Banana Tree",
		experience = 15105,
		growingTime = 86400,
		skillRequired = 32,
		id = 34247,
		items = {
			{
				name = "Banana",
				id = 28823,
				count = {
					6,
					12
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Pumpkin",
		experience = 3775,
		growingTime = 86400,
		skillRequired = 35,
		id = 30234,
		items = {
			{
				name = "Pumpkin",
				id = 28875,
				count = {
					2,
					4
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Watermelon",
		experience = 4445,
		growingTime = 108000,
		skillRequired = 37,
		id = 30267,
		items = {
			{
				name = "Watermelon",
				id = 28828,
				count = {
					2,
					4
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Peas",
		experience = 3210,
		growingTime = 70200,
		skillRequired = 40,
		id = 30231,
		items = {
			{
				name = "Pea",
				id = 28871,
				count = {
					9,
					15
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Moonberry",
		experience = 3405,
		growingTime = 75600,
		skillRequired = 42,
		id = 30281,
		items = {
			{
				name = "Moonberry",
				id = 28826,
				count = {
					3,
					9
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Garlic",
		experience = 2800,
		growingTime = 59400,
		skillRequired = 45,
		id = 30228,
		items = {
			{
				name = "Garlic",
				id = 28869,
				count = {
					6,
					12
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Acorn Tree",
		experience = 23760,
		growingTime = 172800,
		skillRequired = 47,
		id = 34245,
		items = {
			{
				name = "Acorn",
				id = 28829,
				count = {
					6,
					12
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Brocolli",
		experience = 2585,
		growingTime = 54000,
		skillRequired = 50,
		id = 30222,
		items = {
			{
				name = "Brocolli",
				id = 28863,
				count = {
					3,
					6
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Sunberries",
		experience = 4445,
		growingTime = 108000,
		skillRequired = 52,
		id = 30264,
		items = {
			{
				name = "Sunberry",
				id = 28824,
				count = {
					3,
					9
				}
			},
			{
				name = "Three-Leaf Clover",
				id = 34370,
				count = {
					0,
					1
				}
			}
		}
	}
}
