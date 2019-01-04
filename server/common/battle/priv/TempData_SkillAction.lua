------------------------------------------------------------
-- 技能表现数据，连接逻辑层和skill_action

TempData_SkillAction =
{
    ["RoundRecovery"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 0, waitTime = 0 },
        },
    },

    ------------------------------------------------------------

    ["CT_Apollo$Att02_1"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 180 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0,    "EA_Track", targetOb = 1, HitPivot = 1 },
            { 0.497, "EA_Track", targetOb = 1, HitPivot = 2, damage = false },
        },
    },

    ["CT_Apollo$Att02_2"] =
    {
        ExternalParameter =
        {
            TargetOffsetPos = { "F_EP_TargetPos" },
            TrackTime = { "F_EP_TrackTime", 180 },
            DamageTimes = "TrackTime",
        },
        ActionList =
        {
            { 0,  "EA_HitPosAoe", targetPos = 1, selectRadius = 10 },
        },
    },
    ["CT_Apollo$Skill01_Switch12"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 0, waitTime = 0 },
        },
    },

    ["CT_Apollo$Skill01_Switch21"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 0, waitTime = 0 },
        },
    },

    ["CT_Apollo$Skill02_1"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 180 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0,    "EA_Track", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Apollo$Skill02_2"] =
    {
        ExternalParameter =
        {
            TargetOffsetPos = { "F_EP_TargetPos" },
            TrackTime = { "F_EP_TrackTime", 180 },
            DamageTimes = "TrackTime",
        },
        ActionList =
        {
            { 0,  "EA_HitPosAoe", targetPos = 1, selectRadius = 10 },
        },
    },

    ------------------------------------------------------------

    ["CT_Takezo$Att02"] =
    {
        ExternalParameter = { },
        ActionList =
        {
            { 0.3,  "EA_HitOne", targetOb = 1, damage = false },
            { 0.65, "EA_HitOne", targetOb = 1 },
        },
    },

    ["CT_Takezo$Skill01"] =
    {
        ExternalParameter =
        {
            TrackTime = { "F_EP_TrackTime", 120 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 1.036, "EA_Track", targetOb = 1 },
        },
    },

    ["CT_Takezo$Skill02"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ["CT_Takezo$Skill03"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        }
    },

    ["CT_Takezo$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Prometheus$Att01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 4 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.238, "EA_Track", targetOb = 1,  HitPivot = 1},
            { 0.333, "EA_Track", targetOb = 1,  HitPivot = 2, damage = false},
            { 0.783, "EA_Track", targetOb = 1,  HitPivot = 3, damage = false},
            { 0.872, "EA_Track", targetOb = 1,  HitPivot = 4, damage = false},
        },
    },

    ["CT_Prometheus$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 4 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.238, "EA_Track", targetOb = 1,  HitPivot = 1},
            { 0.333, "EA_Track", targetOb = 1,  HitPivot = 2, damage = false},
            { 0.783, "EA_Track", targetOb = 1,  HitPivot = 3, damage = false},
            { 0.872, "EA_Track", targetOb = 1,  HitPivot = 4, damage = false},
        },
    },

    ["CT_Prometheus$Skill01"] =
    {
        ExternalParameter =
        {
            TargetPos = { "F_EP_TargetPos" },
        },
        ActionList =
        {
            -- 6
            { 1, "EA_RectAoeFromSelf", targetPos = 1, width = 5 },
            { 2, "EA_RectAoeFromSelf", targetPos = 1, width = 5 },
            { 3, "EA_RectAoeFromSelf", targetPos = 1, width = 5 },
            { 4., "EA_RectAoeFromSelf", targetPos = 1, width = 5 },
            { 6, "EA_RectAoeFromSelf", targetPos = 1, width = 5 },
            { 7, "EA_RectAoeFromSelf", targetPos = 1, width = 5 },
        },
    },

    ["CT_Prometheus$Skill02_1"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.464, "EA_HitOne", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Prometheus$Skill02_2"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.464, "EA_HitOne", targetOb = 1, HitPivot = 1, damage = 1 },
            { 0.464, "EA_HitOneAoe", targetOb = 1, waitTime = 0, damage = 2, selectRadius = 8 },
        },
    },

    ["CT_Prometheus$Skill03"] =
    {
        ExternalParameter =
        {
            TargetOffsetPos = { "F_EP_TargetPos" },
        },
        ActionList =
        {
            -- 10
            { 0.362, "EA_HitPosAoe", targetPos = 1, waitTime = 0.15, selectRadius = 8 },
            { 0.362, "EA_HitPosAoe", targetPos = 1, waitTime = 0.80, selectRadius = 8 },
            { 0.362, "EA_HitPosAoe", targetPos = 1, waitTime = 1.45, selectRadius = 8 },
            { 0.362, "EA_HitPosAoe", targetPos = 1, waitTime = 2.10, selectRadius = 8 },
            { 0.362, "EA_HitPosAoe", targetPos = 1, waitTime = 2.75, selectRadius = 8 },
            { 0.362, "EA_HitPosAoe", targetPos = 1, waitTime = 3.40, selectRadius = 8 },
            { 0.362, "EA_HitPosAoe", targetPos = 1, waitTime = 4.05, selectRadius = 8 },
            { 0.362, "EA_HitPosAoe", targetPos = 1, waitTime = 4.70, selectRadius = 8 },
            { 0.362, "EA_HitPosAoe", targetPos = 1, waitTime = 5.35, selectRadius = 8 },
            { 0.362, "EA_HitPosAoe", targetPos = 1, waitTime = 6.00, selectRadius = 8 },
        },
    },

    ["CT_Prometheus$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ------------------------------------------------------------
    ["CT_Medic$Att01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 1300 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.466, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Medic$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 1300 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.880, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Medic$Skill01"] =
    {
        ExternalParameter =
        {
            TargetIDs = { "F_EP_TargetIDs" },
        },
        ActionList =
        {
            { 1,  "EA_HitAll" },
            { 1.4,  "EA_HitAll" },
            { 1.8,  "EA_HitAll" },
            { 2.2,  "EA_HitAll" },
            { 2.6,  "EA_HitAll" },
            { 3,  "EA_HitAll" },
        },
    },

    ["CT_Medic$Skill02"] =
    {
        ExternalParameter =
        {
            TargetID = { "F_EP_TargetID" },
            EffectEnable = { "F_EP_IsTargetNotSelf" },
        },
        ActionList =
        {
            { 0.6, "EA_HitOne", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Medic$Skill03"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 30 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.468, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Medic$Skill04"] =
    {
        ExternalParameter =
        {
            TargetIDs = { "F_EP_TargetIDs" },
        },
        ActionList =
        {
            { 0,  "EA_HitAll" },
        },
    },

    ------------------------------------------------------------

    ["CT_Crius$Att01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 3 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.592, "EA_Track", targetOb = 1,  HitPivot = 1, damage = false },
            { 0.757, "EA_Track", targetOb = 1,  HitPivot = 2 },
            { 0.917, "EA_Track", targetOb = 1,  HitPivot = 3, damage = false },
        },
    },

    ["CT_Crius$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.38, "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 0.98, "EA_Track", targetOb = 1,  HitPivot = 2, damage = false },
        },
    },

    ["CT_Crius$Skill01"] =
    {
        ExternalParameter =
        {
            TargetOffsets = {"F_EP_TargetPosList"},
        },
        ActionList =
        {
            { 1.10, "EA_HitPosAoe", targetPos = 1, waitTime = 2, selectRadius = 3 },
            { 1.25, "EA_HitPosAoe", targetPos = 2, waitTime = 2, selectRadius = 3 },
            { 1.40, "EA_HitPosAoe", targetPos = 3, waitTime = 2, selectRadius = 3 },
            { 1.55, "EA_HitPosAoe", targetPos = 4, waitTime = 2, selectRadius = 3 },
            { 1.70, "EA_HitPosAoe", targetPos = 5, waitTime = 2, selectRadius = 3 },
            { 1.95, "EA_HitPosAoe", targetPos = 6, waitTime = 2, selectRadius = 3 },
        },
    },

    ["CT_Crius$Skill02"] =
    {
        ExternalParameter =
        {
            TargetOffsets = {"F_EP_TargetPosList"},
        },
        ActionList =
        {
            { 0.4, "EA_HitPosAoe", targetPos = 1, waitTime = 0, selectRadius = 5 },
            { 0.5, "EA_HitPosAoe", targetPos = 1, waitTime = 0, selectRadius = 5 },
            { 0.6, "EA_HitPosAoe", targetPos = 1, waitTime = 0, selectRadius = 5 },
            { 0.7, "EA_HitPosAoe", targetPos = 1, waitTime = 0, selectRadius = 5 },
        },
    },

    ["CT_Crius$Skill04"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.689, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Avatar$Att01"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 30 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.46, "EA_Track", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Avatar$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.43, "EA_Track", targetOb = 1,  HitPivot = 1 , damage = false },
            { 0.47, "EA_Track", targetOb = 1,  HitPivot = 2 },
        },
    },

    ["CT_Avatar$Skill01"] =
    {
        ExternalParameter =
        {
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            -- 10
            { 1.0,  "EA_HitOne", targetOb = 1 },
            { 1.5,  "EA_HitOne", targetOb = 1, damage = false },
            { 2.0,  "EA_HitOne", targetOb = 1, damage = 1 },
            { 2.5,  "EA_HitOne", targetOb = 1, damage = false },
            { 3.0,  "EA_HitOne", targetOb = 1, damage = 1 },
            { 3.5,  "EA_HitOne", targetOb = 1, damage = false },
            { 4.0,  "EA_HitOne", targetOb = 1, damage = 1 },
            { 4.5,  "EA_HitOne", targetOb = 1, damage = false },
            { 5.0,  "EA_HitOne", targetOb = 1, damage = 1 },
            { 5.5,  "EA_HitOne", targetOb = 1, damage = false },
        },
    },

    ["CT_Avatar$Skill02"] =
    {
        ExternalParameter =
        {
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.822, "EA_HitOne", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Avatar$Skill03"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 30 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.215, "EA_Track", targetOb = 1,  HitPivot = 1, damage = 1 },
            { 0.845, "EA_Track", targetOb = 1,  HitPivot = 2, damage = 2 },
        },
    },

    ["CT_Avatar$Skill04"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 10 },
            TrackTime = { "F_EP_TrackTime", 30 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.210, "EA_Track", targetOb = 1,  HitPivot = 1 },

            { 0.320, "EA_Track", targetOb = 1,  HitPivot = 3  },

            { 0.462, "EA_Track", targetOb = 1,  HitPivot = 5  },

            { 0.662, "EA_Track", targetOb = 1,  HitPivot = 7  },

            { 0.804, "EA_Track", targetOb = 1,  HitPivot = 9 },

            { 1.034, "EA_Track", targetOb = 1,  HitPivot = 11 },

            { 1.198, "EA_Track", targetOb = 1,  HitPivot = 13 },

            { 1.392, "EA_Track", targetOb = 1,  HitPivot = 15 },

            { 1.500, "EA_Track", targetOb = 1,  HitPivot = 17 },

            { 1.678, "EA_Track", targetOb = 1,  HitPivot = 19 },

        },
    },

    ------------------------------------------------------------

    ["CT_Abyss$Att01"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.26, "EA_Track", targetOb = 1,  HitPivot = 1},
        },
    },

    ["CT_Abyss$Att02"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.631, "EA_Track", targetOb = 1,  HitPivot = 1},
        },
    },

    ------------------------------------------------------------

    ["CT_Tenzai$Att01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.498, "EA_Track", targetOb = 1,  HitPivot = 1, },
            { 0.646, "EA_Track", targetOb = 1,  HitPivot = 2, },
        },
    },

    ["CT_Tenzai$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.786, "EA_Track", targetOb = 1,  HitPivot = 1, },
        },
    },

    ["CT_Tenzai$Skill01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 5 },
            TrackTime = { "F_EP_TrackTime", 45 },
            TargetIDs = { "F_EP_TargetIDs" },
        },
        ActionList =
        {
            { 1.0 , "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 1.07, "EA_Track", targetOb = 2,  HitPivot = 2 },
            { 1.14, "EA_Track", targetOb = 3,  HitPivot = 3 },
            { 1.21, "EA_Track", targetOb = 4,  HitPivot = 4 },
            { 1.28, "EA_Track", targetOb = 5,  HitPivot = 5 },
        },
    },

    ["CT_Tenzai$Skill02"] =
    {
        ExternalParameter =
        {
            TargetOffsetPos = { "F_EP_TargetPos" },
            TrackTime = { "F_EP_TrackTime", 30 },
            DamageTimes = { 2, "F_EP2_TrackTimeAddList", 0.595 },
        },
        ActionList =
        {
            { 0.595,  "EA_HitPosAoe", targetPos = 1, selectRadius = 8 },
        },
    },

    ["CT_Tenzai$Skill03"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.595, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Tenzai$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Hero$Att01_2"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.608, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Hero$Att02_2"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 180 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.651, "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 0.924, "EA_Track", targetOb = 1,  HitPivot = 2, damage = false },
        },
    },

    ["CT_Hero$Att01_1"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.581, "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 0.741, "EA_Track", targetOb = 1,  HitPivot = 2, damage = false },
        },
    },

    ["CT_Hero$Att02_1"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 180 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.6  , "EA_Track", targetOb = 1,  HitPivot = 1},
            { 0.875, "EA_Track", targetOb = 1,  HitPivot = 2, damage = false },
        },
    },

    ["CT_Hero$Skill01_3"] =
    {
        ExternalParameter =
        {
            TargetIDs = { "F_EP_TargetIDs" },
        },
        ActionList =
        {
            { 1.229,  "EA_HitAll" },
        },
    },

    ["CT_Hero$Skill02_1_2"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 1.382, "EA_Track", targetOb = 1,  HitPivot = 1},
        },
    },

    ["CT_Hero$Skill02_1_1"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.564, "EA_Track", targetOb = 1,  HitPivot = 1},
        },
    },

    ["CT_Hero$Skill03_1_2"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0.294, "EA_HitOne", targetOb = 1 },
        },
    },

    ["CT_Hero$Skill03_1_1"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ["CT_Hero$Skill04_1"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Zhar$Att01"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 30 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.62, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Zhar$Att02"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 30 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.62, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Zhar$Skill01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 5 },
            TrackTime = { "F_EP_TrackTime", 30 },
            TargetIDs = { "F_EP_TargetIDs" },
        },
        ActionList =
        {
            { 0.35, "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 0.50, "EA_Track", targetOb = 2,  HitPivot = 2 },
            { 0.65, "EA_Track", targetOb = 3,  HitPivot = 3 },
            { 0.80, "EA_Track", targetOb = 4,  HitPivot = 4 },
            { 0.95, "EA_Track", targetOb = 5,  HitPivot = 5 },
        },
    },

    ["CT_Zhar$Skill02"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 30 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.68, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Zhar$Skill03"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ["CT_Zhar$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Zero$Att01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.371, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Zero$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.282, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Zero$Skill01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 6 },
            TargetIDs = { "F_EP_TargetIDs" },
        },
        ActionList =
        {
            { 1.823,  "EA_HitAll" },
        },
    },

    ["CT_Zero$Skill02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 180 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.566, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Zero$Skill03"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 180 },
            TargetIDs = { "F_EP_TargetIDs" },
        },
        ActionList =
        {
            { 0.308, "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 0.682, "EA_Track", targetOb = 2,  HitPivot = 2 },
        },
    },

    ["CT_Zero$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 0, waitTime = 0 },
        },
    },


    ------------------------------------------------------------

    ["CT_Linnaeus$Att01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 42 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.589, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Linnaeus$Att02"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0.5, "EA_HitOne", targetOb = 1 },
        },
    },

    ["CT_Linnaeus$Skill01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 6 },
            TargetIDs = { "F_EP_TargetIDs" },
        },
        ActionList =
        {
            { 1.356,  "EA_HitAll" },
        },
    },

    ["CT_Linnaeus$Skill02"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ["CT_Linnaeus$Skill03"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0.807, "EA_HitOne", targetOb = 1, damage = 1 },
            { 1.133, "EA_HitOne", targetOb = 1, damage = 2 },
        },
    },

    ["CT_Linnaeus$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Nicole$Att01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 3 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.54, "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 0.617, "EA_Track", targetOb = 1,  HitPivot = 2, damage = false },
            { 0.702, "EA_Track", targetOb = 1,  HitPivot = 3, damage = false },
        },
    },

    ["CT_Nicole$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 1 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.672, "EA_HitOne", targetOb = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Soldier01$Att01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 30 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.779, "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 1.036, "EA_Track", targetOb = 1,  HitPivot = 2, damage = false },
        },
    },

    ["CT_Soldier01$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 30 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.779, "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 1.036, "EA_Track", targetOb = 1,  HitPivot = 2, damage = false },
        },
    },

    ------------------------------------------------------------

    ["CT_Soldier02$Att01"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.667, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Soldier02$Att02"] =
    {
        ExternalParameter =
        {
            TrackTime = { "F_EP_TrackTime", 30 },
            TargetPosList = { "F_EP_TargetPosCopy", 2, 5 },
            DamageTimes = { 2, "F_EP2_CopyValue", "TrackTime", 3},
        },
        ActionList =
        {
            { 0.667, "EA_RectAoePos", targetPos = 1, width = 5, height = 16 },
        },
    },

    ------------------------------------------------------------

    ["CT_Soldier03$Att01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.539, "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 0.843, "EA_Track", targetOb = 1,  HitPivot = 2, damage = false },
        },
    },

    ["CT_Soldier03$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
        },
        ActionList =
        {
            { 0.357, "EA_HitOne", targetOb = 1, HitPivot = 1 },
            { 0.357, "EA_HitOne", targetOb = 1, HitPivot = 1, damage = false },
        },
    },

    ------------------------------------------------------------

    ["CT_Soldier04$Att01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 1300 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.294, "EA_HitOne", targetOb = 1, HitPivot = 1, damage = false },
            { 0.295, "EA_HitOne", targetOb = 1, HitPivot = 2 },
        },
    },

    ["CT_Soldier04$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 1300 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.3, "EA_Track", targetOb = 1, HitPivot = 1, damage = false },
            { 0.3, "EA_Track", targetOb = 1, HitPivot = 2 },
        },
    },

    ------------------------------------------------------------

    ["CT_Soldier06$Att01"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.705, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Soldier06$Att02"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.715, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Jormungandr$Att01"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.9, "EA_HitOne", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Jormungandr$Att02"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0.4, "EA_HitOne", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Jormungandr$Skill01"] =
    {
        ExternalParameter =
        {
            TargetPos = { "F_EP_TargetPos" },
        },
        ActionList =
        {
            { 1.146, "EA_HitPosAoe", targetPos = 1, waitTime = 0, selectRadius = 50 },
        },
    },

    ["CT_Jormungandr$Skill02"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 1.338, "EA_HitOne", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Jormungandr$Skill03"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.9, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Jormungandr$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Rhinoceros$Att01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 30 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.634, "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 0.634, "EA_Track", targetOb = 1,  HitPivot = 1, damage = false },
        },
    },

    ["CT_Rhinoceros$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.4, "EA_HitOne", targetOb = 1,  HitPivot = 1},
            { 0.5, "EA_HitOne", targetOb = 1,  HitPivot = 2, damage = false },
        },
    },

    ["CT_Rhinoceros$Skill01"] =
    {
        ExternalParameter =
        {
            TargetIDs = { "F_EP_TargetIDs" },
        },
        ActionList =
        {
            { 1.12, "EA_HitAll" },
        },
    },

    ["CT_Rhinoceros$Skill02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 30 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.728, "EA_Track", targetOb = 1,  HitPivot = 1, damage = {1,3} },
            { 1.288, "EA_Track", targetOb = 1,  HitPivot = 1, damage = {2} },
        },
    },

    ["CT_Rhinoceros$Skill03"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0.552, "EA_HitOne", targetOb = 0, waitTime = 0 },
        },
    },

    ["CT_Rhinoceros$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 0, waitTime = 0 },
        },
    },

    ------------------------------------------------------------

    ["CT_ZagaraCore$Att01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 4 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.43, "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 0.48, "EA_Track", targetOb = 1,  HitPivot = 2, damage = false },
            { 0.81, "EA_Track", targetOb = 1,  HitPivot = 3, damage = false },
            { 0.86, "EA_Track", targetOb = 1,  HitPivot = 4, damage = false },
        },
    },

    ["CT_ZagaraCore$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 4 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.36 , "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 0.47 , "EA_Track", targetOb = 1,  HitPivot = 2, damage = false },
            { 0.945, "EA_Track", targetOb = 1,  HitPivot = 3, damage = false },
            { 1.025, "EA_Track", targetOb = 1,  HitPivot = 4, damage = false },
        },
    },


    ["CT_ZagaraCore$Skill01"] =
    {
        ExternalParameter =
        {
            TargetIDs = { "F_EP_TargetIDs" },
        },
        ActionList =
        {
            { 1.05,  "EA_HitAll" },
        },
    },

    ["CT_ZagaraCore$Skill02"] =
    {
        ExternalParameter =
        {
            TargetOffsetPos = { "F_EP_TargetPos" },
            TrackTime = { "F_EP_TrackTime", 130 },
            DamageTimes = "TrackTime",
        },
        ActionList =
        {
            { 0.643, "EA_HitPosAoe", targetPos = 1, selectRadius = 10 },
        },
    },

    ["CT_ZagaraCore$Skill03"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 0, waitTime = 0 },
        },
    },

    ["CT_ZagaraCore$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 0, waitTime = 0 },
        },
    },

    ------------------------------------------------------------

    ["CT_Ranger$Att01"] =
    {
        ExternalParameter =
        {
            HitPivot1 = { "F_EP_HitPivots", 1 },
            HitPivot2 = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 90 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.435, "EA_Track", targetOb = 1,  HitPivot = "HitPivot1", damage = false },
            { 0.531, "EA_Track", targetOb = 1,  HitPivot = "HitPivot2" },
        },
    },

    ["CT_Ranger$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.408 , "EA_Track", targetOb = 1,  HitPivot = 1},
        },
    },

    ["CT_Ranger$Skill01"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            --{ 1.8, "EA_Summon", targetPos = 1, waitTime = 0 },
        },
    },

    ["CT_Ranger_1$Skill01"] =
    {
        ExternalParameter =
        {
            TargetOffsets = {"F_EP_TargetPosList"},
            DamageTimes = { 2, "F_EP2_TrackTimeAddList",
                            0.10, 0.34, 0.39, 0.45, 0.63,
                            2.60, 2.70, 2.90, 3.10, 3.20,
                            5.10, 5.36, 5.61, 5.72, 5.80,
                            7.50, 7.59, 7.80, 8.00, 8.30 },

        },
        ActionList =
        {
            { 0.1, "EA_HitPosAoe", targetPos = 1, waitTime = 1, selectRadius = 3 },
            { 0.34, "EA_HitPosAoe", targetPos = 2, waitTime = 1, selectRadius = 3 },
            { 0.39, "EA_HitPosAoe", targetPos = 3, waitTime = 1, selectRadius = 3 },
            { 0.45, "EA_HitPosAoe", targetPos = 4, waitTime = 1, selectRadius = 3 },
            { 0.63, "EA_HitPosAoe", targetPos = 5, waitTime = 1, selectRadius = 3 },
            { 2.6, "EA_HitPosAoe", targetPos = 6, waitTime = 1, selectRadius = 3 },
            { 2.7, "EA_HitPosAoe", targetPos = 7, waitTime = 1, selectRadius = 3 },
            { 2.9, "EA_HitPosAoe", targetPos = 8, waitTime = 1, selectRadius = 3 },
            { 3.1, "EA_HitPosAoe", targetPos = 9, waitTime = 1, selectRadius = 3 },
            { 3.2, "EA_HitPosAoe", targetPos = 10, waitTime = 1, selectRadius = 3 },
            { 5.1, "EA_HitPosAoe", targetPos = 11, waitTime = 1, selectRadius = 3 },
            { 5.36, "EA_HitPosAoe", targetPos = 12, waitTime = 1, selectRadius = 3 },
            { 5.61, "EA_HitPosAoe", targetPos = 13, waitTime = 1, selectRadius = 3 },
            { 5.72, "EA_HitPosAoe", targetPos = 14, waitTime = 1, selectRadius = 3 },
            { 5.8, "EA_HitPosAoe", targetPos = 15, waitTime = 1, selectRadius = 3 },
            { 7.5, "EA_HitPosAoe", targetPos = 16, waitTime = 1, selectRadius = 3 },
            { 7.59, "EA_HitPosAoe", targetPos = 17, waitTime = 1, selectRadius = 3 },
            { 7.8, "EA_HitPosAoe", targetPos = 18, waitTime = 1, selectRadius = 3 },
            { 8, "EA_HitPosAoe", targetPos = 19, waitTime = 1, selectRadius = 3 },
            { 8.3, "EA_HitPosAoe", targetPos = 20, waitTime = 1, selectRadius = 3 },
        },
    },

    ["CT_Ranger$Skill02"] =
    {
        ExternalParameter =
        {
            TargetOffsets = { "F_EP_TargetPosList" },
            TrackTime = { "F_EP_TrackTime", 78 },
            DamageTimes = { 2, "F_EP2_TrackTimeAddList", 0.73, 0.827, 0.929 },
        },
        ActionList =
        {
            { 0.73, "EA_TrackPosAoe", targetPos = 1, selectRadius = 3 },
            { 0.827, "EA_TrackPosAoe", targetPos = 2, selectRadius = 3 },
            { 0.929, "EA_TrackPosAoe", targetPos = 3, selectRadius = 3 },
        },
    },

    ["CT_Ranger$Skill03"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 3 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.425 , "EA_Track", targetOb = 1,  HitPivot = 1},
            { 0.676 , "EA_Track", targetOb = 1,  HitPivot = 2},
            { 0.957, "EA_Track", targetOb = 1,  HitPivot = 3},
        },
    },

    ------------------------------------------------------------

    ["CT_Crow$Att01"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.665, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Crow$Att02"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.662, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Crow$Att03"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.7, "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 0.99, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Crow$Att04"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.7, "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 0.99, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Crow$Skill01"] =
    {
        ExternalParameter =
        {
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 1.512, "EA_HitOne", targetOb = 1,  waitTime = 0 },
        },
    },

    ["CT_Crow$Skill02"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.754, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Crow$Skill03"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ["CT_Crow$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Master$Att02"] =
    {
        ExternalParameter =
        {
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.643, "EA_HitOne", targetOb = 1,  waitTime = 0, damage = false },
            { 0.838, "EA_HitOne", targetOb = 1,  waitTime = 0, damage = false  },
            { 1.472, "EA_HitOne", targetOb = 1,  waitTime = 0 },
        },
    },

    ["CT_Master$Skill01"] =
    {
        ExternalParameter =
        {
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 1.039, "EA_HitOne", targetOb = 1,  waitTime = 0, damage = 2 },
            { 2.43, "EA_HitOne", targetOb = 1,  waitTime = 0, damage = 1 },
        },
    },

    ["CT_Master$Skill02_1"] =
    {
        ExternalParameter =
        {
            TargetPos = { "F_EP_TargetPos" },
        },
        ActionList =
        {
            { 0, "EA_SetStatus", targetOb = 0, status = "HURTLESS", enable = true },
            { 0.3,  "EA_SetPosition", targetPos = 1, isRecord = true },
            { 0.6, "EA_SetStatus", targetOb = 0, status = "HURTLESS", enable = false },
        },
    },

    ["CT_Master$Skill02_2"] =
    {
        ExternalParameter =
        {
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.1, "EA_HitOneAoe", targetOb = 1, waitTime = 0, selectRadius = 8 },
        },
    },

    ["CT_Master$Skill02_3"] =
    {
        ExternalParameter =
        {
            TargetPos = { "F_EP_TargetPos" },
        },
        ActionList =
        {
            { 0, "EA_SetStatus", targetOb = 0, status = "HURTLESS", enable = true },
            { 0.3,  "EA_SetPosition", targetPos = 1, isRecord = false },
            { 0.6, "EA_SetStatus", targetOb = 0, status = "HURTLESS", enable = false },
        },
    },

    ["CT_Master$Skill03"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ["CT_Master$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Fraillimus$Att01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.99 , "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 1.001, "EA_Track", targetOb = 1,  HitPivot = 2, damage = false },
        },
    },

    ["CT_Fraillimus$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.947, "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 0.998, "EA_Track", targetOb = 1,  HitPivot = 2, damage = false },
        },
    },

    ["CT_Fraillimus$Skill01"] =
    {
        ExternalParameter =
        {
            TargetIDs = { "F_EP_TargetIDs" },
        },
        ActionList =
        {
            { 2.3,  "EA_HitAll" },
        },
    },

    ["CT_Fraillimus$Skill02"] =
    {
        ExternalParameter =
        {
            TargetIDs = { "F_EP_TargetIDs" },
        },
        ActionList =
        {
            { 1.1, "EA_HitAll", damage = 1 }, -- 全体伤害
            { 1.1, "EA_HitOne", targetOb = { "F_TO_RandomOne" }, damage = 2 }, -- 随机1人减速
            { 1.1, "EA_HitOne", targetOb = { "F_TO_RandomOne" }, damage = 3 }, -- 随机1人停滞
        },
    },


    ["CT_Fraillimus$Skill03"] =
    {
        ExternalParameter =
        {
            TargetIDs = { "F_EP_TargetIDs" },
        },
        ActionList =
        {
            { 2.4,  "EA_HitAll" },
        },
    },

    ["CT_Fraillimus$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Rlyeh$Att01"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.423, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Rlyeh$Att02"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 1.058, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Rlyeh$Skill01"] =
    {
        ExternalParameter =
        {
            TargetOffsets = {"F_EP_TargetPosList"},
        },
        ActionList =
        {
            { 0.588, "EA_HitPosAoe", targetPos = 1, selectRadius = 6 },
            { 1.288, "EA_HitPosAoe", targetPos = 1, selectRadius = 6 },
            { 1.988, "EA_HitPosAoe", targetPos = 1, selectRadius = 6 },
            { 2.688, "EA_HitPosAoe", targetPos = 1, selectRadius = 6 },
            { 3.388, "EA_HitPosAoe", targetPos = 1, selectRadius = 6 },
        },
    },

    ["CT_Rlyeh$Skill02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 6 },
            TargetIDs = { "F_EP_TargetIDs" },
        },
        ActionList =
        {
            { 1.02,  "EA_HitAll" },
            { 1.23,  "EA_HitAll" },
        },
    },

    ["CT_Rlyeh$Skill03"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0.622, "EA_HitOne", targetOb = 1 },
        },
    },

    ["CT_Rlyeh$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Adam$Att01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.294, "EA_HitOne", targetOb = 1, HitPivot = 1, damage = false },
            { 0.295, "EA_HitOne", targetOb = 1, HitPivot = 2 },
        },
    },

    ["CT_Adam$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 1300 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.3, "EA_Track", targetOb = 1, HitPivot = 1, damage = false },
            { 0.3, "EA_Track", targetOb = 1, HitPivot = 2 },
        },
    },

    ["CT_Adam$Skill01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 20 },
            TrackTime = { "F_EP_TrackTime", 30 },
            TargetIDs = { "F_EP_TargetIDs" },
        },
        ActionList =
        {
            { 0.710, "EA_Track", targetOb = 1,  HitPivot = 1},
            { 0.765, "EA_Track", targetOb = 2,  HitPivot = 2},
            { 0.820, "EA_Track", targetOb = 3,  HitPivot = 3  },
            { 0.895, "EA_Track", targetOb = 4,  HitPivot = 4  },
            { 0.962, "EA_Track", targetOb = 5,  HitPivot = 5},
            { 1.062, "EA_Track", targetOb = 6,  HitPivot = 6},
            { 1.162, "EA_Track", targetOb = 7,  HitPivot = 7  },
            { 1.232, "EA_Track", targetOb = 8,  HitPivot = 8  },
            { 1.304, "EA_Track", targetOb = 9,  HitPivot = 9},
            { 1.414, "EA_Track", targetOb = 10,  HitPivot = 10},
            { 1.534, "EA_Track", targetOb = 11,  HitPivot = 11 },
            { 1.614, "EA_Track", targetOb = 12,  HitPivot = 12 },
            { 1.698, "EA_Track", targetOb = 13,  HitPivot = 13},
            { 1.796, "EA_Track", targetOb = 14,  HitPivot = 14},
            { 1.892, "EA_Track", targetOb = 15,  HitPivot = 15 },
            { 1.942, "EA_Track", targetOb = 16,  HitPivot = 16 },
            { 2.000, "EA_Track", targetOb = 17,  HitPivot = 17},
            { 2.089, "EA_Track", targetOb = 18,  HitPivot = 18},
            { 2.178, "EA_Track", targetOb = 19,  HitPivot = 19 },
            { 2.278, "EA_Track", targetOb = 20,  HitPivot = 20 },
        },
    },

    ["CT_Adam$Skill02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 40 },
            TargetIDs = { "F_EP_TargetIDs" },
        },
        ActionList =
        {
            { 0.904, "EA_Track", targetOb = 1, HitPivot = 1 },
            { 0.905, "EA_Track", targetOb = 2, HitPivot = 2 },
        },
    },

    ["CT_Adam$Skill03"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ["CT_Adam$Skill04"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 1300 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.294, "EA_Track", targetOb = 1, HitPivot = 1, damage = false },
            { 0.295, "EA_Track", targetOb = 1, HitPivot = 2 },
        },
    },

    ------------------------------------------------------------

    ["CT_Deathworm$Att01"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 30 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.573, "EA_HitOne", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Deathworm$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
        },
        ActionList =
        {
            { 0.357, "EA_HitOne", targetOb = 1, HitPivot = 1 },
            { 0.357, "EA_HitOne", targetOb = 1, HitPivot = 1, damage = false },
        },
    },

    ["CT_Deathworm$Skill01"] =
    {
        ExternalParameter =
        {
            TargetOffsetPos = { "F_EP_TargetPos" },
        },
        ActionList =
        {
            -- 10
            { 1.0, "EA_HitPosAoe", targetPos = 1, waitTime = 0.0, selectRadius = 8 },
            { 1.0, "EA_HitPosAoe", targetPos = 1, waitTime = 0.5, selectRadius = 8, damage = 1 },
            { 1.0, "EA_HitPosAoe", targetPos = 1, waitTime = 1.0, selectRadius = 8, damage = 1 },
            { 1.0, "EA_HitPosAoe", targetPos = 1, waitTime = 1.5, selectRadius = 8, damage = 1 },
            { 1.0, "EA_HitPosAoe", targetPos = 1, waitTime = 2.0, selectRadius = 8, damage = 1 },
            { 1.0, "EA_HitPosAoe", targetPos = 1, waitTime = 2.5, selectRadius = 8, damage = 1 },
            { 1.0, "EA_HitPosAoe", targetPos = 1, waitTime = 3.0, selectRadius = 8, damage = 1 },
            { 1.0, "EA_HitPosAoe", targetPos = 1, waitTime = 3.5, selectRadius = 8, damage = 1 },
            { 1.0, "EA_HitPosAoe", targetPos = 1, waitTime = 4.0, selectRadius = 8, damage = 1 },
            { 1.0, "EA_HitPosAoe", targetPos = 1, waitTime = 4.5, selectRadius = 8, damage = 1 },
        },
    },

    ["CT_Deathworm$Skill02"] =
    {
        ExternalParameter =
        {
            TargetPos = { "F_EP_TargetPos" },
        },
        ActionList =
        {
            { 0.952, "EA_RectAoeFromSelf", targetPos = 1, width = 20 },
        }
    },

    ["CT_Deathworm$Skill03"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0.714, "EA_HitOne", targetOb = 1 },
            --{ 0.800, "EA_HitOne", targetOb = 1, damage = 1 },
           -- { 0.900, "EA_HitOne", targetOb = 1, damage = 1 },
           -- { 1.000, "EA_HitOne", targetOb = 1, damage = 1 },
        },
    },

    ["CT_Deathworm$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Emma$Att01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.207, "EA_Track", targetOb = 1, HitPivot = 1 },
            { 0.274, "EA_Track", targetOb = 1, HitPivot = 2 },
            { 0.343, "EA_Track", targetOb = 1, HitPivot = 3 },
            { 0.458, "EA_Track", targetOb = 1, HitPivot = 4 },
        }
    },

    ["CT_Emma$Att02"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.282, "EA_HitOne", targetOb = 1, HitPivot = 1 },
        }
    },

    ["CT_Emma$Skill01"] =
    {
        ExternalParameter =
        {
            TargetOffsetPos = { "F_EP_TargetPos" },
            TrackTime = { "F_EP_TrackTime", 130 },
            DamageTimes = "TrackTime",
        },
        ActionList =
        {
            { 0.879, "EA_TrackPosAoe", targetPos = 1, selectRadius = 10 },
        },
    },

    ["CT_Emma$Skill03"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Staurt$Att01"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.296, "EA_Track", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Staurt$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.531, "EA_Track", targetOb = 1, HitPivot = 1 },
            { 0.532, "EA_Track", targetOb = 1, HitPivot = 2, damage = false },
        },
    },

    ["CT_Staurt$Skill01"] =
    {
        ExternalParameter =
        {
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 1.218, "EA_HitOne", targetOb = 1, damage = 1 }, -- 伤害
            { 1.718, "EA_HitOne", targetOb = 1, damage = 2 }, -- 吸蓝
            { 1.800, "EA_HitOne", targetOb = 0, damage = 3 }, -- 加蓝
        },
    },

    ["CT_Staurt$Skill02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 6 },
            TargetIDs = { "F_EP_TargetIDs" },
            TrackTime = { "F_EP_TrackTime", 60 },
            TrackTimeList = { 2, "F_EP2_TrackTimeAddList", 0, 0.3, 0.4, 0.9, 1.2, 1.5 },
        },
        ActionList =
        {
            { 0.296, "EA_HitAllArray" },
        },
    },

    ["CT_Staurt$Skill03"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ["CT_Staurt$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Rebirth$Att01"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.19, "EA_Track", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Rebirth$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.357, "EA_Track", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Rebirth$Skill01"] =
    {
        ExternalParameter =
        {
            TargetOffsetPos = { "F_EP_TargetPos" },
        },
        ActionList =
        {
            { 1.524, "EA_HitPosAoe", targetPos = 1, waitTime = 1.5, selectRadius = 8 },
        },
    },

    ["CT_Rebirth$Skill02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 4 },
            TrackTime = { "F_EP_TrackTime", 180 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.285, "EA_Track", targetOb = 1, HitPivot = 1 },
            { 0.385, "EA_Track", targetOb = 1, HitPivot = 1 },
            { 0.485, "EA_Track", targetOb = 1, HitPivot = 1 },
            { 0.585, "EA_Track", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Rebirth$Skill03"] =
    {
        ExternalParameter =
        {
            TargetOffsetPos = { "F_EP_TargetPos" },
        },
        ActionList =
        {
            -- 20
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 0.00, width = 5, lengthPercent = 0.10 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 0.25, width = 5, lengthPercent = 0.20 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 0.50, width = 5, lengthPercent = 0.30 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 0.75, width = 5, lengthPercent = 0.40 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 1.00, width = 5, lengthPercent = 0.50 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 1.25, width = 5, lengthPercent = 0.60 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 1.50, width = 5, lengthPercent = 0.70 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 1.75, width = 5, lengthPercent = 0.80 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 2.00, width = 5, lengthPercent = 0.90 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 2.25, width = 5, lengthPercent = 1.00 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 2.50, width = 5, lengthPercent = 1.00 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 2.75, width = 5, lengthPercent = 1.00 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 3.00, width = 5, lengthPercent = 1.00 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 3.25, width = 5, lengthPercent = 1.00 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 3.50, width = 5, lengthPercent = 1.00 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 3.75, width = 5, lengthPercent = 1.00 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 4.00, width = 5, lengthPercent = 1.00 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 4.25, width = 5, lengthPercent = 1.00 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 4.50, width = 5, lengthPercent = 1.00 },
            { 0.285, "EA_RectAoeFromSelf", targetPos = 1, waitTime = 4.75, width = 5, lengthPercent = 1.00 },
        },
    },

    ["CT_Rebirth$Skill04"] =
    {
        ExternalParameter =
        {
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 1.05, "EA_Track", targetOb = 1, waitTime = 0.2 },
        },
    },

    ------------------------------------------------------------

    ["CT_Eli$Att01"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.104, "EA_Track", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Eli$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.104, "EA_Track", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Eli$Skill01"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 1.645, "EA_HitOne", targetOb = 0 },
        },
    },

    ["CT_Eli$Skill01_summon"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0, "EA_Track", targetOb = 1, waitTime = 0.1 },
        },
    },

    ["CT_Eli$Skill02"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 1.645, "EA_HitOne", targetOb = 0 },
        },
    },

    ["CT_Eli$Skill02_summon"] =
    {
        ExternalParameter =
        {
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0, "EA_Track", targetOb = 1, waitTime = 0.1 },
        },
    },

    ["CT_Eli$Skill03"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 1.645, "EA_HitOne", targetOb = 0 },
        },
    },

    ["CT_Eli$Skill03_summon"] =
    {
        ExternalParameter =
        {
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0, "EA_Track", targetOb = 1, waitTime = 0.1 },
        },
    },

    ["CT_Eli$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Fireball$Att01"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.53, "EA_Track", targetOb = 1, HitPivot = 1 },
            { 0.54, "EA_Track", targetOb = 1, HitPivot = 2, damage = false },
        },
    },

    ["CT_Fireball$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.52, "EA_Track", targetOb = 1, HitPivot = 1 },
            { 0.53, "EA_Track", targetOb = 1, HitPivot = 2, damage = false },
        },
    },

    ["CT_Fireball$Skill01"] =
    {
        ExternalParameter =
        {
            TrackTime = { "F_EP_TrackTime", 80 },
            TargetOffsets = {"F_EP_TargetPosList"},
            DamageTimes = { 2, "F_EP2_TrackTimeAddList", 1.280, 1.572, 1.864, 2.156, 2.448 },
        },
        ActionList =
        {
            { 1.280, "EA_TrackPosAoe", targetPos = 1, selectRadius = 5 },
            { 1.572, "EA_TrackPosAoe", targetPos = 2, selectRadius = 5 },
            { 1.864, "EA_TrackPosAoe", targetPos = 3, selectRadius = 5 },
            { 2.156, "EA_TrackPosAoe", targetPos = 4, selectRadius = 5 },
            { 2.448, "EA_TrackPosAoe", targetPos = 5, selectRadius = 5 },
        },
    },

    ["CT_Fireball$Skill02"] =
    {
        ExternalParameter =
        {
            TrackTime = { "F_EP_TrackTime", 80 },
            TargetOffsetPos = {"F_EP_TargetPosList"},
            DamageTimes = "TrackTime",
        },
        ActionList =
        {
            { 0.53, "EA_TrackPosAoe", targetPos = 1, selectRadius = 5 },
        },
    },

    ["CT_Fireball$Skill03"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 0 },
        },
    },

    ["CT_Fireball$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 0 },
        },
    },

    ------------------------------------------------------------

    ["CT_Anna$Att01"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.569, "EA_HitOne", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Anna$Att02"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.555, "EA_HitOne", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Anna$Skill01"] =
    {
        ExternalParameter =
        {
            TargetIDs = { "F_EP_TargetIDs" },
            TeamDirection = { "F_EP_TeamFace" },
        },
        ActionList =
        {
            { 1.0,  "EA_HitAll" },
        },
    },

    ["CT_Anna$Skill02"] =
    {
        ExternalParameter =
        {
            TargetOffsetPos = { "F_EP_TargetPos" },
        },
        ActionList =
        {
            { 0.97, "EA_RectAoeFromSelf", targetPos = 1, width = 5 },
        },
    },

    ["CT_Anna$Skill03"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.97, "EA_Track", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Anna$Skill04"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.97, "EA_Track", targetOb = 1, HitPivot = 1, waitTime = 0.1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Megaconus$Att02"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.35, "EA_HitOne", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Megaconus$Skill01"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 2.145, "EA_Track", targetOb = 1, HitPivot = 1},
        },
    },

    ["CT_Megaconus$Skill02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 5 },
            TargetID = { "F_EP_TargetID" },
            Distance = { "F_EP_Self2TargetDistance", -3 }
        },
        ActionList =
        {
            -- 5
            { 1.0, "EA_HitOne", targetOb = 1, HitPivot = 1 },
            { 1.3, "EA_HitOne", targetOb = 1, HitPivot = 2 },
            { 1.6, "EA_HitOne", targetOb = 1, HitPivot = 3 },
            { 1.9, "EA_HitOne", targetOb = 1, HitPivot = 4 },
            { 2.1, "EA_HitOne", targetOb = 1, HitPivot = 5 },
        },
    },

    ["CT_Megaconus$Skill03"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 3 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.985, "EA_HitOne", targetOb = 1, HitPivot = 1 },
            { 1.293, "EA_HitOne", targetOb = 1, HitPivot = 1 },
            { 1.679, "EA_HitOne", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Megaconus$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 0 },
        },
    },

    ------------------------------------------------------------


    ["CT_Ares$Att02_Down"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 180 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.3, "EA_Track", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Ares$Att02_Up"] =
    {
        ExternalParameter =
        {
            TargetOffsetPos = { "F_EP_TargetPos" },
            TrackTime = { "F_EP_TrackTime", 180 },
            DamageTimes = "TrackTime",
        },
        ActionList =
        {
            { 0,  "EA_HitPosAoe", targetPos = 1, selectRadius = 5 },
        },
    },

    ["CT_Ares$Skill01_Down2Up"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 0, waitTime = 0 },
        },
    },

    ["CT_Ares$Skill01_Up2Down"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 0, waitTime = 0 },
        },
    },

    ["CT_Ares$Skill02_Down"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 180 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.1, "EA_Track", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Ares$Skill02_Up"] =
    {
        ExternalParameter =
        {
            TargetOffsetPos = { "F_EP_TargetPos" },
        },
        ActionList =
        {
            { 0.2,  "EA_HitPosAoe", targetPos = 1, selectRadius = 8 },
        },
    },

    ["CT_Ares$Skill03"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 0 },
        },
    },

    ["CT_Ares$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 0 },
        },
    },

    ------------------------------------------------------------

    ["CT_Desperado$Att01"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 60 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 1.392, "EA_Track", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Desperado$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 2 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.875, "EA_HitOne", targetOb = 1, HitPivot = 1 },
            { 1.272, "EA_HitOne", targetOb = 1, HitPivot = 2 },
        },
    },

    ["CT_Desperado$Skill01"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 6 },
            TargetIDs = { "F_EP_TargetIDs" },
        },
        ActionList =
        {

            { 1.735, "EA_HitAll"},
            { 2.0, "EA_SetStatus", targetOb = 0, status = "DEATH_RAID", enable = false },
        },

    },

    ["CT_Desperado$Skill02"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 1.735, "EA_HitOne", targetOb = 1, HitPivot = 1 },
        }
    },

    ["CT_Desperado$Skill03"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ["CT_Desperado$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ------------------------------------------------------------

    ["CT_Sarah$Att01"] =
    {
        ExternalParameter =
        {
            HitPivot = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.667, "EA_Track", targetOb = 1, HitPivot = 1 },
        },
    },

    ["CT_Sarah$Att02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 3 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 0.308, "EA_Track", targetOb = 1,  HitPivot = 1 },
            { 0.399, "EA_Track", targetOb = 1,  HitPivot = 2 },
            { 1.071, "EA_Track", targetOb = 1,  HitPivot = 3 },
        },
    },

    ["CT_Sarah$Skill01"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },

    ["CT_Sarah$Skill02"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 3 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 1.303, "EA_Track", targetOb = 1,  HitPivot = 1, damage = 1 },
            { 1.433, "EA_Track", targetOb = 1,  HitPivot = 2, damage = 1 },
            { 1.573, "EA_Track", targetOb = 1,  HitPivot = 3 },
        },
    },

    ["CT_Sarah$Skill03"] =
    {
        ExternalParameter =
        {
            HitPivots = { "F_EP_HitPivots", 1 },
            TrackTime = { "F_EP_TrackTime", 130 },
            TargetID = { "F_EP_TargetID" },
        },
        ActionList =
        {
            { 1.2, "EA_Track", targetOb = 1,  HitPivot = 1 },
        },
    },

    ["CT_Sarah$Skill04"] =
    {
        ExternalParameter = {},
        ActionList =
        {
            { 0, "EA_HitOne", targetOb = 1 },
        },
    },
}
