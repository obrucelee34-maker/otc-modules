-- chunkname: @/modules/game_profession/recipes/woodcutting.lua

recipes = recipes or {}
recipes[ProfessionWoodcutting] = {
	{
		skillRequired = 1,
		name = "Juniper Tree",
		experience = 1590,
		id = 34228,
		growingTime = 7200,
		items = {
			{
				name = "Small Log",
				id = 28977,
				count = {
					2,
					9
				}
			},
			{
				name = "Dense Log",
				id = 34371,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		skillRequired = 5,
		name = "Fir Tree",
		experience = 6250,
		id = 34237,
		growingTime = 28800,
		items = {
			{
				name = "Small Log",
				id = 28977,
				count = {
					10,
					34
				}
			},
			{
				name = "Dense Log",
				id = 34371,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		skillRequired = 10,
		name = "Palm Tree",
		experience = 4720,
		id = 34234,
		growingTime = 21600,
		items = {
			{
				name = "Heavy Log",
				id = 45504,
				count = {
					4,
					8
				}
			},
			{
				name = "Dense Log",
				id = 34371,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		skillRequired = 20,
		name = "Oak Tree",
		experience = 17850,
		id = 34231,
		growingTime = 86400,
		items = {
			{
				name = "Heavy Log",
				id = 45504,
				count = {
					16,
					32
				}
			},
			{
				name = "Dense Log",
				id = 34371,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		skillRequired = 35,
		name = "Wildleaf Tree",
		experience = 12200,
		id = 34225,
		growingTime = 57600,
		items = {
			{
				name = "Sturdy Log",
				id = 45505,
				count = {
					8,
					16
				}
			},
			{
				name = "Dense Log",
				id = 34371,
				count = {
					0,
					1
				}
			}
		}
	},
	{
		skillRequired = 50,
		name = "Willow Tree",
		experience = 9250,
		id = 34244,
		growingTime = 43200,
		items = {
			{
				name = "Fine Log",
				id = 45502,
				count = {
					5,
					10
				}
			},
			{
				name = "Dense Log",
				id = 34371,
				count = {
					0,
					1
				}
			}
		}
	}
}
