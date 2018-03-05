-- starshipcodes/testcases module
-- inside: [[Category:Modules]] using this line once...

-- Unit tests for [[Module:Starshipcodes]]. Click talk page to run tests.

local p = require('Dev:UnitTests')

local ans1 =        'CommonCodes bad-which :'
local ans2 =        'invalid sorc-value >>'
local ans3 =        'glbls.args={ [1] = s,'
local ans4 =        'main-fail'

function p:test_hello()
    self:preprocess_equals('{{#invoke:Starshipcodes | hello}}', 'Hello, world!')
end

function p:test_nonmains()
    self:preprocess_equals('{{#invoke:Starshipcodes | codename | SGZ }}', 'stargazer-3')
--    self:preprocess_equals('{{#invoke:Starshipcodes | dumpInfobox | SGZ }}', 'stargazer-3')
--    self:preprocess_equals('{{#invoke:Starshipcodes | getSkills | SGZ }}', 'stargazer-3')
end

function p:test_names()
    self:preprocess_equals('{{#invoke:Starshipcodes | main | SGZ }}', '[[Stargazer]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | END }}', '[[Next&nbsp;Enterprise]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | TS }}', '[[Tsiolkovsky]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | BC1 }}', '[[Cube&nbsp;1]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | BC2 }}', '[[Cube&nbsp;2]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | CG }}', '[[Galor]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | CH }}', '[[Hideki]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | FDM }}', '[[Marauder]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | KNV }}', '[[Negh\'var]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | KV }}', '[[Ship-Vor\'Cha]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | RDD }}', '[[D\'deridex]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | RS }}', '[[Scout]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | ENA }}', '[[Enterprise&nbsp;A]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | ENB }}', '[[Enterprise&nbsp;B]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | EN }}', '[[Original&nbsp;Enterprise]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | HOZ }}', '[[Horizon]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | REL }}', '[[Reliant]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | KBP }}', '[[Klingon bop]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | KEB }}', '[[Early bop]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | KKT }}', '[[K\'Tinga]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | KR }}', '[[Raptor]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | RBP }}', '[[Romulan bop]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | RD7 }}', '[[D-7]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | RV7 }}', '[[V-7]]')
end

function p:test_listShips()
    --- note: spaces are important for exactness...
    self:preprocess_equals('{{#invoke:Starshipcodes | main | list | SGZ }}', 'Lists must be in name,number pairs')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | list | SGZ | 1 }}', '1 [[Stargazer]] ')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | list | SGZ | -1.250 }}', '-1.250 [[Stargazer]] ')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | list | SGZ | 2 | END | 4}}', '2 [[Stargazer]]  and 4 [[Next&nbsp;Enterprise]] ')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | list | SGZ | 2 | END | 4 | BC1 | 3 }}', '2 [[Stargazer]] , 4 [[Next&nbsp;Enterprise]] , and 3 [[Cube&nbsp;1]] ')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | list | SGZ | 2 | END | 4 | JUNK | 3 }}', '2 [[Stargazer]] , 4 [[Next&nbsp;Enterprise]] , and 3 tbd... ')
end

