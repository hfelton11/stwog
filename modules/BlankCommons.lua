local p = {}

local getargs = getargs or require('Dev:Arguments').getArgs
local glbls = glbls or require('Module:Globals')
local gems = gems or require('Module:Gems')
local utils = utils or require('Module:Utilities')

--glbls.args = {}

local function checkSorC(str)
	-- klugey, but...
	local retval = false
	local retstr = 'x'
	if type(str)=='string' then
		if string.len(str)==1 then
			retstr = string.lower(str)
		end
		if retstr=='c' or retstr=='s' then
			retval = true
		end
	end
	return retval,retstr
end



local CHARACTERBLANK = {
        name = ' ',
		aliases = ' ',
		image = ' ',
		imagecaption = ' ',
		igp = ' ',
		tier = ' ',
		series = ' ',
		race = ' ',
		gender = ' ',
		xnpc = ' ',
		sdate = ' ',
		aenu = ' ',
		govt = ' ',
		lmin = ' ',
		lmax = ' ',
		limit = ' ',
		hp = ' ',
		nup = ' ',
		skills = {
    		skill1 = ' ',
	    	color1 = ' ',
		    cost1 = ' ',
    		desc1 = { t1 = ' ', v1 = ' ', t2 = ' ', v2 = ' ', t3 = ' ', v3 = ' ', t4 = ' ', v4 = ' ', t5 = ' ', v5 = ' ', t6 = ' ', },
    		skill2 = ' ',
	    	color2 = ' ',
		    cost2 = ' ',
    		desc2 = { t1 = ' ', v1 = ' ', t2 = ' ', v2 = ' ', t3 = ' ', v3 = ' ', t4 = ' ', v4 = ' ', t5 = ' ', v5 = ' ', t6 = ' ', },
    		skill3 = ' ',
	    	color3 = ' ',
		    cost3 = ' ',
    		desc3 = { t1 = ' ', v1 = ' ', t2 = ' ', v2 = ' ', t3 = ' ', v3 = ' ', t4 = ' ', v4 = ' ', t5 = ' ', v5 = ' ', t6 = ' ', },
		},
		ag = ' ',
		ar = ' ',
		aw = ' ',
		gorder = ' ',
		datavalues = {  dv1 = ' ', dv2 = ' ', dv3 = ' ',
		                dv4 = ' ', dv5 = ' ', dv6 = ' ', },
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
		    up03 = { currentlevel = 50, skillschosen = '1r1w1b',
                        -- tier-3/4 matching tier-1-max
		            hp = ' ', ar = ' ', ag = ' ', aw = ' ',
                    gorder = 'RWBOYP',
                    datavalues = {  dv1 = ' ', dv2 = ' ', dv3 = ' ',
                                    dv4 = ' ', dv5 = ' ', dv6 = ' ', },
		      },
		    up09 = { currentlevel = 96, skillschosen = '3r3w3b',
                        -- tier-3/4 almost-matching tier-2-max
		            hp = ' ', ar = ' ', ag = ' ', aw = ' ',
                    gorder = 'RWBOYP',
                    datavalues = {  dv1 = ' ', dv2 = ' ', dv3 = ' ',
                                    dv4 = ' ', dv5 = ' ', dv6 = ' ', },

		      },
		    up10 = { currentlevel = 50, skillschosen = '5r5w0b',
                        -- tier-1-max
                        -- tier-2 matching tier-1-max
		            hp = ' ', ar = ' ', ag = ' ', aw = ' ',
                    gorder = 'RWBOYP',
                    datavalues = {  dv1 = ' ', dv2 = ' ', dv3 = ' ',
                                    dv4 = ' ', dv5 = ' ', dv6 = ' ', },

		      },
		    up15 = { currentlevel = 95, skillschosen = '5r5w5b',
                        -- tier-2-max
                        -- tier-3/4-max is lvl-165
		            hp = ' ', ar = ' ', ag = ' ', aw = ' ',
                    gorder = 'RWBOYP',
                    datavalues = {  dv1 = ' ', dv2 = ' ', dv3 = ' ',
                                    dv4 = ' ', dv5 = ' ', dv6 = ' ', },
		      },
        },
}

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

function p._main(frame)
    -- this cleans up outside (or INside) calls for args
    local a
    a = utils.tableShallowCopy(getargs(frame))
    if #a == 0 then return false end
    glbls.args = a
    return true
end

function p.main(frame)
    local retval = 'invalid call to BlankCommons-main: '
    local a,sorc,mKey,mItem
    local ok,tempStr,ok2
    local blnkItem = {}
    if not p._main(frame) then
        retval = retval..'zero arguments passed'
        return retval
    end

	a = glbls.args
	sorc = a[1]
	mKey = a[2]
	mItem = a[3]

	ok,tempStr = checkSorC(sorc)
	if ok then
		glbls.sorc = tempStr
		glbls.args[1] = tempStr  -- bypass REchecking later...
	else
		return 'invalid sorc-value >>'..tostring(sorc)..'<<'
	end

	--ok = utils.isSimple(mKey)
	ok = mKey and not utils.isSimpleBlank(mKey)
	if ok then
		ok2,tempStr = utils.isWikiLink(mKey)
		if ok2 then
			glbls.key = tempStr
		else
			glbls.key = mKey
		end
		if glbls.sorc == 'c' then
			blnkItem = p.crew()
		elseif glbls.sorc == 's' then
			blnkItem = p.ship()
		else
		end
	end

	retval = utils.dumpTable(glbls)
	retval = retval..'\n\n'..utils.dumpTable(blnkItem)
	return retval

end

function p.ship() return STARSHIPBLANK end
function p.crew() return CHARACTERBLANK end

return p

