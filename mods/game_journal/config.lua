-- chunkname: @/modules/game_journal/config.lua

PROGRESSION_TYPE_CUMULATIVE = 1
PROGRESSION_TYPE_NON_CUMULATIVE = 2
regionIdToName = {
	[128] = "Harbor Island",
	[32] = "Sajecho Island",
	[256] = "Hadarak Desert",
	[2208] = "Pirate Isles",
	[2048] = "Gilead Island",
	[65536] = "Zephyr Vale",
	[512] = "Glaceforde",
	[426000] = "Deadlands"
}
artifacts = {
	order = {
		"Sajecho Island",
		"Gilead Island",
		"Harbor Island",
		"Pirate Isles",
		"Hadarak Desert",
		"Zephyr Vale",
		"Glaceforde",
		"Deadlands"
	},
	regions = {
		["Sajecho Island"] = {
			artifact_name = "Lost Shipments",
			total_artifacts = 140,
			artifact_icon = "lost_shipments",
			type = PROGRESSION_TYPE_CUMULATIVE,
			acquire = {
				{
					description = "Obtain 30 Lost Shipments by completing the quest \"A Pirate's Life\".",
					limit = 30,
					positions = {
						{
							y = 5009,
							z = 6,
							size = 7,
							x = 4785
						}
					}
				},
				{
					description = "Slaying creatures in Sajecho Island will occasionally result in finding Lost Shipments.",
					limit = 95
				},
				{
					description = "Obtain Lost Shipments by participating in dynamic and environmental events from Sajecho.",
					limit = 5
				},
				{
					description = "Obtain 10 Lost Shipments by helping Fisher in Orca Bay.",
					limit = 10
				}
			},
			rewards = {
				{
					requirement = 10,
					description = "Unlocks access to the docks south and west of Sajecho Island.",
					positions = {
						{
							y = 5337,
							z = 7,
							size = 17,
							x = 4672
						},
						{
							y = 5337,
							z = 6,
							size = 17,
							x = 4672
						},
						{
							y = 5274,
							z = 7,
							size = 17,
							x = 4439
						},
						{
							y = 5274,
							z = 6,
							size = 17,
							x = 4439
						}
					}
				},
				{
					requirement = 40,
					description = "Unlocks a special quest from Federic in Eelsnout, western Sajecho.",
					positions = {
						{
							y = 5239,
							z = 7,
							size = 7,
							x = 4430
						}
					}
				},
				{
					requirement = 80,
					description = "Enhance your reputation engaging in conversations with the citizens of Orca Bay; unlocks a creature product enthusiast who is now open to trade.",
					positions = {
						{
							y = 5294,
							z = 7,
							size = 71,
							x = 4692
						}
					},
					fairy = {
						description = "Linnie Swann managed to catch a Fairy in a Bottle and is offering it for trade.",
						positions = {
							{
								y = 5301,
								z = 10,
								size = 4,
								x = 4686
							}
						}
					}
				},
				{
					requirement = 120,
					description = "Unlocks access to the secret goblin workshop in Sajecho.",
					positions = {
						{
							y = 5167,
							z = 7,
							size = 7,
							x = 4738
						},
						{
							size = 7,
							y = 5107,
							z = 12,
							x = 4794,
							floorInfo = {
								at = 12
							}
						}
					}
				},
				{
					requirement = 140,
					description = "Chase Eagle, the legendary pirate captain, will offer a reward if you manage to find him in Sajecho.",
					positions = {
						{
							y = 5135,
							z = 7,
							size = 31,
							x = 4791
						}
					}
				}
			}
		},
		["Harbor Island"] = {
			type = PROGRESSION_TYPE_NON_CUMULATIVE,
			acquire = {
				{
					description = "Obtain Adamastor's Earring by defeating Captain Adamastor."
				},
				{
					description = "Slaying creatures in Harbor Island could lead to finding the Lost Earring."
				},
				{
					description = "Obtain Galien's earring by defeating Drunk General Galien."
				},
				{
					description = "Obtain the Forsaken Earring as a potential reward by completing the environmental quest \"Possessed by Resentment\"."
				},
				{
					description = "Collect all 4 unique Pirate Earrings in Harbor Island."
				}
			},
			rewards = {
				{
					artifact_name = "Adamastor's Earrings",
					description = "Unlocks access to all crafting stations in Seabreeze. Increases labor in all professions by 10.",
					artifact_icon = "adamastor's_earrings",
					positions = {
						{
							y = 5137,
							z = 6,
							size = 51,
							x = 3956
						}
					}
				},
				{
					artifact_name = "Lost Earrings",
					description = "The private lounge of the Freelooters Syndicate in Seabreeze is now open to you, offering opportunities for trade and cosmetic obtainment.",
					artifact_icon = "lost_earrings",
					positions = {
						{
							y = 5137,
							z = 7,
							size = 7,
							x = 3956
						}
					},
					fairy = {
						description = "Gil Swigmore managed to catch a Fairy in a Bottle and is offering it for trade.",
						positions = {
							{
								y = 5134,
								z = 5,
								size = 4,
								x = 3969
							}
						}
					}
				},
				{
					artifact_name = "Galien's Earrings",
					description = "Krz'k, a strange zorian, will grant you passage into the Maw Caverns, below Galien's Island.",
					artifact_icon = "galien's_earrings",
					positions = {
						{
							y = 4900,
							z = 8,
							size = 17,
							x = 4321
						}
					}
				},
				{
					artifact_name = "Forsaken Earring",
					description = "A Spirit of Redemption will open the path to the secret dungeon below Harbor Island's Lighthouse.",
					artifact_icon = "phantom_earrings",
					positions = {
						{
							y = 4986,
							z = 8,
							size = 17,
							x = 3916
						}
					}
				},
				{
					artifact_name = "All Earrings",
					total_artifacts = 4,
					description = "Chase Eagle, the legendary pirate captain, will offer a reward if you manage to find him in Harbor Island.",
					artifact_icon = "all_earrings",
					positions = {
						{
							y = 4917,
							z = 7,
							size = 101,
							x = 4055
						}
					}
				}
			}
		},
		["Gilead Island"] = {
			artifact_name = "Ancient Runes",
			total_artifacts = 50,
			artifact_icon = "ancient_rune",
			type = PROGRESSION_TYPE_CUMULATIVE,
			acquire = {
				{
					description = "Fishing in the waters of Gilead Island will occasionally result in finding Ancient Runes.",
					limit = 10
				},
				{
					description = "Slaying Kaimans in Gilead Island will occasionally result in finding Ancient Runes.",
					limit = 15
				},
				{
					description = "Slaying Saurians in Gilead Island will occasionally result in finding Ancient Runes.",
					limit = 15
				},
				{
					description = "Obtain Ancient Runes by participating in dynamic and environmental events from Gilead.",
					limit = 10
				}
			},
			rewards = {
				{
					requirement = 10,
					description = "Allows you entry into Gilead's Museum, providing access to new quests and cosmetic obtainment.",
					positions = {
						{
							y = 5869,
							z = 7,
							size = 7,
							x = 4323
						}
					},
					fairy = {
						description = "Marlene managed to catch a Fairy in a Bottle and is offering it for trade.",
						positions = {
							{
								y = 5867,
								z = 8,
								size = 4,
								x = 4319
							}
						}
					}
				},
				{
					requirement = 20,
					description = "Nelson, the curator of Gilead's Museum is open to trade rune enchantments.",
					positions = {
						{
							y = 5868,
							z = 6,
							size = 7,
							x = 4311
						}
					}
				},
				{
					requirement = 30,
					description = "Nelson has expanded the catalog of runes he's willing to trade.",
					positions = {
						{
							y = 5868,
							z = 6,
							size = 7,
							x = 4311
						}
					}
				},
				{
					requirement = 40,
					description = "Unlocks a special quest from a ghostly presence in Rumalos, western Gilead.",
					positions = {
						{
							y = 5583,
							z = 7,
							size = 7,
							x = 3987
						}
					}
				},
				{
					requirement = 50,
					description = "Chase Eagle, the legendary pirate captain, will offer a reward if you manage to find him in Gilead Island.",
					positions = {
						{
							y = 5761,
							z = 7,
							size = 71,
							x = 4089
						}
					}
				}
			}
		},
		["Pirate Isles"] = {
			type = PROGRESSION_TYPE_NON_CUMULATIVE,
			acquire = {
				{
					description = "Find Chase Eagle after obtaining all the Artifacts from Sajecho Island."
				},
				{
					description = "Find Chase Eagle after obtaining all the Artifacts from Gilead Island."
				},
				{
					description = "Find Chase Eagle after obtaining all the Artifacts from Harbor Island."
				}
			},
			rewards = {
				{
					artifact_name = "Patchwork Jolly Roger",
					description = "Unlocks access to hidden pirate docks on remote beach islands scattered at sea.",
					artifact_icon = "sajecho_jolly_roger",
					positions = {
						{
							y = 5274,
							z = 7,
							size = 17,
							x = 3975
						}
					}
				},
				{
					artifact_name = "Gilead Jolly Roger",
					description = "Unlocks access to hidden pirate docks on remote jungle islands scattered at sea.",
					artifact_icon = "gilead_jolly_roger",
					positions = {
						{
							y = 5533,
							z = 7,
							size = 17,
							x = 4569
						}
					}
				},
				{
					artifact_name = "Charred Jolly Roger",
					description = "Unlocks access to hidden pirate docks on remote rocky islands scattered at sea.",
					artifact_icon = "harbor_jolly_roger",
					positions = {
						{
							y = 4961,
							z = 7,
							size = 17,
							x = 4502
						}
					}
				}
			}
		},
		["Hadarak Desert"] = {
			artifact_name = "Ankh",
			total_artifacts = 10,
			artifact_icon = "ankh",
			type = PROGRESSION_TYPE_CUMULATIVE,
			acquire = {
				{
					description = "Complete part of the story quest \"Trial of the Dunes\" to obtain an Ankh.",
					limit = 1,
					positions = {
						{
							y = 5494,
							z = 6,
							size = 7,
							x = 5327
						}
					}
				},
				{
					description = "Complete the story quest \"Haran's Contract\" to obtain an Ankh.",
					limit = 1,
					positions = {
						{
							y = 5682,
							z = 7,
							size = 7,
							x = 5531
						}
					}
				},
				{
					description = "Slaying the Ghaz in Hadarak Desert might result in discovering an Ankh.",
					limit = 1
				},
				{
					description = "Search the treasures at the Temple of Alq'walen to obtain an Ankh.",
					limit = 1
				},
				{
					description = "Exchange Orcish Effigies with Adad, south of Hadarak Ruins, to obtain an Ankh.",
					limit = 1,
					positions = {
						{
							y = 5663,
							z = 7,
							size = 7,
							x = 5785
						}
					}
				},
				{
					description = "Complete the dynamic quest \"A Sludging Mess\" to obtain an Ankh as a potential reward.",
					limit = 1
				},
				{
					description = "Exchange Cave Roses with Eshmun, at Draz Narda, to obtain an Ankh.",
					limit = 1,
					positions = {
						{
							y = 5508,
							z = 5,
							size = 7,
							x = 5371
						}
					}
				},
				{
					description = "Exchange Minotaur Horns with Amilcar, at Kabbar Palace, to obtain an Ankh.",
					limit = 1,
					positions = {
						{
							y = 5300,
							z = 5,
							size = 7,
							x = 4943
						}
					}
				},
				{
					description = "Slaying either Jackals or Djinns in the Riftsand might result in discovering an Ankh.",
					limit = 1
				},
				{
					description = "Exchange Aether Dust with Dido, at Sandscar Sanctuary, or Beastly Distillate with Belshazzar, in the Temple of Quorras, to obtain an Ankh.",
					limit = 1
				}
			},
			rewards = {
				{
					requirement = 1,
					description = "Unlocks the ancient door at the Temple of Alq'walen, as pointed out by Varsha near Dras Narda.",
					positions = {
						{
							y = 5541,
							z = 9,
							size = 17,
							x = 5362
						}
					}
				},
				{
					requirement = 2,
					description = "Unlocks the ancient door at Kabbar Palace.",
					positions = {
						{
							y = 5299,
							z = 7,
							size = 7,
							x = 4948
						}
					}
				},
				{
					requirement = 3,
					description = "Unlocks the ancient door in the city of Dras Narda, where a mystical being deals in rune enchantments.",
					positions = {
						{
							y = 5518,
							z = 7,
							size = 7,
							x = 5361
						}
					}
				},
				{
					requirement = 4,
					description = "Unlocks the ancient door at Broken Horn Bluff, the underground minotaur city in eastern Hadarak.",
					positions = {
						{
							y = 5416,
							z = 7,
							size = 17,
							x = 5686
						},
						{
							y = 5489,
							z = 8,
							size = 7,
							x = 5685
						}
					}
				},
				{
					requirement = 5,
					description = "Unlocks the ancient door at Hadarak Ruins, allowing access to a rune merchant and cosmetic obtainment.",
					positions = {
						{
							y = 5562,
							z = 7,
							size = 7,
							x = 5841
						}
					},
					fairy = {
						description = "Zarath Al'Gourmand managed to catch a Fairy in a Bottle and is offering it for trade.",
						positions = {
							{
								y = 5552,
								z = 8,
								size = 4,
								x = 5837
							}
						}
					}
				},
				{
					requirement = 6,
					description = "Unlocks the ancient door to the lower levels beneath the Temple of Alq'walen.",
					positions = {
						{
							y = 5565,
							z = 11,
							size = 7,
							x = 5339
						}
					}
				},
				{
					requirement = 7,
					description = "Unlocks the ancient door connecting Hadarak to Riftsand.",
					positions = {
						{
							y = 5530,
							z = 8,
							size = 7,
							x = 5851
						}
					}
				},
				{
					requirement = 8,
					description = "Unlocks either an ancient door located in the Temple of Quorras or one in Sandscar Sanctuary.",
					positions = {
						{
							size = 7,
							y = 5555,
							z = 8,
							x = 5965,
							callback = function()
								local questLog = modules.game_questlog.GameQuestLog

								return questLog:isQuestActive("Sands of Conquest") or questLog:isQuestCompleted("Sands of Conquest")
							end
						},
						{
							size = 7,
							y = 5342,
							z = 7,
							x = 6025,
							callback = function()
								local questLog = modules.game_questlog.GameQuestLog

								return questLog:isQuestActive("Veil of Scars") or questLog:isQuestCompleted("Veil of Scars")
							end
						}
					}
				},
				{
					requirement = 9,
					description = "Unlocks the ancient door deep in Riftsand caverns.",
					positions = {
						{
							y = 5505,
							z = 9,
							size = 7,
							x = 6010
						}
					}
				},
				{
					requirement = 10,
					description = "Unlocks the last ancient door deep in Riftsand caverns.",
					positions = {
						{
							y = 5420,
							z = 9,
							size = 7,
							x = 5912
						}
					}
				}
			}
		},
		["Zephyr Vale"] = {
			artifact_name = "Ethereal Veil",
			total_artifacts = 6,
			artifact_icon = "ethereal_veil",
			type = PROGRESSION_TYPE_CUMULATIVE,
			acquire = {
				{
					description = "Complete the story quest \"A Recipe for Dissolution\" to obtain an Ethereal Veil.",
					limit = 1,
					positions = {
						{
							y = 5238,
							z = 3,
							size = 7,
							x = 5844
						}
					}
				},
				{
					description = "Complete either of the dynamic quests \"An Escort to Truce\", \"An Escort to Bastion\" or \"An Escort to Defiance\" to obtain an Ethereal Veil.",
					limit = 1
				},
				{
					description = "Complete part of the story quest \"Into the Rising Sun\" to obtain an Ethereal Veil.",
					limit = 1,
					positions = {
						{
							y = 4976,
							z = 6,
							size = 7,
							x = 5955
						}
					}
				},
				{
					description = "Slay Hookmasks in Zephyr Vale to obtain an Ethereal Veil, with a low drop rate.",
					limit = 1
				},
				{
					description = "Slay Morningstars in Zephyr Vale to obtain an Ethereal Veil, with a low drop rate.",
					limit = 1
				},
				{
					description = "Complete the dynamic quest \"When the Eastern Wind Blows\" to obtain an Ethereal Veil as a potential reward.",
					limit = 1
				}
			},
			rewards = {
				{
					requirement = 1,
					description = "Unlocks the gateway into an exclusive alchemy laboratory in Bastion, granting access to a potion shop and cosmetic obtainment.",
					positions = {
						{
							y = 5225,
							z = 3,
							size = 7,
							x = 5630
						}
					},
					fairy = {
						description = "Ordon Moore managed to catch a Fairy in a Bottle and is offering it for trade.",
						positions = {
							{
								y = 5230,
								z = 5,
								size = 4,
								x = 5642
							}
						}
					}
				},
				{
					requirement = 2,
					description = "Unlocks access to a closed workshop in Firslight, the Morningstar's stronghold. Increases labor in all professions by 20.",
					positions = {
						{
							y = 4937,
							z = 7,
							size = 51,
							x = 6025
						}
					}
				},
				{
					requirement = 3,
					description = "Use the shrine of the area, as allowed by Andrea, a Morningstar Bishop residing in Firstlight.",
					positions = {
						{
							y = 4999,
							z = 4,
							size = 7,
							x = 6032
						}
					}
				},
				{
					requirement = 4,
					description = "Unlock access to the Morningstar Tower, guarded by Eamon.",
					positions = {
						{
							y = 4902,
							z = 4,
							size = 7,
							x = 6036
						}
					}
				},
				{
					requirement = 5,
					description = "Creatures from the Morningstar Family will not attack you unless you attack them first or gather resources near them."
				},
				{
					requirement = 6,
					description = "Receive the blessing of \"Zephyr Winds\" temporarily from Andrea, who now sees you as trustworthy, for a price.",
					positions = {
						{
							y = 4999,
							z = 4,
							size = 7,
							x = 6032
						}
					}
				}
			}
		},
		Glaceforde = {
			artifact_name = "Frozen Sigil",
			total_artifacts = 5,
			artifact_icon = "frozen_sigil",
			type = PROGRESSION_TYPE_CUMULATIVE,
			acquire = {
				{
					description = "Slaying magically proficient creatures in Glaceforde will occasionally result in finding a Frozen Sigil.",
					limit = 1
				},
				{
					description = "Exchange Igneous Ice Shards with Kalas, in Saint Alsek, the furthest city to the west in Glaceforde, to obtain a Frozen Sigil.",
					limit = 1
				},
				{
					description = "Complete the story quest \"Yeti More to Kill\" to obtain a Frozen Sigil.",
					limit = 1,
					positions = {
						{
							y = 4271,
							z = 6,
							size = 7,
							x = 4296
						}
					}
				},
				{
					description = "Exchange Oceanic Tears with Ivar in Far Naddod, the furthest village to the north in Glaceforde, to obtain a Frozen Sigil.",
					limit = 1
				},
				{
					description = "Complete the environmental quest \"The Wizard Frozen in Time\" to obtain a Frozen Sigil as a potential reward.",
					limit = 1,
					positions = {
						{
							y = 4320,
							z = 7,
							size = 7,
							x = 4829
						}
					}
				}
			},
			rewards = {
				{
					requirement = 1,
					description = "Ailsa, a priestess of Saint Alsek, now allows the use of Saint Alsek's Shrine.",
					positions = {
						{
							y = 4184,
							z = 6,
							size = 7,
							x = 4132
						}
					}
				},
				{
					requirement = 2,
					description = "Earns you the trust and respect of Steigard, spiritual guide of the Winterborn.",
					positions = {
						{
							y = 4493,
							z = 6,
							size = 7,
							x = 4413
						}
					}
				},
				{
					requirement = 3,
					description = "Unlocks access to the secret magical seal below Saint Alsek.",
					positions = {
						{
							y = 4178,
							z = 7,
							size = 17,
							x = 4132
						}
					},
					fairy = {
						description = "Lorekeeper Hawthorn managed to catch a Fairy in a Bottle and is offering it for trade.",
						positions = {
							{
								y = 4187,
								z = 10,
								size = 4,
								x = 4101
							}
						}
					}
				},
				{
					requirement = 4,
					description = "Ailsa will temporarily bestow \"Alsek's Blessing\", for a price.",
					positions = {
						{
							y = 4184,
							z = 6,
							size = 7,
							x = 4132
						}
					}
				},
				{
					requirement = 5,
					description = "Unlocks access to the dock at Newvik.",
					positions = {
						{
							y = 4258,
							z = 7,
							size = 7,
							x = 4310
						}
					}
				}
			}
		},
		Deadlands = {
			artifact_name = "Crystal Eye",
			total_artifacts = 13,
			artifact_icon = "crystal_eye",
			type = PROGRESSION_TYPE_CUMULATIVE,
			acquire = {
				{
					description = "Search the mountain range around the Greypike Castle to obtain a Crystal Eye.",
					limit = 1
				},
				{
					description = "Exchange Vampire Fangs with Rebecca Dancer to obtain a Crystal Eye.",
					limit = 1,
					positions = {
						{
							y = 4863,
							z = 5,
							size = 7,
							x = 5496
						}
					}
				},
				{
					description = "Complete the story quest \"Lords of Blood: Part III\" to obtain a Crystal Eye.",
					limit = 1
				},
				{
					description = "Search the Skorn's Castle to obtain a Crystal Eye.",
					limit = 1
				},
				{
					description = "Complete the story quest \"Maymun's Contract\" to obtain a Crystal Eye.",
					limit = 1
				},
				{
					description = "Slaying Demons in the Fields of Despair will occasionally result in discovering a Crystal Eye.",
					limit = 1
				},
				{
					description = "Search the Master's Overlook to obtain a Crystal Eye.",
					limit = 1
				},
				{
					description = "Exchange Demon Cores with Dakard to obtain a Crystal Eye.",
					limit = 1,
					positions = {
						{
							y = 4577,
							z = 7,
							size = 7,
							x = 5642
						}
					}
				},
				{
					description = "Exchange Exotic Fungus with Anisa to obtain a Crystal Eye.",
					limit = 1,
					positions = {
						{
							y = 4965,
							z = 7,
							size = 7,
							x = 5704
						}
					}
				},
				{
					description = "Complete the environmental quest \"The Corvine Bride\" to obtain a Crystal Eye.",
					limit = 1,
					positions = {
						{
							y = 4810,
							z = 10,
							size = 15,
							x = 5795
						}
					}
				},
				{
					description = "Exchange Crow Masks with Serion Blackthorn to obtain a Crystal Eye.",
					limit = 1,
					positions = {
						{
							y = 4907,
							z = 8,
							size = 7,
							x = 5720
						}
					}
				},
				{
					description = "Exchange Eldritch Vestiges (5) with Liana Doveheart to obtain a Crystal Eye.",
					limit = 1,
					positions = {
						{
							y = 4901,
							z = 8,
							size = 7,
							x = 5716
						}
					}
				},
				{
					description = "Complete the environmental quest \"The Caw of Yl'zogog\" to obtain a Crystal Eye.",
					limit = 1,
					positions = {
						{
							y = 4789,
							z = 13,
							size = 15,
							x = 5953
						}
					}
				}
			},
			rewards = {
				{
					requirement = 1,
					description = "Secret passages behind bookcases in the Greypike Castle are now accessible.",
					positions = {
						{
							y = 4755,
							z = 6,
							size = 7,
							x = 5435
						},
						{
							y = 4755,
							z = 6,
							size = 7,
							x = 5396
						}
					}
				},
				{
					requirement = 2,
					description = "Creatures of the Vampire family will not attack you unless you attack them first or gather resources near them."
				},
				{
					requirement = 3,
					description = "The lobby of Eternal Night Society in Sombreshade is now open to you, offering opportunity for trades and cosmetic obtainment.",
					positions = {
						{
							y = 4841,
							z = 7,
							size = 9,
							x = 5381
						}
					}
				},
				{
					requirement = 5,
					description = "The Slayers Secret Base in Crowhollow Bog is now open to you, offering opportunity for trades and cosmetic obtainment.",
					positions = {
						{
							y = 4910,
							z = 7,
							size = 7,
							x = 5711
						}
					}
				},
				{
					requirement = 6,
					description = "The Abandoned Docks at the Fields of Despair leading to The Blotch are now open to you.",
					positions = {
						{
							y = 4636,
							z = 7,
							size = 7,
							x = 5883
						},
						{
							y = 4678,
							z = 7,
							size = 7,
							x = 5992
						}
					}
				},
				{
					requirement = 8,
					description = "The Rat Nest under Blightwhiskers Warrens is now open to you.",
					positions = {
						{
							y = 4749,
							z = 9,
							size = 7,
							x = 5825
						}
					}
				},
				{
					requirement = 10,
					description = "The Abandoned Hut at Wraithveil Hollows is now open to you.",
					positions = {
						{
							y = 4886,
							z = 7,
							size = 7,
							x = 5583
						}
					}
				},
				{
					requirement = 13,
					description = "A Secret Portal at the Castle of Skorn can now be accessed by you.",
					positions = {
						{
							y = 4367,
							z = 12,
							size = 11,
							x = 6150
						}
					}
				}
			}
		}
	}
}
