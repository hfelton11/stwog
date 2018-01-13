-- Module:ParsePN
-- inside: [[Category:Modules]] using this line once...

-- <pre>

local p={}

local getargs = getargs or require('Dev:Arguments').getArgs
local utils = utils or require('Module:Utilities')
local glbls = glbls or require('Module:Globals')
local comns = comns or require('Module:CommonCodes')
local crews = crews or require('Module:Charactercodes')
local ships = ships or require('Module:Starshipcodes')
glbls.sorc = 'x'
glbls.key = ''
glbls.link = ''
glbls.level = 0
glbls.tier = 0
glbls.upgr = ''

-- klugey, but workable...
local namedUpgrades = { 'def','def','def',		'up10','up10', 'up03',
						'up15','up09', 			'up15', }
local validLevels = { 1, 10, 40, 	50, 50, 50, 	95, 96, 	165, }
local maxLevels = { 50, 95, 165, }
local validTiers = { 1, 2, 3, 		1, 2, 3, 		2, 3, 		3, }

function p._main(frame)
    -- this cleans up outside calls
    local a
    a = utils.tableShallowCopy(getargs(frame))
    if #a == 0 then
        return false
    else
        glbls.args = a
        return true
    end
end

local function passSorC(sorc)
    local fake = {}
    local retval = ''
    local check
    fake[1] = sorc
    if comns.passGLBLsorc(fake) then
        -- will not pass-up the GLBLs ftom below,
        -- but do hand-code of solution-wanted...
        retval = "it worked ? sorta..."
        glbls.sorc = string.upper(string.sub(sorc,1,1))
    end
    check = glbls.sorc
    return retval..check
end

local function getKey(sorc,key)
    local fake = {}
    local retval = ''
    local check
    fake[1] = sorc
    fake[2] = key
    check = comns.makeIGPTfromKey(fake)
    if check then
        retval = "it worked ... "
        glbls.key = key
    else
        check = ''
    end
    return retval..check
end

local function mkLnkKey(sorc,key)
    local fake = {}
    local retval = ''
    local check
    fake[1] = sorc
    fake[2] = key
    check = comns.isGoodKey(fake)
    if check then
    	retval = comns.getNamefromKey(fake)
    else
    	retval = '.'
    end
    return retval
end

local function getTier(sorc,key)
    local fake = {}
    local retval = ''
    local isOK = false
    local check,tempval,numTier
    fake[1] = sorc
    fake[2] = key
    fake[3] = 'tier'
    check = comns.isGoodKey(fake)
    if check then
		tempval = comns.getItemfromKey(fake)
		numTier = utils.toNum(tempval)
		if numTier > 0 and numTier < 4 then  -- ick, hardcoded...
			retval = 'it worked... tier='
			isOK = true
			-- hack for 3.5 tier
			if numTier == 3.5 then numTier = 3 end
		end
		retval = retval..numTier
	else
		retval = 'noTiernoKey'
    end
	-- make horrible, but necessary ? assumption for later...
		if not isOK then numTier = 1 end
		glbls.tier = numTier
    return retval
end

local function mkLvlInfoBox(sorc,key,level)
    local fake = {}
    local retval = ''
    local check
    fake[1] = sorc
    fake[2] = key
    fake[3] = level
--    check = crews.doLevelInfoBox(fake)
    if check then
        retval = comns.getNamefromKey(fake)
    else
        retval = '.'
    end
    return 'mkLvlInfoBox...'..retval
end

local function checkPNok(tbl)
    -- this just check for 2 or 3 pieces in name...
	local isOK = false
	local retval = ''
    assert(type(tbl)=='table')
    if #tbl == 1 then
    	retval = retval .. 'no slashes found in arg-1'
    	return isOK,retval
    end
    -- next two are either Level/Key or just-Key
    if #tbl > 3 then
    	retval = retval .. 'too many slashes found in arg-1'
    	return isOK,retval
    end
    -- at this point...
    isOK = true
	retval = retval .. utils.dumpTable(tbl)
	return isOK,retval
