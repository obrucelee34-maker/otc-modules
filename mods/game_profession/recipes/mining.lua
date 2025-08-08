-- chunkname: @/modules/game_profession/recipes/mining.lua

recipes = recipes or {}
recipes[ProfessionMining] = {
	{
		name = "Copper Ore",
		experience = 425,
		growingTime = 0,
		skillRequired = 1,
		id = 30072,
		items = {
			{
				name = "Copper Ore",
				id = 28944,
				count = {
					1,
					3
				}
			},
			{
				name = "Tin Ore",
				id = 44285,
				count = {
					1,
					3
				}
			}
		}
	},
	{
		name = "Rock Ore",
		experience = 250,
		growingTime = 0,
		skillRequired = 1,
		id = 33847,
		items = {
			{
				name = "Stone",
				id = 28946,
				count = {
					1,
					3
				}
			},
			{
				name = "Salt",
				id = 33551,
				count = {
					1,
					2
				}
			}
		}
	},
	{
		name = "Iron Ore",
		experience = 650,
		growingTime = 0,
		skillRequired = 10,
		id = 30071,
		items = {
			{
				name = "Iron Ore",
				id = 28943,
				count = {
					1,
					3
				}
			},
			{
				name = "Coal",
				id = 28941,
				count = {
					1,
					1
				}
			},
			{
				id = "gem",
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Cobalt Ore",
		experience = 900,
		growingTime = 0,
		skillRequired = 30,
		id = 30069,
		items = {
			{
				name = "Cobalt Ore",
				id = 28942,
				count = {
					1,
					2
				}
			},
			{
				name = "Coal",
				id = 28941,
				count = {
					1,
					2
				}
			},
			{
				id = "gem",
				count = {
					0,
					1
				}
			}
		}
	},
	{
		name = "Titanium Ore",
		experience = 1250,
		growingTime = 0,
		skillRequired = 50,
		id = 30070,
		items = {
			{
				name = "Titanium Ore",
				id = 28947,
				count = {
					1,
					3
				}
			},
			{
				name = "Coal",
				id = 28941,
				count = {
					1,
					3
				}
			},
			{
				id = "gem",
				count = {
					0,
					1
				}
			}
		}
	}
}
