-- costs/data module
-- inside: [[Category:Modules]] using this line once...
--   this is a SEQUENCE as long as first-level items remain as sub-tables...
-- <ore>
return {
    t1c = {
        name = 'Tier 1 Crew',
        levels = {
            slvl = 1,
            elvl = 50,
            nstp = 10,
        },
        -- tier-steps start to end give nstp+1 entries
        tsteps = {  1,   3,  5,  8, 12,
                    16, 22, 28, 34, 42, 50,
        },
        currency1 = 'dilithium',
        values1 = {
            -- groups of start & increment , from begin to end level
            -- ((does not necessarily match the level-steps for the tier...))
            sval1 = 100,
            ival1 = 25,
            blvl1 = 2,   -- first cost is to reach lvl-2 using 100 xtals...
            elvl1 = 50,  -- last costs are reaching lvl-49=1275, 50 unneeded?
        },
        currency2 = 'coins',
        values2 = { tbd = 'idk',
            -- groups of start & increment , from begin to end level
        },
    },
    t2c = {
        name = 'Tier 2 Crew',
        levels = {
            slvl = 10,
            elvl = 95,
            nstp = 15,
        },
        -- tier-steps start to end give nstp+1 entries
        tsteps = {  10, 12, 14, 16, 18,
                    20, 25, 30, 36, 42,
                    50, 58, 66, 74, 84, 95,
        },
        currency1 = 'dilithium',
        values1 = {
            -- groups of start & increment , from begin to end level
            -- ((does not necessarily match the level-steps for the tier...))
            sval1 = 75,
            ival1 = 25,
            blvl1 = 11,  -- first cost is to reach lvl-11 using 75 xtals...
            --  reached lvl-50 spending 22,500
            --  then lvl-51 needs-to-use 1075 xtals... etc... see [[adm.kirk]]
            elvl1 = 95,  -- last costs are still tbd, but diff.vals check...
        },
    },
    t3c = {
        name = 'Tier 3 Crew',
        levels = {
            slvl = 40,
            elvl = 165,
            nstp = 15,
        },
        -- tier-steps start to end give nstp+1 entries
        tsteps = {  40,  42,  44,  50,  56,
                    62,  68,  74,  80,  88,
                    96, 105, 115, 125, 145, 165,
        },
        currency1 = 'dilithium',
        values1 = {
            -- groups of start & increment , from begin to end level
            -- ((does not necessarily match the level-steps for the tier...))
            sval1 = 50,
            ival1 = 25,
            blvl1 = 41,  -- first cost is to reach lvl-41 using 50 xtals
            -- reached lvl-50 spending 1625
            -- then lvl-51 needs-to-use 300 xtals...  etc... [[currency]]
            elvl1 = 165,
        },
    },
    -- t1s => t1c,
    t1s = {
        name = 'Tier 1 Ship',
        levels = {
            slvl = 1,
            elvl = 50,
            nstp = 10,
        },
        -- tier-steps start to end give nstp+1 entries
        tsteps = {  1,   3,  5,  8, 12,
                    16, 22, 28, 34, 42, 50,
        },
        currency1 = 'dilithium',
        values1 = {
            -- groups of start & increment , from begin to end level
            -- ((does not necessarily match the level-steps for the tier...))
            sval1 = 100,
            ival1 = 25,
            blvl1 = 2,   -- first cost is to reach lvl-2 using 100 xtals...
            elvl1 = 50,  -- last costs are reaching lvl-49=1275, 50 unneeded?
        },
    },
    t2s = {
        -- tbd...???
        name = 'Tier 2 Ship',
        levels = {
            slvl = 10,
            elvl = 95,
            nstp = 15,
        },
        -- tier-steps start to end give nstp+1 entries
        tsteps = {  10, 12, 14, 16, 18,
                    20, 25, 30, 36, 42,
                    50, 58, 66, 74, 84, 95,
        },
        currency1 = 'dilithium',
        values1 = {
            -- groups of start & increment , from begin to end level
            -- ((does not necessarily match the level-steps for the tier...))
            sval1 = 75,
            ival1 = 50,   -- 11=75, 12=125, 13=?=175
                blvl1 = 11,
                elvl1 = 12,
            sval2 = 165,  -- should be 175, but drop-by-10, stepdown-by-5...
            ival2 = 45,   -- 13=165, 14=210, 15=255, 16=300, 17=?=345
                blvl2 = 13,
                elvl2 = 16,
            sval3 = 340,  -- should be 345, but drop-by-5, stepdown-by-5...
            ival3 = 40,   -- 17=340, 18=380, 19=420, 20=?=460,
                blvl3 = 17,
                elvl3 = 19,
            sval4 = 455,  -- should be 460, but drop-by-5, stepdown-by-5...
            ival4 = 35,   -- 20=455, 21=490, 22=?=525,
                blvl4 = 20,
                elvl4 = 21,
            sval5 = 515,  -- should be 525, but drop-by-10, stepdown-by-10...
            ival5 = 25,   -- 22=515, 23=540, 24=?=565,
                blvl5 = 22,
                elvl5 = 23,
            sval6 = 570,  -- should be 565, but raise-by-5, stepup-by-5...
            ival6 = 30,   -- 24=570, 25=600, 26=?=630,
                blvl6 = 24,
                elvl6 = 25,
            sval7 = 625,  -- should be 630, but drop-by-5, stepdown-by-5...
            ival7 = 25,   -- 26=625, 27=650, 28=675, 29=700, 30=725,
                            -- 31=750, 32=775, 33=800, 34=?=825,
                blvl7 = 26,
                elvl7 = 33,
            sval8 = 830,  -- should be 825, but raise-by-5, stepup-by-5...
            ival8 = 30,   -- 34=830, 35=860, 36=890, 37=920, 38=?=950,
                blvl8 = 34,
                elvl8 = 37,
            sval9 = 940,  -- should be 950, but drop-by-10, stepdown-by-10...
            ival9 = 20,   -- 38=940, 39=960, 40=980, 41=?=1000,
                blvl9 = 38,
                elvl9 = 40,
            sval10 = 1040,  -- should be 1000, but raise-by-40, nc
            ival10 = 20,    -- 41=1040, 42=1060, 43=?=1080,
                blvl10 = 41,
                elvl10 = 42,
            sval11 = 1090,  -- should be 1080, but raise-by-10, stepup-by-10.
            ival11 = 30,    -- 43=1090, 44=1120, 45=?=1150,
                blvl11 = 43,
                elvl11 = 44,
            sval12 = 1145,  -- should be 1150, but anomalous value/stepchg
            ival12 = 35,    -- 45=1145, 46=1180, 47=?=1215
                blvl12 = 45,
                elvl12 = 46,
            sval13 = 1210,  -- could be 1180+30, excepting anomalous value
            ival13 = 30,    -- 47=1210, 48=1240, 49=1270, 50=1300, 51=?=1330
                blvl13 = 47,
                elvl13 = 50,
            sval14 = 1325,  -- should be 1330, but drop-by-5, stepup-by-5...
            ival14 = 35,    -- 51=1325, 52=1360, 53=1395, 54=1430, 55=1465,
                            -- 56=1500, 57=?=1535,   8475
                blvl14 = 51,
                elvl14 = 56,
            sval15 = 1500,  -- just decide that magic stops at 1500...
            ival15 = 0,     -- solves 11,475 for 51-58...
                blvl15 = 57,
                elvl15 = 95,
        },
    },
}

