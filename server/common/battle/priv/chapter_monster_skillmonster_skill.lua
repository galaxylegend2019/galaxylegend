local monster_skill = GameData.chapter_monster_skill.monster_skill

table.insert(monster_skill, {
	["skill_id"] = 90001,
	["action_set_name"] = "CT_Apollo$Att02_1",
	["allow_move"] = true,
	["unit_type"] = 1,
	["target_select"] = {3},
	["damage"] = {{2, "main_arms", "sub_arms"}},
	["duration_time"] = 3.000000,
	["desc"] = "Apollo，单体普攻",
	})
table.insert(monster_skill, {
	["skill_id"] = 90002,
	["action_set_name"] = "CT_Apollo$Skill02_1",
	["cast_range"] = 18.000000,
	["allow_move"] = true,
	["unit_type"] = 1,
	["target_select"] = {3},
	["damage"] = {{2, "main_arms", "sub_arms"}, {3, 1, "EXPOSE_ARMOR", 8}},
	["duration_time"] = 3.000000,
	["desc"] = "Apollo，普通，破甲",
	})
