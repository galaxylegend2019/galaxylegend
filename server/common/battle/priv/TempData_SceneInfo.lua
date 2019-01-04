------------------------------------------------------------
-- 场景配置数据
-- 现在觉得这个设计不太好，忍一段时间再说 - by wangxiangwei

TempData_SceneInfo =
{
    -- pvp专用
    ["pvp_scene"] =
    {
        pheseType = 1,
        phaseList =
        {
            {"DoCreateFighters", {team = "teamA", index = 1}},
            {"DoCreateFighters", {team = "teamB", index = 1}},
            {"DoCameraAni", {time = 3.3, curve = "CameraInScreenCurve", round = 1}},
            {"DoFightersEnter", {time = 4.5, team = "teamA"}},
            {"DoWaitTime", {1}},
            {"DoRound", {1,1}},
            {"DoFight", {3000}},
            {"DoEnd", { time_1 = 0.2, time_2 = 0.2 }},
        },
    },

    -- drama专用
    ["drama_scene"] =
    {
        pheseType = 1,
        phaseList =
        {
            {"DoCreateFighters", {team = "teamA", index = 1}},
            {"DoCreateFighters", {team = "teamB", index = 1}},
            {"DoCameraAni", {time = 3.3, curve = "CameraInScreenCurve_Fte", round = 1}},
            {"DoFightersEnter", {time = 4.5, team = "teamA"}},
            {"DoWaitTime", {1}},
            {"DoRound", {1,1}},
            {"DoFight", {3000}},
            {"DoEnd", { time_1 = 0.2, time_2 = 0.2 }},
        },
    },

    -- Normal Combat Process: 1 rounds template
    ["round_1"] =
    {
        pheseType = 1,
        phaseList =
        {
            {"DoCreateFighters", {team = "teamA", index = 1}},
            {"DoCreateFighters", {team = "teamB", index = 1}},
            {"DoCameraAni", {time = 3.3, curve = "CameraInScreenCurve", round = 1}},
            {"DoFightersEnter", {time = 4.5, team = "teamA"}},
            {"DoWaitTime", {1}},
            {"DoRound", {1,1}},
            {"DoFight", {3000}},
            {"DoEnd", { time_1 = 0.2, time_2 = 0.2 }},
        },
    },

    -- Normal Combat Process: 2 rounds template
    ["round_2"] =
    {
        pheseType = 1,
        phaseList =
        {
            {"DoCreateFighters", {team = "teamA", index = 1}},
            {"DoCreateFighters", {team = "teamB", index = 1}},
            {"DoCameraAni", {time = 3.3, curve = "CameraInScreenCurve", round = 1}},
            {"DoFightersEnter", {time = 4.5, team = "teamA"}},
            {"DoWaitTime", {0.2}},
            {"DoRound", {1,2}},
            {"DoFight", {3000}},
            {"DoWaitTime", {0.2}},
            {"DoClear", {}},
            {"DoCreateFighters", {team = "teamB", index = 2}},
            {"DoRallyFighters", {team = "teamA"}},
            {"DoRecoveryFighters", {team = "teamA", time = 0.1}},
            {"DoMoveFighters", {team = "teamA"}},
            {"DoRound", {2,2}},
            {"DoFight", {3000}},
            {"DoEnd", { time_1 = 0.2, time_2 = 0.2 }},
        },
    },

    -- Normal Combat Process: 3 rounds template
    ["round_3"] =
    {
        pheseType = 1,
        phaseList =
        {
            {"DoCreateFighters", {team = "teamA", index = 1}},
            {"DoCreateFighters", {team = "teamB", index = 1}},
            {"DoCameraAni", {time = 3.3, curve = "CameraInScreenCurve", round=1}},
            {"DoFightersEnter", {time = 4.5, team = "teamA"}},
            {"DoWaitTime", {0.2}},
            {"DoRound", {1,3}},
            {"DoFight", {3000}},
            {"DoWaitTime", {0.2}},
            {"DoClear", {}},
            {"DoCreateFighters", {team = "teamB", index = 2}},
            {"DoRallyFighters", {team = "teamA"}},
            {"DoRecoveryFighters", {team = "teamA", time = 0.1}},
            {"DoMoveFighters", {team = "teamA"}},
            {"DoRound", {2,3}},
            {"DoFight", {3000}},
            {"DoWaitTime", {0.2}},
            {"DoClear", {}},
            {"DoCreateFighters", {team = "teamB", index = 3}},
            {"DoRallyFighters", {team = "teamA"}},
            {"DoRecoveryFighters", {team = "teamA", time = 0.1}},
            {"DoMoveFighters", {team = "teamA"}},
            {"DoRound", {3,3}},
            {"DoFight", {3000}},
            {"DoEnd", { time_1 = 0.2, time_2 = 0.2 }},
        },
    },

    -- 群P
    ["nvn_scene"] =
    {
        pheseType = 2, -- 动态流程
        phaseList =
        {
            -- 初始出场
            {"DoCreateTeam"}, -- 创建双方残缺团队
            {"DoCameraAni", {time = 3.3, curve = "CameraInScreenCurve"}},
            {"DoFightersEnter", {time = 4.5, team = "teamA"}}, -- 角色进场
            {"DoWaitTime", {0.2}},
            {"DoRound"},
            {"DoFight", {3000}}, -- 第1回合
            {"DoWaitTime", {2}},
            {"DoClear"},
            {"DoDynamicPhase"},  -- 动态节点
        },
        dynamicCombatList =
        {
            -- 循环战斗
            {"DoHoming", {time = 3}},
            {"DoRecoveryFighters", {time = 0.1}},
            {"DoCreateTeam"}, -- 创建双方残缺团队
            {"DoFightersEnterRound", {time = 1}}, -- 补充队伍角色进场
            {"DoWaitTime", {1}},
            {"DoRound"},
            {"DoFight", {3000}},
            {"DoWaitTime", {2}},
            {"DoClear"},
            {"DoDynamicPhase"},  -- 循环检测
        },
        dynamicEndList =
        {
            {"DoEnd", { time_1 = 0.2, time_2 = 0.2 }}, -- 结束
        },
    },

------------------------------------------------------------------------------------------------------------------

    -- Specific Combat Process
}
