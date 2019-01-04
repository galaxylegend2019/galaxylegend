local galaxy = GameData.chapter_galaxy.galaxy

table.insert(galaxy, {
	["galaxy_id"] = 1,
	["base_chapter_list"] = {1001, 1002, 1003, 1004, 1005, 1006},
	["advanced_chapter_list"] = {2001, 2002, 2003, 2004, 2005, 2006},
	["base_chapter_req"] = {{"level", 1}},
	["advanced_chapter_req"] = {{"level", 1}, {"gate", 1001050}},
	})
table.insert(galaxy, {
	["galaxy_id"] = 2,
	["base_chapter_list"] = {1007, 1008, 1009, 1010, 1011, 1012},
	["advanced_chapter_list"] = {2007, 2008, 2009, 2010, 2011, 2012},
	["base_chapter_req"] = {{"level", 30}, {"gate", 1006070}},
	["advanced_chapter_req"] = {{"level", 30}, {"gate", 2006070}},
	})
table.insert(galaxy, {
	["galaxy_id"] = 3,
	["base_chapter_list"] = {1013},
	["advanced_chapter_list"] = {2013},
	["base_chapter_req"] = {{"level", 60}, {"gate", 1012070}},
	["advanced_chapter_req"] = {{"level", 60}, {"gate", 2012070}},
	})
