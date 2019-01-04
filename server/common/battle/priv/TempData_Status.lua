------------------------------------------------------------
-- Temp status info data
-- This data need import from Status.csv

TempData_Status =
{
    DIED =
    {
        id = 1,
        statusName = "DIED",
        apply_formula = nil,
        update_formula = nil,
        cancel_formula = nil,
        end_formula = nil,
        unique = true,
        immunity = { "IDLE", "MOVE", "CAST", },
        mutex = nil,
        can_move = false,
        can_cast = false,
    },

    MOVE =
    {
        id = 2,
        statusName = "MOVE",
        apply_formula = nil,
        update_formula = "F_UpdateMOVE",
        cancel_formula = nil,
        end_formula = "F_EndMOVE",
        unique = false,
        immunity = nil,
        mutex = { "IDLE", "MOVE", },
        can_move = true,
        can_cast = true,
    },

    IDLE =
    {
        id = 3,
        statusName = "IDLE",
        apply_formula = nil,
        update_formula = nil,
        cancel_formula = nil,
        end_formula = "F_EndIDLE",
        unique = true,
        immunity = nil,
        mutex = nil,
        can_move = true,
        can_cast = true,
    },

    CAST =
    {
        id = 4,
        statusName = "CAST",
        apply_formula = "F_ApplyCAST",
        update_formula = "F_UpdateCAST",
        cancel_formula = nil,
        end_formula = "F_EndCAST",
        unique = false,
        immunity = nil,
        mutex = { "IDLE", "CAST", "MOVE", },
        can_move = false,
        can_cast = true,
    },

    TANK_FIXED =
    {
        id = 50,
        statusName = "TANK_FIXED",
        apply_formula = "",
        update_formula = "",
        cancel_formula = nil,
        end_formula = "",
        unique = true,
        immunity = nil,
        mutex = nil,
        can_move = false,
        can_cast = true,
    }
}