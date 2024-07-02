RepairPoints = {
    [1] = {                                               -- Public Repair Point
        coords = vector4(-102.06, -2693.08, 6.20, 91.27), --coords of the repair point
        type = 'public',                                  --public, job, gang, private
        --[[ jobs = { ['police'] = 0 },
        gangs = { ['vagos'] = 0, ['lostmc'] = 0 },
        citizenids = {['GBT70740'] = true}, ]]
        repairCosts = { --repair costs for each weapon type
            ['pistol']  = { cost = 20000, time = 5 },
            ['smg']     = { cost = 50000, time = 10 },
            ['rifle']   = { cost = 100000, time = 15 },
            ['shotgun'] = { cost = 150000, time = 20 },
            ['sniper']  = { cost = 200000, time = 25 },
            ['mg']      = { cost = 250000, time = 30 },
        },
        tableTimeout = false, --time in seconds before the table is removed
        IsRepairing = false,  --don't touch
        RepairingData = {},   --don't touch
        debug = false         --debug mode
    },
    --[[ [2] = { -- Job Repair Point
        coords = vector4(487.68, -997.10, 30.69, 269.54),
        type = 'job',
        jobs = { ['police'] = 0 },
        repairCosts = {
            ['pistol']  = { cost = 2000, time = 5 },
            ['smg']     = { cost = 2500, time = 10 },
            ['rifle']   = { cost = 3000, time = 15 },
            ['shotgun'] = { cost = 3500, time = 20 },
            ['sniper']  = { cost = 4000, time = 25 },
            ['mg']      = { cost = 4500, time = 30 },
        },
        tableTimeout = false,
        IsRepairing = false,
        RepairingData = {},
        debug = false
    } ]]
}