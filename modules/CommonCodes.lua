-- commoncodes module
-- inside: [[Category:Modules]] using this line once...
-- has common functions that will operate on/about starships/characters

-- BEWARE: these functions do not work well with testcases because
--          they do not take frame's for arguments usually...
-- HOWEVER: they need to copy-out their passed-in-args anyways because
--          otherwise nothing works as it should...  sigh...

-- <pre>

local p = {}
local getargs = getargs or require('Dev:Arguments').getArgs
local utils = utils or require('Module:Utilities')
local glbls = glbls or require('Module:Globals')
local blnks = blnks or require('Module:BlankCommons')

glbls.sorc = 'x'
glbls.typenameS = 'Module:Starshipcodes/'
glbls.typenameC = 'Module:Charactercodes/'
glbls.filename = 'data'
glbls.keysLoaded = false
glbls.keys = {}
glbls.data = {}
glbls.holdtbl = {}
glbls.frame0 = nil
glbls.args = {'junk',}
glbls.character = 'crewch'
glbls.starship = 'starsh'
glbls.dumpGLBL = 'TEST-dumpGLBL'
glbls.useMixedCaseKeys = false

function p.hello()
    return 'Hello, world!'
end

function p.passGLBLsorc(frame)
    local fakeframe = {}
    local a,retval,retstr,teststr,teston
    fakeframe[1] = 'sorc'
    a = utils.tableShallowCopy(getargs(frame))
    -- extra args just ignored !!!
    fakeframe[2] = a[1]
    -- forward-call works because p. is already-declared...
    -- change/restore REAL frame ASAP
    glbls.frame0 = utils.tableShallowCopy(frame)
    retstr = p.passGLBL(fakeframe)
    frame = utils.tableShallowCopy(glbls.frame0)
    -- incongruous, but glbls.args get reset inside _main()
    glbls.args = utils.tableShallowCopy(a)
    -- error-checking for valid 's'-or-'c' argument...
    retval = false
    -- so many ways to do this test...
    -- v.4 length check !!!!!
    if string.len(glbls.sorc) > 2 then return false end
    if string.len(glbls.sorc) == 1 then
        -- v.1
        if utils.stringEnds(retstr,'s') then return true end
        if utils.stringEnds(retstr,'c') then return true end
    	-- v.2 (upper/lowercase ending-only)  -- retstr[#retstr]
        teststr = string.lower(string.sub(retstr,-1))
        if teststr=='s' or teststr=='c' then
    		glbls.sorc = teststr
    		return true
    	end
    end
	-- v.3 (filename-expansion allows SO,SN,CO,CN values)
    teststr = string.lower(string.sub(retstr,-2))
    teston = string.lower(string.sub(teststr,-1))
    if teston=='o' or teston=='n' then
        local finalsorc = string.sub(teststr,1,1)
        if finalsorc=='s' or finalsorc=='c' then
	    	glbls.sorc = finalsorc
		    return true
	    end
	end
    return retval
end

function p.passGLBL(frame)
    local what,whatval,a
    local retval = false
    if not p._main(frame) then return retval end
    a = glbls.args
    if #a ~= 2 then return retval end
-- no other error checks here...
    what = a[1]
    whatval = a[2]
    glbls[what] = whatval
    retval = 'glbls.'..what..'='..whatval
--    retval = true
    return retval
end

local function isGoodKey(k)
    local allKeys,found
    if k==nil then return false end
    if not glbls.keysLoaded then return false end
        found = false
    if glbls.data[k] then
		if glbls.useMixedCaseKeys then
			found = true
		elseif string.upper(k)==k then
			found = true
		else
			found = false
		end
    end
--    found = #glbls.keys
    return found
end
local function isGoodSkill(k,sknum)
    local retval = false
    if not isGoodKey(k) then return retval end
    if (sknum == nil) or (sknum < 1) then return retval end
    if sknum > 3 then return retval end
    local chose = 'desc'..sknum
    local chkTbl = glbls.data[k]['skills']
    if not chkTbl then return retval end
    -- at this point, lets save some effort later...
    glbls.holdtbl = utils.tableShallowCopy(chkTbl)
    -- this assumes the input-data has a 't1' beginning...
    local chkTV = chkTbl[chose]
    if not chkTV['t1'] then return retval end
    -- at this point, it should be good...
    retval = true
    return retval
end

function mkOKitems(sorc)
    local items = {},chkr
    if not sorc then sorc = glbls.sorc end
    if sorc == 's' then
        chkr = blnks.ship()
    elseif sorc == 'c' then
        chkr = blnks.crew()
    else -- only assumption...
        chkr = { name='', ignore={}, }
    end
    for k,v in pairs(chkr) do
        if utils.isSimple(v) then
            --items[#items+1]=k
            items[k]=k
        end
    end
    return items
end
function getFullKey(key)
    if isGoodKey(key) then
        return glbls.data[key]
    else
        -- never hits here ...
        return 'really nothing found'
    end
end
local function getTablefromKey(key,item)
    -- assumes prechecks already done...
    local retval
    if isGoodKey(key) then
        if not item then
            retval = 'NO-ITEM?...'
            retval = glbls.data[key].name
        else
            local tempval = glbls.data[key][item]
            if type(tempval) == 'table' then
                local enc = utils.JSONencodeTable2String(tempval)
--                retval = 'YEAH!'
--                retval = tempval
                retval = enc
            else
                retval = 'not-a-sub-table...'
            end
        end
--    else
--        retval = 'BAD-KEY?...'
    end
    return retval
end
local function getItemfromKey(key,item)
    -- assumes prechecks already done...
    local retval
    if isGoodKey(key) then
        if not item then
            retval = glbls.data[key].name
--            return glbls.data[key].name
        else
            retval = glbls.data[key][item]
--            return glbls.data[key][item]
        end
    end
    if not retval then retval = 'tbd...' end
    return retval
end
function getNamefromKey(key)
    return getItemfromKey(key)
end
function makeIGPTfromKey(key)
    local igp,tier,igpt
    igp = getItemfromKey(key,'igp')
    tier = getItemfromKey(key,'tier')
    igpt = ''..tostring(igp)..'-'..tostring(tier)
    return igpt
end

-- these are both skills (crew) and features (ship) defaults...
-- and since the assumptions are the same for each, there is no
-- reason to bring this code up-a-level to the crew/ship levels...
-- however, there needs to be a way to bring-the-data-down to
-- get the CORRECT selections for the table (esp the merges), so...
-- TVarr is specifically: #S is skill-#, #L is level-number
-- crew: key-CK, tbl-skills, subtbl-desc#S with merges due to
--               tbl-skillsUpgrades, subtbl-supgr#L and subsubtbl-desc#S
-- ship: exact same tbl-names and uses, just different keys...
local function reduceTV(tbl)
        local descStr = ''
        -- literally assume that t- and v- items alternate and never go above t6...
        local chk = { 't1','v1','t2','v2','t3','v3','t4','v4','t5','v5','t6', }
        for i = 1,#chk do
            local subk, subv = chk[i], tbl[chk[i]]
            if subv ~= nil then descStr = descStr .. subv end
        end
        return descStr
end
local function isGoodSKitem(itm)
    local retval = false
    local poss = { 'skill', 'color', 'cost', 'desc' }
    -- special-case, let 'name' be synonym for 'skill'...
    poss[#poss+1] = 'name'
    if not itm then return retval end
    -- note: skill1 or color3 are NOT valid calls for itm
    -- because we have sknum as separate variable in chooseSK...
    for _,i in ipairs(poss) do
        if itm == i then retval = true end
    end
    return retval
end
local function chooseSKcost(k,sn,sup)
    -- similar to SK2reduceTV, have to reach-down to be sure that costs
    -- havent changed at sub-supgr#L and subsubitem-cost#S
    local retval = 999
    return retval
end
local function chooseSK2reduceTV(k,sn,sup)
    -- just return a table that can be passed into reduceTV...
    local sktbl,skuptbl
    local rettbl = {}
    -- should do checks here to be sure table is kosher before passing...
    rettbl[t1]='t1 is '
    rettbl[v1]=2
    return rettbl
end
local function chooseSK(key,sknum,item,skupg)
    -- basic SKcolor and SKname stay consistent by skill-number only...
    -- complex SKcost and SKdesc need further work on sk-upgrade to return...
    local retstr = ''
    -- should do checks here to be sure selections are ok...
    if isGoodKey(key) then
        -- tables get passed JSON-encoded, which is a bit silly...
        -- so skip/ignore or do-another-way...
        --local sktbl = getTablefromKey(key,'skills')
        local sktbl = glbls.data[key]['skills']
        local subitem = {}
        if isGoodSkill(key,sknum) then
            -- use the passed-global skills-table...
            local curTBL = glbls.holdtbl
            local act
            if isGoodSKitem(item) then
                -- fix special-case...
                if item == 'name' then item = 'skill' end
                -- act has correct-named skill1, cost3, ...
                act = item..sknum
                subitem = curTBL[act]
            else
                retstr = 'nogood skill-item... ['..tostring(item)..']'
            end
            -- at this point subitem holds upgrade-0/1 value/s
            if (not skupg) or (skupg == 0) then skupg = 1 end
            -- assuming integers here...  sigh...
            if skupg ~= math.floor(skupg) then
                retstr = 'skill-upgrade not an integer...'
            end
            if (skupg > 5) or (skupg < 1) then
                retstr = 'skill-upgrade-failed... ['..tostring(skupg)..']'
            else
                -- we will need the upgrade-table now...
                local sups = 'supgr'..skupg
                if skupg > 1 then
                    curTBL = glbls.data[key]['skillsUpgrades'][sups][act]
                end
            end
            -- actually return result if level-1 else fixup upgrades
            if item == 'skill' then
                retstr = subitem
            end
            if item == 'color' then
                retstr = subitem
            end
            if item == 'cost' then
                retstr = subitem
--[[
                retstr = retstr..'cost upg-'..skupg..'\n'
                retstr = retstr..'curtbl='..utils.dumpTable(curTBL)..'\n'
                retstr = retstr..'sbitem='..utils.dumpTable(subitem)
--]]
                if skupg > 1 then
                    -- rather than do merge, just check directly...
                    if curTBL then
                        retstr = curTBL
                    end
                end
            end
            if item == 'desc' then
                retstr = reduceTV(subitem)
--[[
                retstr = retstr..'desc upg-'..skupg..'\n'
                retstr = retstr..'curtbl='..utils.dumpTable(curTBL)..'\n'
                retstr = retstr..'sbitem='..utils.dumpTable(subitem)
--]]
                if skupg > 1 then
                    if curTBL then
                        local mrg = utils.mergeTable(subitem,curTBL)
                        retstr = reduceTV(mrg)
                    end
                end
            end
            if retstr == '' then
                retstr = 'we fell thru without selecting anything...'
            end
        else
            retstr = 'skill number ['..tostring(sknum)..'] wasnt good...'
        end
    else
        retstr = 'need to loadup glbl.data with '..key..' data...'
    end
    return retstr
end

local function createSkillsValues(tbl)
    -- this function returns the skill1 thru desc3 section of Infoboxes...
    local retStr = ''
    for k,v in pairs(tbl) do
        if utils.isSimple(k) then
            if utils.isSimple(v) then
                retStr = retStr .. '| '..tostring(k)..' = ' ..v.. '\n'
            elseif type(v) == 'table' then
                retStr = retStr .. '| '..tostring(k)..' = '
                retStr = retStr .. reduceTVarrays(v) .. '\n'
            else
                retStr = retStr .. '| badValueForKey = ' ..tostring(k).. '\n'
            end
        else
            retStr = retStr .. '| badTypeForKey = "' ..type(k).. '"\n'
        end
    end
    return retStr
end




function isGoodList(args)
    local a={}
    local chk,ok
    ok = false
    chk = #args
    -- assumes args come in item,qty pairs
    -- first item ignored 'sorc' or 'list'
    if (chk > 1) and (chk % 2 == 1) then
        ok = true
        for i=2,chk do a[i-1]=args[i] end
    end
    return ok,a
end
function oneCharorShip(args)
    local key = args[1]
    local num = args[2]
    return num..' '..getNamefromKey(key)..' '
end
function listofCharsorShips(args)
    --return 'args are :' .. utils.dumpTable(args)
    local ok,reargs = isGoodList(args)
    if not ok then return 'Lists must be in name,number pairs' end
    local numLoops = #reargs/2  -- known integral from caller...
    local subargs = {}
    local tempstr, retval
    local substrs = {}
        for i = 1,numLoops do
            subargs[1] = reargs[2*(i-1)+1]
            subargs[2] = reargs[2*(i-1)+2]

            tempstr = oneCharorShip(subargs)
                substrs[#substrs+1] = tempstr
        end
    if #substrs == 1 then
        retval = substrs[1]
    elseif #substrs == 2 then
        retval = substrs[1]..' and '..substrs[2]
    else
        retval = substrs[1]
        for i = 2,#substrs-1 do
            retval = retval..', '..substrs[i]
        end
        retval = retval..', and '..substrs[#substrs]
    end
    return retval
end




local function dumpArgs()
    local retstr='glbls.args='
    retstr = retstr..utils.dumpTable(glbls.args)
    return retstr
end
local function loadDataNow()
    local sorc = glbls.sorc
    local fn,alldata,allkeys,k
    -- needed to pass in sorc
    if sorc == 's' then
        fn = glbls.typenameS..glbls.filename
    elseif sorc == 'c' then
        fn = glbls.typenameC..glbls.filename
    else
        fn = nil
    end
    if fn then
        alldata = mw.loadData(fn)
    else
        alldata = {}
    end
	-- allkeys = glbls.keys  -- empty, supposedly...
	allkeys = {}
    for _,k in ipairs(alldata) do
        allkeys[#allkeys+1] = k
    end
    glbls.data = utils.tableShallowCopy(alldata)
    glbls.keys = utils.tableShallowCopy(allkeys)
    glbls.keysLoaded = true
    return true
end


function p.isGoodKey(frame)
    local sorc,k
    if not p._main(frame) then return false end
    -- catch these before fake-frame passing for GLBLsorc...
    sorc = glbls.args[1]
    k = glbls.args[2]
    if not p.passGLBLsorc(frame) then return false end
    if not loadDataNow() then return false end
    return isGoodKey(k)
end
function p.unwrapCaller(frame)
    -- these four items are all-returned-at-once !!!
    local sorc,key,nextArg,retval
    -- NIL is a valid return-value, so skipping...
--        sorc = ''
--        key = ''
--        nextArg = ''
    if not p.isGoodKey(frame) then
        retval = false
    else
        retval = true
        sorc = glbls.args[1]
        key = glbls.args[2]
        if #glbls.args > 2 then
            nextArg = glbls.args[3]
        end
    end
    return sorc,key,nextArg,retval
end
function p.getItemfromKey(frame)
    local dummy,key,item,ok
    local retval
    dummy,key,item,ok = p.unwrapCaller(frame)
    if not ok then return false end
    retval = getItemfromKey(key,item)
    return retval
--    if not utils.isSimple(retval) then return utils.dumpTable(retval) end
end
function p.getNamefromKey(frame)
    -- this has weird-issue due to extra-possible args...
    --   so we have to strip-ignore anything extra...
    local dummy,key,ignore,ok
    local retval
    dummy,key,ignore,ok = p.unwrapCaller(frame)
    if not ok then return false end
    retval = getNamefromKey(key)
    return retval
--    if not utils.isSimple(retval) then return utils.dumpTable(retval) end
end

function p.passTBL(frame)
    local dummy,key,item,ok
    local retval
    dummy,key,item,ok = p.unwrapCaller(frame)
    if not ok then return false end
    if not isGoodKey(key) then return false end
    retval = getTablefromKey(key,item)
    return retval
--    return 'tbd...'
end

function p.isGoodList(frame)
    -- weird overcall assuming item is a number...
    -- dropping reargs from return...
    local dummy,key,item,ok
    local retval
    dummy,key,item,ok = p.unwrapCaller(frame)
    if not ok then return false end
    if not tonumber(item) then return false end
    retval = isGoodList(glbls.args)
    return retval
--    if not utils.isSimple(retval) then return utils.dumpTable(retval) end
end
function p.getFullKey(frame)
    local dummy,key,dummy2,ok
    local retval
    dummy,key,dummy2,ok = p.unwrapCaller(frame)
    if not ok then return false end
    retval = getFullKey(key)
    return retval
--    if not utils.isSimple(retval) then return utils.dumpTable(retval) end
end
function p.mkOKitems(frame)
    local sorc,dummy,dummy2,ok
    local retval
    sorc,dummy,dummy2,ok = p.unwrapCaller(frame)
    if not ok then return false end
    retval = mkOKitems(sorc)
    return retval
--    if not utils.isSimple(retval) then return utils.dumpTable(retval) end
end
function p.makeIGPTfromKey(frame)
    local dummy,key,dummy2,ok
    local retval
    dummy,key,dummy2,ok = p.unwrapCaller(frame)
    if not ok then return false end
    retval = makeIGPTfromKey(key)
    return retval
--    if not utils.isSimple(retval) then return utils.dumpTable(retval) end
end
function p.SkFt(frame)
    local dummy,key,dummy2,ok
    local retval
    if not p._main(frame) then return false end
    -- catch these before fake-frame passing for GLBLsorc...
    sorc = glbls.args[1]
    k = glbls.args[2]
    skno = tonumber(glbls.args[3])
    skit = glbls.args[4]
    skup = tonumber(glbls.args[5])
    if not p.passGLBLsorc(frame) then return false end
    if not loadDataNow() then return false end
--    retval = 'gsk['..tostring(isGoodSkill(k,skno))..']'
--    retval = 'gskit['..tostring(isGoodSKitem(skit))..']'
--    return isGoodKey(k)
--local function chooseSK(key,sknum,item,skupg)
--    retval = 'k['..k..'],skno['..skno..'],skit['..skit..'],skup['..skup..']'
    retval = chooseSK(k,skno,skit,skup)
    return retval
end




function p._main(frame)
    -- this cleans up outside (or INside) calls for args
    local a
    local one,chkpairs
    a = utils.tableShallowCopy(getargs(frame))
    if #a == 0 then return false end
    glbls.args = a
    return true
end

function p.main(frame)
    local retval = 'invalid call to Commoncodes-main: '
    local a,sorc,mKey,mItem
    local tempStr
    if not p._main(frame) then
        retval = retval..'zero arguments passed'
        return retval
    end
    a = glbls.args
    sorc = a[1]
    mKey = a[2]
    mItem = a[3]
    if not p.passGLBLsorc(frame) then
		-- this is a complicated way to just check/set
		-- a single variable (glbls.sorc=frame.args[1]),
		-- but semi-necessary due to weird indirections
		-- that wikia-system forces onto frame-stuff...
        retval = retval..'invalid sorc-value >>'..sorc..'<<'
        return retval
    end
    if not loadDataNow() then
        retval = retval..'cannot loadData'
        return retval
    end
    --retval = utils.dumpTable(a)
    --retval = dumpArgs()
    if #a == 2 then
        retval = getItemfromKey(mKey)
    else
        local origokItems = { i='image', icon='image', image='image',
                    t='tier', tier='tier',
                    n='name', name='name',
                    g='govt', govt='govt',
                    s='series', series='series',  hp='hp',
                }
        local okItems1,okItems2,okItems
--        okItems1 = p.mkOKitems('c')
--        okItems1 = p.mkOKitems('s')
--        okItems1 = p.mkOKitems(glbls.sorc)
        okItems1 = mkOKitems(sorc)
        okItems = utils.mergeTable(okItems1,origokItems)
        retval = nil
        -- ORDER REVERSAL, the mKey is now the 'requested' item
        -- while the mItem is the 'key' character/ship...
        for k,v in pairs(okItems) do
            if mKey==k then
                retval = getItemfromKey(mItem,v)
            end
        end
        --retval = utils.dumpTableSorted(okItems1)
        if not retval then
            if mKey == 'name' then
                -- allow reversal of arguments
                -- this should already be covered above...
                retval = getNamefromKey(mItem)
            elseif mKey == 'list' then
                -- need to 'drop' the sorc-value from the args-list...
                local b = {}
                for i=2,#a do b[i-1]=a[i] end
                retval = listofCharsorShips(b)
            elseif mKey == 'full' then
				if string.find(mItem,'key') then
					local dummy,alldata
					local allkeys={}
					-- use this to load-up everything...
					-- use TWICE to ensure loading works...
					if glbls.sorc=='s' then
						dummy = getNamefromKey('EN')
						--allkeys[1] = 'EN'
					elseif glbls.sorc=='c' then
						dummy = getNamefromKey('CK')
						--allkeys[1] = 'CK'
					else
						dummy = getNamefromKey('XXX')
						--allkeys[1] = 'XXX'
					end
					alldata = utils.tableShallowCopy(glbls.data)
					for k,_ in utils.tableSort(alldata) do
						if isGoodKey(k) then
							-- drops mixedCaseKeys...
							allkeys[#allkeys+1] = k
						end
					end
					dummy = utils.tableShallowCopy(allkeys)
					--dummy = utils.tableShallowCopy(alldata)
					if mItem == 'keylist' then
						tempStr = utils.dumpTableSorted(dummy)
					elseif mItem == 'keycount' then
						tempStr = utils.tblFullSize(dummy)
					else -- keyTbl
						local fakeFrame = {}
						glbls.keys = dummy
						tempStr = utils.dumpTableSorted(dummy)
						fakeFrame[1] = 'keys'
						fakeFrame[2] = utils.JSONencodeTable2String(dummy)
						tempStr = p.passGLBL(fakeFrame)
					end
				else
					tempStr = utils.dumpTableSorted(getFullKey(mItem))
				end
                retval = tempStr
            elseif mKey == 'dumpGLBL' then
                local key,fk,urps
                key = mItem
                fk = getFullKey(key)
                urps = makeIGPTfromKey(key)
                glbls.dumpGLBL = 'sorc='..glbls.sorc
--                glbls.dumpGLBL = 'key='..key..' igpt='..urps
                --glbls.dumpGLBL = 'key='..key..' igpt='..urps..' fk='..utils.dumpTable(fk)
                retval = tostring(glbls.dumpGLBL)
            else
                retval = 'CommonCodes bad-which :'..dumpArgs()
            end
        end
    end
    return retval
end


return p