local blnkDump = '{ ["aenu"] = ,["ag"] = ,["aliases"] = ,["ar"] = ,["aw"] = ,["cargo"] = { ["crewamt"] = ,["crmax"] = ,["crmin"] = ,["crtyp"] = ,["weaponamt"] = ,["wpmax"] = ,["wpmin"] = ,["wptyp"] = ,} ,["cargoUpgrades"] = { ["cupgr1"] = { ["crewamt"] = ,["currentlevel"] = ,["weaponamt"] = ,} ,["cupgr10"] = { ["crewamt"] = ,["currentlevel"] = ,["weaponamt"] = ,} ,["cupgr11"] = { ["crewamt"] = ,["currentlevel"] = ,["weaponamt"] = ,} ,["cupgr12"] = { ["crewamt"] = ,["currentlevel"] = ,["weaponamt"] = ,} ,["cupgr13"] = { ["crewamt"] = ,["currentlevel"] = ,["weaponamt"] = ,} ,["cupgr14"] = { ["crewamt"] = ,["currentlevel"] = ,["weaponamt"] = ,} ,["cupgr15"] = { ["crewamt"] = ,["currentlevel"] = ,["weaponamt"] = ,} ,["cupgr16"] = { ["crewamt"] = ,["currentlevel"] = ,["weaponamt"] = ,} ,["cupgr2"] = { ["crewamt"] = ,["currentlevel"] = ,["weaponamt"] = ,} ,["cupgr3"] = { ["crewamt"] = ,["currentlevel"] = ,["weaponamt"] = ,} ,["cupgr4"] = { ["crewamt"] = ,["currentlevel"] = ,["weaponamt"] = ,} ,["cupgr5"] = { ["crewamt"] = ,["currentlevel"] = ,["weaponamt"] = ,} ,["cupgr6"] = { ["crewamt"] = ,["currentlevel"] = ,["weaponamt"] = ,} ,["cupgr7"] = { ["crewamt"] = ,["currentlevel"] = ,["weaponamt"] = ,} ,["cupgr8"] = { ["crewamt"] = ,["currentlevel"] = ,["weaponamt"] = ,} ,["cupgr9"] = { ["crewamt"] = ,["currentlevel"] = ,["weaponamt"] = ,} ,} ,["currentlevel"] = ,["govt"] = ,["hp"] = ,["igp"] = ,["image"] = ,["imagecaption"] = ,["limit"] = ,["lmax"] = ,["lmin"] = ,["name"] = ,["nup"] = ,["othersUpgrades"] = { ["up03"] = { ["ag"] = ,["ar"] = ,["aw"] = ,["currentlevel"] = 50,["hp"] = ,["skillschosen"] = 1o1y1b,} ,["up09"] = { ["ag"] = ,["ar"] = ,["aw"] = ,["currentlevel"] = 96,["hp"] = ,["skillschosen"] = 3o3y3b,} ,["up10"] = { ["ag"] = ,["ar"] = ,["aw"] = ,["currentlevel"] = 50,["hp"] = ,["skillschosen"] = 5o5y0b,} ,["up15"] = { ["ag"] = ,["ar"] = ,["aw"] = ,["currentlevel"] = 95,["hp"] = ,["skillschosen"] = 5o5y5b,} ,} ,["sdate"] = ,["series"] = ,["skills"] = { ["color1"] = ,["color2"] = ,["color3"] = ,["cost1"] = ,["cost2"] = ,["cost3"] = ,["desc1"] = { ["t1"] = ,["t2"] = ,["t3"] = ,["t4"] = ,["t5"] = ,["t6"] = ,["v1"] = ,["v2"] = ,["v3"] = ,["v4"] = ,["v5"] = ,} ,["desc2"] = { ["t1"] = ,["t2"] = ,["t3"] = ,["t4"] = ,["t5"] = ,["t6"] = ,["v1"] = ,["v2"] = ,["v3"] = ,["v4"] = ,["v5"] = ,} ,["desc3"] = { ["t1"] = ,["t2"] = ,["t3"] = ,["t4"] = ,["t5"] = ,["t6"] = ,["v1"] = ,["v2"] = ,["v3"] = ,["v4"] = ,["v5"] = ,} ,["skill1"] = ,["skill2"] = ,["skill3"] = ,} ,["skillsUpgrades"] = { ["supgr2"] = { ["cost1"] = ,["cost2"] = ,["cost3"] = ,["desc1"] = { ["v1"] = ,["v2"] = ,["v3"] = ,["v4"] = ,["v5"] = ,} ,["desc2"] = { ["v1"] = ,["v2"] = ,["v3"] = ,["v4"] = ,["v5"] = ,} ,["desc3"] = { ["v1"] = ,["v2"] = ,["v3"] = ,["v4"] = ,["v5"] = ,} ,} ,["supgr3"] = { ["cost1"] = ,["cost2"] = ,["cost3"] = ,["desc1"] = { ["v1"] = ,["v2"] = ,["v3"] = ,["v4"] = ,["v5"] = ,} ,["desc2"] = { ["v1"] = ,["v2"] = ,["v3"] = ,["v4"] = ,["v5"] = ,} ,["desc3"] = { ["v1"] = ,["v2"] = ,["v3"] = ,["v4"] = ,["v5"] = ,} ,} ,["supgr4"] = { ["cost1"] = ,["cost2"] = ,["cost3"] = ,["desc1"] = { ["v1"] = ,["v2"] = ,["v3"] = ,["v4"] = ,["v5"] = ,} ,["desc2"] = { ["v1"] = ,["v2"] = ,["v3"] = ,["v4"] = ,["v5"] = ,} ,["desc3"] = { ["v1"] = ,["v2"] = ,["v3"] = ,["v4"] = ,["v5"] = ,} ,} ,["supgr5"] = { ["cost1"] = ,["cost2"] = ,["cost3"] = ,["desc1"] = { ["v1"] = ,["v2"] = ,["v3"] = ,["v4"] = ,["v5"] = ,} ,["desc2"] = { ["v1"] = ,["v2"] = ,["v3"] = ,["v4"] = ,["v5"] = ,} ,["desc3"] = { ["v1"] = ,["v2"] = ,["v3"] = ,["v4"] = ,["v5"] = ,} ,} ,} ,["tier"] = ,["xnpc"] = , } '
local sgzDump = '{ ["aenu"] = Ally,["ag"] = +23,["aliases"] = USS Stargazer,["ar"] = +27,["aw"] = +23,["cargo"] = { ["crewamt"] = 2,["crmax"] = 8,["crmin"] = 0,["crtyp"] = tbd = any, universal, federation, klingon, romulan,["weaponamt"] = 2,["wpmax"] = 8,["wpmin"] = 0,["wptyp"] = {{ina}},} ,["cargoUpgrades"] = { ["cupgr1"] = { ["crewamt"] = 2,["currentlevel"] = 65,["weaponamt"] = 3,} ,["cupgr2"] = { ["crewamt"] = 3,["currentlevel"] = 70,["weaponamt"] = 3,} ,["cupgr3"] = { ["crewamt"] = 3,["currentlevel"] = 90,["weaponamt"] = 4,} ,["cupgr4"] = { ["crewamt"] = 4,["currentlevel"] = 95,["weaponamt"] = 4,} ,["cupgr5"] = { ["crewamt"] = 4,["currentlevel"] = 101,["weaponamt"] = 5,} ,["cupgr6"] = { ["crewamt"] = 5,["currentlevel"] = 102,["weaponamt"] = 5,} ,["cupgr7"] = { ["crewamt"] = 5,["currentlevel"] = 111,["weaponamt"] = 6,} ,["cupgr8"] = { ["crewamt"] = 6,["currentlevel"] = 122,["weaponamt"] = 6,} ,["cupgr9"] = { ["crewamt"] = 6,["currentlevel"] = 133,["weaponamt"] = 7,} ,["cupgrx"] = { ["crewamt"] = 7,["currentlevel"] = 144,["weaponamt"] = 7,} ,["cupgry"] = { ["crewamt"] = 7,["currentlevel"] = 155,["weaponamt"] = 8,} ,["cupgrz"] = { ["crewamt"] = 8,["currentlevel"] = 165,["weaponamt"] = 8,} ,} ,["currentlevel"] = 40,["govt"] = [[Federation]],["hp"] = 1228,["igp"] = stargazer,["image"] = Stargazer.png,["imagecaption"] = USS Stargazer,["limit"] = 165,["lmax"] = 42,["lmin"] = 40,["name"] = [[Stargazer]],["nup"] = 15,["othersUpgrades"] = { ["up03"] = { ["ag"] = +28,["ar"] = +32,["aw"] = +28,["currentlevel"] = 50,["hp"] = 1518,["skillschosen"] = 2o1y0b,} ,["up09"] = { ["ag"] = +51,["ar"] = +59,["aw"] = +51,["currentlevel"] = 96,["hp"] = 2852,["skillschosen"] = 3o4y2b,} ,["up15XXX"] = { ["ag"] = +35,["ar"] = +35,["aw"] = +35,["currentlevel"] = 165,["hp"] = 3500,["skillschosen"] = 5o5y5b,} ,} ,["sdate"] = 2015-01-01,["series"] = TNG,["skills"] = { ["color1"] = Orange,["color2"] = Yellow,["color3"] = Blue,["cost1"] = 9,["cost2"] = passive,["cost3"] = 7,["desc1"] = { ["t1"] = Changes ,["t2"] = blue gems to strike. Does ,["t3"] = damage for each orange gem that the team has. Max ,["t4"] = .,["v1"] = 2,["v2"] = 32,["v3"] = 170,} ,["desc2"] = { ["t1"] = If you have less than ,["t2"] = % life remaining, each strike will cause a damage of ,["t3"] = , for each yellow gem on the board. Max ,["t4"] = .,["v1"] = 10,["v2"] = 17,["v3"] = 170,} ,["desc3"] = { ["t1"] = Repairs the shield by ,["t2"] = and adds ,["t3"] = defensive gems that protext ,["t4"] = life during each turn.,["v1"] = 50,["v2"] = 2,["v3"] = 18,} ,["skill1"] = Constellation Class,["skill2"] = Picard Maneuver,["skill3"] = Skirmish,} ,["skillsUpgrades"] = { ["supgr2"] = { ["desc1"] = { ["v1"] = 3,["v2"] = 48,["v3"] = 250,} ,["desc2"] = { ["v2"] = 21,["v3"] = 210,} ,["desc3"] = { ["v1"] = 70,["v3"] = 24,} ,} ,["supgr3"] = { ["desc1"] = { ["v1"] = 3,["v2"] = 55,["v3"] = 300,} ,["desc2"] = { ["v2"] = 29,["v3"] = 290,} ,["desc3"] = { ["v1"] = 86,["v3"] = 36,} ,} ,["supgr4"] = { ["desc1"] = { ["v1"] = 4,["v2"] = 68,["v3"] = 360,} ,["desc2"] = { ["v2"] = 37,["v3"] = 370,} ,["desc3"] = { ["v1"] = 108,["v3"] = 44,} ,} ,["supgr5"] = { ["desc1"] = { ["v1"] = 5,["v2"] = 78,["v3"] = 420,} ,["desc2"] = { ["v2"] = 41,["v3"] = 410,} ,["desc3"] = { ["v1"] = 122,["v3"] = 50,} ,} ,} ,["tier"] = 3,["xnpc"] = yes,} '
    
