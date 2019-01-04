matchInfo = {
    [teamA] = {
        heroList = {
            英雄1 = {
                rid = 全战场的唯一id,
                hero_id = 英雄编号,
                grow = 英雄等级,
                quality = 英雄品质,
                star = 英雄星级,
                skill = {
                    技能编号1 = 技能等级1,
                    技能编号2 = 技能等级2,
                    技能编号3 = 技能等级3,
                    ...
                },
                equipment = {
                    装备部位编号1 = { level = 装备等级,  advance = 装备品质 },
                    装备部位编号2 = { level = 装备等级,  advance = 装备品质 },
                    装备部位编号3 = { level = 装备等级,  advance = 装备品质 },
                    ...
                }
            },

            英雄2 = { ... },
            英雄3 = { ... },
            ....
        }
    }

    [teamB] = {
        (同上)
    }
}

return = {
    result = {
        ["useTime"] = 0.23999999999978,
        ["combatResult"] = {
            ["team_index_a"] = 2,
            ["team_list_a"] = {
                -- 第1个patch队伍
                [1] = {
                    hero_result_list = {
                        -- 英雄1
                        [1] = {
                            rid = "564243745917529",
                            id = 22,
                            hp = 142,
                            mp = 22,
                            dps = 2343,
                            is_dead = true,
                        },
                        -- 英雄2
                        ...
                    },
                    team_total_dps = 9999,
                }
                -- 第2个patch队伍
                [2] = ...
                ...
            },
            ["team_index_b"] = 1,
            ["team_list_b"] = {
                ...
            },
            ["is_a_win"] = true,
        },
        ["driveTimes"] = 3355,
    },
}