end


local function checkPNkey(tbl)
    -- this checks first/last pieces in name...
	local hasSorC,hasKey,isOK = false,false,false
	local retval = 'ckPNkey: '
    assert(type(tbl)=='table')
    -- first is starship or character...
	sorc = tostring(tbl[1])
	-- Key is always LAST...
	key = tostring(tbl[#tbl])
	retval = retval..' sorc='..sorc
	-- side effect of passSorC() fills in glbls.sorc
	retval = retval..' PASSsorc='..passSorC(sorc)
	if glbls.sorc=='S' or glbls.sorc=='C' then
		hasSorC = true
	end
	retval = retval..' key='..key
	--retval = ' key='..key
	-- side effect of getKey() fills in glbls.key
	retval = retval..' GETkey='..getKey(sorc,key)
	if not utils.isBlank(glbls.key) then
		hasKey = true
	end
    -- at this point...
    if hasSorC and hasKey then
    	isOK = true
    end
	-- side effect of getTier() fills in glbls.tier
	retval = retval..' GETtier='..getTier(sorc,key)
	--retval = ' GETtier='..getTier(sorc,key)
	tempstr = mkLnkKey(sorc,key)
	glbls.link = tempstr
	retval = retval..' MkLnkKey='..tempstr
	--retval = ' MkLnkKey='..tempstr
	-- retval = retval .. utils.dumpTable(tbl)
	return isOK,retval
end



local function getUpgr()
	-- find magic-upgrade-string, using globals
	local gotit = false
	local ii,ij,ik
	local curval
	ii = glbls.tier
	curval = glbls.level
		-- magic math checking for 'perfect' level-template items...
		for i,v in ipairs(validTiers) do
			if v-ii == 0 then
				ij = validLevels[i]
				if curval-ij == 0 then
					gotit = true
					ik = i
				end
			end
		end
	-- at this point, resolve-inland-call...
	if gotit then glbls.upgr = namedUpgrades[ik] end
	return gotit
end




local function checkPNvalid(tbl)
    -- this assumes that checkPNok completed...
    -- this assumes that checkPNkey completed...
	local hasLevel = true   -- for 2-items...
	local isValid = false
	local retval = ' ckPNvalid: '
	local tempstr, ok, begLv, endLv
	local level = tbl[2]
	local ell,found,xtra
	local bad1,gd2,gd3,bad4 = false,false,false,false
    assert(type(tbl)=='table')
    assert(#tbl>=2)
    assert(#tbl<=3)
    -- VALID path-split example: CO/L50/DE
    -- VALID path-split example: CO/DE
    -- CO means character (tos)
    -- L50 means need level-50 information
    -- DE means key into character-data...
    -- values T1=1, T2=10, T3=40
    begLv = validLevels[glbls.tier]
    -- values T1=50, T2=95, T3=165
    endLv = maxLevels[glbls.tier]
	if #tbl == 2 then
		glbls.level = begLv
		isValid = true
		retval = retval..' defLvl='..glbls.level
		return isValid,retval
	else
		hasLevel = false
	end
	-- BEGIN longer checks on middle-item...
	ell,found,xtra = string.match(level,'(%D*)(%d+)(.*)')
	if ell then retval = retval ..'ell:'..utils.dumpTable(ell) end
	if found then retval = retval ..'found:'..utils.dumpTable(found) end
	if xtra then retval = retval ..'xtra:'..utils.dumpTable(xtra) end
--	return true,retval
	if ell and (#ell > 1) then bad1 = true end
	-- HARSH check on 'L' character...
	if not string.match(ell, '[lL]') then bad1 = true end
	if xtra and (#xtra > 0) then bad4 = true end
	if found then
		gd2 = true
		chkval = utils.toNum(found)
		if (chkval >= begLv) and (chkval <= endLv) then
			gd3 = true
		end
	end
	ok = true
	if bad1 or bad4 then
		retval = retval..'typo? >>'..level..'<<'
		ok = false
	end
	if not gd2 then
		retval = retval..'NOfinds? '
		ok = false
	end
	if not gd3 then
		retval = retval..'choice?='..found..'? '
		ok = false
	end
	if ok then
		isValid = true
		glbls.level = chkval
		retval = ' ckPNvalid:lvl='..glbls.level
	end
	return isValid,retval
end

--[[

--]]

local function doSlash(args)
    local retval = 'doSlash: '
    local tbl,ok,tempstr,argstr2
    assert(type(args)=='table')
    tbl = mw.text.split( tostring(args[1]), "/" )
	if #args == 2 then
	    argstr2 = string.lower(args[2])
	    -- check the parsing details...
    	ok,tempstr = checkPNok(tbl)
    	retval = retval .. tempstr
    	-- each return+retval is like a 'break' in the checks...
    	if not ok then
    		return retval
    	end
	else -- #args <> 2
		retval = 'doSlash: args .ne. 2 ...'
		return retval
	end
	retval = retval..'args:'..utils.dumpTable(args)
	--retval = 'args:'..utils.dumpTable(args)
	if argstr2=='isok' then
		retval = 'ok args'
		return retval
	end
	-- so far, args==2 and isOK
    -- check the key...
	ok,tempstr = checkPNkey(tbl)
	retval = retval .. tempstr
	--retval = tempstr
    if not ok then
    	return retval
    end
	if argstr2=='getlink' and (#glbls.link > 1) then
		retval = glbls.link
		return retval
	end
	-- so far, isOK and gdKey
	-- check for valid level...
    ok,tempstr = checkPNvalid(tbl)
    retval = retval .. tempstr
    if not ok then
		--return tempstr
		--retval = 'doSlash: NOT valid level...'
		return retval
    end
	if argstr2=='isvalid' and (utils.toNum(glbls.level) > 0) then
		retval = 'valid Lvl-'..glbls.level
		return retval
	end
	-- so far, good-thru-level value
	-- pickup the upgrade-string...
	if argstr2=='getupgr' then
		if getUpgr() then
			retval = 'mk-'..glbls.upgr
		else
			retval = 'NOT an upgrade-level...'
		end
		return retval
	end
	-- nothing else to do ???
	retval = 'DEBUG-uses only ... '..retval
	--
	return retval
end

local function TESTdoSlash(args)
    -- ALTERNATIVE would be to use utils.split_path()
    -- arg1 is input string
    -- arg2 is which piece to get...
    local tbl,tempval,tempstr
    local retstr = 'doSlash-tbd'
    -- i have no idea why these ENFORCED tonumber/tostring call reqd...
--    retval = retval .. utils.dumpTable(a)
--    tbl = mw.text.split( "this is a test", " " )
    tbl = mw.text.split( tostring(args[1]), "/" )
--    tbl = mw.text.split( tostring(a[1]), "\\" )
--    retval = retval .. utils.dumpTable(tbl)
--    tempval = utils.tonumber(a[2])
    tempval = utils.toNum(args[2])
--    retval = retval .. tempval .. tostring(tbl[tempval])
    retval = tostring(tbl[tempval])
    tempstr = tbl[tempval]
--    retval = tostring(utils.errBlank(tempstr,">><<"))
--    retval = tostring(utils.errBlank(tempstr,"Err><"))
    retval = tostring(utils.errBlank(tempstr))
        return retval
--    return retstr
end

function p.slash(frame)
	-- purpose: Parse the PAGENAME for slashes
	-- 		typical case: CO/L50/CK or SN/L165/SGZ
	--
    local retval = 'invalid call to ParsePN-slash: '
    local a,tbl,tempval,tempstr
    if not p._main(frame) then
        retval = retval..'zero arguments passed'
        return retval
    end
    a = glbls.args
    return doSlash(a)
end


return p