function p:test_oddmains()
    self:preprocess_equals('{{#invoke:Starshipcodes | main }}', ans4)
--    self:preprocess_equals('{{#invoke:Starshipcodes | main }}', 'tbd...')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | ZZZZ | SGZ }}', ans1..ans3..'[2] = ZZZZ,[3] = SGZ,} ')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | STUPID }}', 'tbd...')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | blank }}', 'tbd...')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | blank | SGZ }}', ans1..ans3..'[2] = blank,[3] = SGZ,} ')
end

--[[

local skill_j1 = '{"cost3":7,"cost1":9,"skill2":"Picard Maneuver","color1":"Orange","color2":"Yellow","cost2":"passive","desc1":{"t2":" blue gems to strike. Does ","v1":2,"v2":32,"t1":"Changes ","t3":" damage for each orange gem that the team has. Max ","v3":170,"t4":"."},"desc2":{"t2":"% life remaining, each strike will cause a damage of ","v1":10,"v2":17,"t1":"If you have less than ","t3":", for each yellow gem on the board. Max ","v3":170,"t4":"."},"skill1":"Constellation Class","desc3":{"t2":" and adds ","v1":50,"v2":2,"t1":"Repairs the shield by ","t3":" defensive gems that protext ","v3":18,"t4":" life during each turn."},"color3":"Blue","skill3":"Skirmish"}'


function p:test_skills()
--    self:preprocess_equals('{{#invoke:Starshipcodes | skills | XXX }}', 'skills-fail...')
    self:preprocess_equals('{{#invoke:Starshipcodes | skills | XXX }}', 'false')
--    self:preprocess_equals('{{#invoke:Starshipcodes | skills | SGZ }}', 'JSON-encoded-data')
    self:preprocess_equals(mw.text.killMarkers('{{#invoke:Starshipcodes | skills | SGZ }}'), mw.text.killMarkers(skill_j1))
end

function p:test_TBLs_all()
    self:preprocess_equals('{{#invoke:Starshipcodes | showTBLs | XXX }}', 'showTBLs-fail...')
    self:preprocess_equals('{{#invoke:Starshipcodes | showTBLs | SGZ }}', 'JSON-encoded-data')
end
--]]

