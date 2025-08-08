-- chunkname: @/modules/game_profession/recipes/husbandry.lua

recipes = recipes or {}
recipes[ProfessionHusbandry] = {
	{
		name = "Small Chicken Pen",
		id = 34373,
		skillRequired = 5,
		items = {
			gathering = {
				{
					name = "Egg",
					id = 28928,
					count = {
						4,
						6
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			},
			butchering = {
				{
					name = "Chicken Meat",
					id = 28750,
					count = {
						3,
						5
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			}
		},
		time = {
			gathering = 5400,
			butchering = 10800
		}
	},
	{
		name = "Small Hare Pen",
		id = 34461,
		skillRequired = 1,
		items = {
			gathering = {
				{
					name = "Spool Of Hair",
					id = 34475,
					count = {
						4,
						6
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			},
			butchering = {
				{
					name = "Chicken Meat",
					id = 28750,
					count = {
						3,
						5
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			}
		},
		time = {
			gathering = 5400,
			butchering = 10800
		}
	},
	{
		name = "Small Pig Pen",
		id = 34399,
		skillRequired = 1,
		items = {
			butchering = {
				{
					name = "Shank",
					id = 28932,
					count = {
						3,
						4
					}
				},
				{
					name = "Hide",
					id = 35353,
					count = {
						2,
						4
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			}
		},
		time = {
			butchering = 14400
		}
	},
	{
		name = "Small Goat Pen",
		id = 35083,
		skillRequired = 10,
		items = {
			gathering = {
				{
					name = "Milk",
					id = 28929,
					count = {
						2,
						3
					}
				},
				{
					name = "Wool",
					id = 28425,
					count = {
						1,
						1
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			},
			butchering = {
				{
					name = "Shank",
					id = 28932,
					count = {
						4,
						7
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			}
		},
		time = {
			gathering = 7200,
			butchering = 14400
		}
	},
	{
		name = "Small Turkey Pen",
		id = 35085,
		skillRequired = 15,
		items = {
			butchering = {
				{
					name = "Chicken Meat",
					id = 28750,
					count = {
						3,
						5
					}
				},
				{
					name = "Feather",
					id = 35354,
					count = {
						2,
						5
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			}
		},
		time = {
			butchering = 21600
		}
	},
	{
		name = "Small Sheep Pen",
		id = 34412,
		skillRequired = 20,
		items = {
			gathering = {
				{
					name = "Wool",
					id = 28425,
					count = {
						3,
						5
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			},
			butchering = {
				{
					name = "Shank",
					id = 28932,
					count = {
						8,
						12
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			}
		},
		time = {
			gathering = 10800,
			butchering = 21600
		}
	},
	{
		name = "Cheese Barrel",
		id = 37440,
		skillRequired = 21,
		specialization = "Fermenting Barrels",
		items = {
			gathering = {
				{
					name = "Cheese",
					id = 28927,
					count = {
						1,
						2
					}
				}
			}
		},
		time = {
			gathering = 108000
		}
	},
	{
		name = "Small Cow Pen",
		id = 34386,
		skillRequired = 25,
		items = {
			gathering = {
				{
					name = "Milk",
					id = 28929,
					count = {
						3,
						5
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			},
			butchering = {
				{
					name = "Beef",
					id = 28931,
					count = {
						6,
						11
					}
				},
				{
					name = "Hide",
					id = 35353,
					count = {
						6,
						9
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			}
		},
		time = {
			gathering = 18000,
			butchering = 36000
		}
	},
	{
		name = "Medium Chicken Pen",
		id = 34377,
		skillRequired = 30,
		items = {
			gathering = {
				{
					name = "Egg",
					id = 28928,
					count = {
						9,
						14
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			},
			butchering = {
				{
					name = "Chicken Meat",
					id = 28750,
					count = {
						7,
						12
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			}
		},
		time = {
			gathering = 5400,
			butchering = 10800
		}
	},
	{
		name = "Medium Hare Pen",
		id = 34465,
		skillRequired = 35,
		items = {
			gathering = {
				{
					name = "Spool Of Hair",
					id = 34475,
					count = {
						9,
						14
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			},
			butchering = {
				{
					name = "Chicken Meat",
					id = 28750,
					count = {
						7,
						12
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			}
		},
		time = {
			gathering = 5400,
			butchering = 10800
		}
	},
	{
		name = "Medium Pig Pen",
		id = 34403,
		skillRequired = 40,
		items = {
			butchering = {
				{
					name = "Shank",
					id = 28932,
					count = {
						6,
						9
					}
				},
				{
					name = "Hide",
					id = 35353,
					count = {
						6,
						9
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			}
		},
		time = {
			butchering = 14400
		}
	},
	{
		name = "Medium Goat Pen",
		id = 35082,
		skillRequired = 50,
		items = {
			gathering = {
				{
					name = "Milk",
					id = 28929,
					count = {
						4,
						6
					}
				},
				{
					name = "Wool",
					id = 28425,
					count = {
						2,
						4
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			},
			butchering = {
				{
					name = "Shank",
					id = 28932,
					count = {
						9,
						14
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			}
		},
		time = {
			gathering = 7200,
			butchering = 14400
		}
	},
	{
		name = "Medium Turkey Pen",
		id = 35084,
		skillRequired = 55,
		items = {
			butchering = {
				{
					name = "Chicken Meat",
					id = 28750,
					count = {
						9,
						13
					}
				},
				{
					name = "Feather",
					id = 35354,
					count = {
						5,
						8
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			}
		},
		time = {
			butchering = 21600
		}
	},
	{
		name = "Medium Sheep Pen",
		id = 34416,
		skillRequired = 60,
		items = {
			gathering = {
				{
					name = "Wool",
					id = 28425,
					count = {
						8,
						11
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			},
			butchering = {
				{
					name = "Shank",
					id = 28932,
					count = {
						18,
						27
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			}
		},
		time = {
			gathering = 10800,
			butchering = 21600
		}
	},
	{
		name = "Medium Cow Pen",
		id = 34390,
		skillRequired = 65,
		items = {
			gathering = {
				{
					name = "Milk",
					id = 28929,
					count = {
						8,
						11
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			},
			butchering = {
				{
					name = "Beef",
					id = 28931,
					count = {
						15,
						22
					}
				},
				{
					name = "Hide",
					id = 35353,
					count = {
						14,
						21
					}
				},
				{
					name = "Fertilizer",
					id = 34369,
					count = {
						0,
						1
					}
				}
			}
		},
		time = {
			gathering = 18000,
			butchering = 36000
		}
	},
	{
		name = "Bee Hive",
		id = 44230,
		skillRequired = 21,
		specialization = "Beekeeper",
		items = {
			gathering = {
				{
					name = "Honey",
					id = 44381,
					count = {
						12,
						24
					}
				}
			}
		},
		time = {
			gathering = 158400
		}
	}
}