function p:test_singlemains()
    self:preprocess_equals('{{#invoke:Starshipcodes | main | n | SGZ }}', '[[Stargazer]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | name | SGZ }}', '[[Stargazer]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | hp | SGZ }}', '1228')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | i | SGZ }}', 'Stargazer.png')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | icon | SGZ }}', 'Stargazer.png')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | image | SGZ }}', 'Stargazer.png')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | s | SGZ }}', 'TNG')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | series | SGZ }}', 'TNG')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | t | SGZ }}', '3')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | tier | SGZ }}', '3')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | g | SGZ }}', '[[Federation]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | govt | SGZ }}', '[[Federation]]')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | aliases | SGZ }}', 'USS Stargazer')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | igp | SGZ }}', 'stargazer')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | xnpc | SGZ }}', 'yes')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | sdate | SGZ }}', '2015-01-01')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | aenu | SGZ }}', 'Ally')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | lmin | SGZ }}', '40')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | lmax | SGZ }}', '42')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | limit | SGZ }}', '165')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | nup | SGZ }}', '15')
--    self:preprocess_equals('{{#invoke:Starshipcodes | main | skills | SGZ }}', '???')
--    self:preprocess_equals('{{#invoke:Starshipcodes | main | skill1 | SGZ }}', '???')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | ar | SGZ }}', '+27')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | ag | SGZ }}', '+23')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | aw | SGZ }}', '+23')
--    self:preprocess_equals('{{#invoke:Starshipcodes | main | cargo | SGZ }}', '???')
--    self:preprocess_equals('{{#invoke:Starshipcodes | main | crewamt | SGZ }}', '???')
    self:preprocess_equals('{{#invoke:Starshipcodes | main | currentlevel | SGZ }}', '40')
--    self:preprocess_equals('{{#invoke:Starshipcodes | main | skillsUpgrades | SGZ }}', '???')
--    self:preprocess_equals('{{#invoke:Starshipcodes | main | supgr2 | SGZ }}', '???')
--    self:preprocess_equals('{{#invoke:Starshipcodes | main | othersUpgrades | SGZ }}', '???')
--    self:preprocess_equals('{{#invoke:Starshipcodes | main | cargoUpgrades | SGZ }}', '???')
end

local fullSGZ = '{ ["aenu"] = Ally,["ag"] = +23,'


function p:test_fulls()
--    self:preprocess_equals('{{#invoke:Starshipcodes | main | full | SGZ }}', fullSGZ)
--    self:preprocess_equals('{{#invoke:Starshipcodes | skills | SGZ }}', '[[Stargazer]]')
-- --    self:preprocess_equals('{{#invoke:Starshipcodes | main | blank | SGZ }}', blnkDump)
--    self:preprocess_equals(mw.text.killMarkers('{{#invoke:Starshipcodes | main | full | SGZ }}'), mw.text.killMarkers(sgzDump))
-- --    self:preprocess_equals('{{#invoke:Starshipcodes | main | dumpGLBL | SGZ }}', 'TEST-dumpGLBL')
end

local STARSHIPBLANK = {
		name = ' ',
		aliases = ' ',
		image = ' ',
		imagecaption = ' ',
		igp = ' ',
		tier = ' ',
		series = ' ',
		govt = ' ',
		xnpc = ' ',
		sdate = ' ',
		aenu = ' ',
		lmin = ' ',
		lmax = ' ',
		limit = ' ',
		hp = ' ',
		nup = ' ',
		skills = {
    		skill1 = ' ',
	    	color1 = ' ',
		    cost1 = ' ',
    		desc1 = { t1 = ' ', v1 = ' ', t2 = ' ', v2 = ' ', 
    		        t3 = ' ', v3 = ' ', t4 = ' ', v4 = ' ',
                    t5 = ' ', v5 = ' ', t6 = ' ', },
    		skill2 = ' ',
	    	color2 = ' ',
		    cost2 = ' ',
    		desc2 = { t1 = ' ', v1 = ' ', t2 = ' ', v2 = ' ', 
    		        t3 = ' ', v3 = ' ', t4 = ' ', v4 = ' ',
                    t5 = ' ', v5 = ' ', t6 = ' ', },
    		skill3 = ' ',
	    	color3 = ' ',
		    cost3 = ' ',
    		desc3 = { t1 = ' ', v1 = ' ', t2 = ' ', v2 = ' ', 
    		        t3 = ' ', v3 = ' ', t4 = ' ', v4 = ' ',
                    t5 = ' ', v5 = ' ', t6 = ' ', },
		},
		ar = ' ',
		ag = ' ',
		aw = ' ',
		cargo = { 
		    crewamt = ' ',
		    crmin = ' ',
		    crmax = ' ',
		    crtyp = ' ',
		    weaponamt = ' ',
		    wpmin = ' ',
		    wpmax = ' ',
		    wptyp = ' ',
		},
		currentlevel = ' ',
		skillsUpgrades = {
		    supgr2 = { 
		        cost1 = ' ', cost2 = ' ', cost3 = ' ', 
		      desc1 = { v1 = ' ', v2 = ' ', v3 = ' ', v4 = ' ', v5 = ' ', },
		      desc2 = { v1 = ' ', v2 = ' ', v3 = ' ', v4 = ' ', v5 = ' ', },
		      desc3 = { v1 = ' ', v2 = ' ', v3 = ' ', v4 = ' ', v5 = ' ', },
		      },
		    supgr3 = { 
		        cost1 = ' ', cost2 = ' ', cost3 = ' ', 
		      desc1 = { v1 = ' ', v2 = ' ', v3 = ' ', v4 = ' ', v5 = ' ', },
		      desc2 = { v1 = ' ', v2 = ' ', v3 = ' ', v4 = ' ', v5 = ' ', },
		      desc3 = { v1 = ' ', v2 = ' ', v3 = ' ', v4 = ' ', v5 = ' ', },
		      },
		    supgr4 = { 
		        cost1 = ' ', cost2 = ' ', cost3 = ' ', 
		      desc1 = { v1 = ' ', v2 = ' ', v3 = ' ', v4 = ' ', v5 = ' ', },
		      desc2 = { v1 = ' ', v2 = ' ', v3 = ' ', v4 = ' ', v5 = ' ', },
		      desc3 = { v1 = ' ', v2 = ' ', v3 = ' ', v4 = ' ', v5 = ' ', },
		      },
		    supgr5 = { 
		        cost1 = ' ', cost2 = ' ', cost3 = ' ', 
		      desc1 = { v1 = ' ', v2 = ' ', v3 = ' ', v4 = ' ', v5 = ' ', },
		      desc2 = { v1 = ' ', v2 = ' ', v3 = ' ', v4 = ' ', v5 = ' ', },
		      desc3 = { v1 = ' ', v2 = ' ', v3 = ' ', v4 = ' ', v5 = ' ', },
		      },
		},
		othersUpgrades = {
		    up03 = { currentlevel = 50, skillschosen = '1o1y1b',
                        -- tier-3/4 matching tier-1-max
		            hp = ' ', ar = ' ', ag = ' ', aw = ' ',
		      },
		    up09 = { currentlevel = 96, skillschosen = '3o3y3b',
                        -- tier-3/4 almost-matching tier-2-max
		            hp = ' ', ar = ' ', ag = ' ', aw = ' ',
		      },
		    up10 = { currentlevel = 50, skillschosen = '5o5y0b',
                        -- tier-1-max
                        -- tier-2 matching tier-1-max
		            hp = ' ', ar = ' ', ag = ' ', aw = ' ',
		      },
		    up15 = { currentlevel = 95, skillschosen = '5o5y5b',
                        -- tier-2-max
                        -- tier-3/4-max is lvl-165
		            hp = ' ', ar = ' ', ag = ' ', aw = ' ',
		      },
		},
		cargoUpgrades = {
		    cupgr1 = { currentlevel = ' ', crewamt = ' ', weaponamt = ' ', },
		    cupgr2 = { currentlevel = ' ', crewamt = ' ', weaponamt = ' ', },
		    cupgr3 = { currentlevel = ' ', crewamt = ' ', weaponamt = ' ', },
		    cupgr4 = { currentlevel = ' ', crewamt = ' ', weaponamt = ' ', },
		    cupgr5 = { currentlevel = ' ', crewamt = ' ', weaponamt = ' ', },
		    cupgr6 = { currentlevel = ' ', crewamt = ' ', weaponamt = ' ', },
		    cupgr7 = { currentlevel = ' ', crewamt = ' ', weaponamt = ' ', },
		    cupgr8 = { currentlevel = ' ', crewamt = ' ', weaponamt = ' ', },
		    cupgr9 = { currentlevel = ' ', crewamt = ' ', weaponamt = ' ', },
		    cupgr10 = { currentlevel = ' ', crewamt = ' ', weaponamt = ' ', },
		    cupgr11 = { currentlevel = ' ', crewamt = ' ', weaponamt = ' ', },
		    cupgr12 = { currentlevel = ' ', crewamt = ' ', weaponamt = ' ', },
		    cupgr13 = { currentlevel = ' ', crewamt = ' ', weaponamt = ' ', },
		    cupgr14 = { currentlevel = ' ', crewamt = ' ', weaponamt = ' ', },
		    cupgr15 = { currentlevel = ' ', crewamt = ' ', weaponamt = ' ', },
		    cupgr16 = { currentlevel = ' ', crewamt = ' ', weaponamt = ' ', },
	    },
}


return p

