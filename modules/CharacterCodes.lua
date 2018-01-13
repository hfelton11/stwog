-- charactercodes module
-- inside: [[Category:Modules]] using this line once...
-- has all the functions that will operate on/about characters

-- basic copy from layton.wikia.com/module:gamecodes...
-- <pre>

local p = {}
local getargs = require('Dev:Arguments').getArgs
local utils = require('Module:Utilities')
local glbls = require('Module:Globals')

-- this was only for checking 'key' for all-caps...
glbls.skipchks = false
--glbls.skipchks = true
-- this is for switching-out the dataset quickly...
--glbls.typename = 'Module:Starshipcodes/'
glbls.typename = 'Module:Charactercodes/'
glbls.filename = 'data'
--glbls.filename = 'dataSmall'
--glbls.filename = 'dataBaseline'

function p.hello()
    return 'Hello, world!'
end
function p.readargs(frame)
    local a
    a = getargs(frame)
    glbls.args = a
    return utils.dumpTable(a)
end

-- function added late-in-the-game for catching cases...
local function isGoodHeroKey(k)
    local retval = true
    local c
    if type(k) ~= 'string' then retval = false end
-- gross hack to use global
    if not glbls.skipchks then
        c = mw.text.trim(k)
        c = string.upper(c)
        -- delete incorrectly formatted keys (testData)
        if k ~= c then
            retval = false
        end
    end
    return retval
end
local function getcrew(key)
    local data = { igp = 'none', }
    --local fn = 'Module:Charactercodes/'..glbls.filename
    local fn = glbls.typename..glbls.filename
    local everyone = mw.loadData(fn)
    if isGoodHeroKey(key) then
        data = everyone[key]
    end
    glbls.character = utils.tableShallowCopy(data)
    -- CHEAT to double-duty this function for listkeys...
    local allkeys = {}
    for k,_ in pairs(everyone) do
        -- this includes keys that fail isGoodHeroKey()
        allkeys[#allkeys+1] = k
    end
    return allkeys
end
local function makeIGPT(hero)
    -- assumes hero table has the two-fields needed for igpt
    --    return 'kirk-1'
    if (type(hero['igp']) ~= 'nil') and (type(hero['tier']) ~= 'nil') then
        return hero['igp'] ..'-'.. hero['tier']
    else
        return nil
    end
end


function p.loadcrew(frame)
    p.readargs(frame)
    local crewKey = glbls.args[1]
    local msg, oldnew
    if not crewKey then
        msg = 'Empty Crew choice...>nil<...'
        glbls.character = { ignore = 'junk', }
    else
        local lstcrew, passcrew, codecrew
        lstcrew = getcrew(crewKey)
        passcrew = glbls.character or {}
        codecrew = makeIGPT(passcrew)
        if not codecrew then
            msg = 'Unknown Crew member...>' ..crewKey.. '<...'
        else
            oldnew = glbls.character.series
            glbls.character['code'] = codecrew
            if oldnew == "TOS" then
                msg = 'Loaded...>' ..crewKey.. '<... as CO-' ..crewKey
            elseif oldnew == "TNG" then
                msg = 'Loaded...>' ..crewKey.. '<... as CN-' ..crewKey
            else
                msg = 'Loaded...>' ..crewKey.. '<... from unknown-series:' ..oldnew
            end
        end
    end
    return msg
end
function p.codename(frame)
    p.loadcrew(frame)
    local retval = glbls.character.code
    return retval
end


function p.listkeys()
    local lstcrew = getcrew('')
    local goodcrew = {}
    for _,k in ipairs(lstcrew) do
        -- this includes keys that fail isGoodHeroKey()
        if isGoodHeroKey(k) then
            goodcrew[#goodcrew+1] = k
        end
    end
    table.sort(goodcrew)
    glbls.allkeys = goodcrew
    return utils.dumpTable(goodcrew)
end
function p.listcodes()
    p.listkeys()
    local goodcodes = {}
    local fakeframe = {}
    local hero, curcode
    for _,k in ipairs(glbls.allkeys) do
        fakeframe[1] = k
        p.loadcrew(fakeframe)
        hero = glbls.character
        curcode = makeIGPT(hero)
        if curcode then
            goodcodes[#goodcodes+1] = curcode
        end
    end
    table.sort(goodcodes)
    return utils.dumpTable(goodcodes)
end

function deepExpand(tbl)
    local str = ''
    local curtbl = utils.tableShallowCopy(tbl)
    local final = ''
    for i=3,5 do
        local chk = glbls.args[i]
        if type(chk)=='string' then
            local tmp
            str = str..chk..', '
            tmp = curtbl[chk]
            if type(tmp)=='table' then
                str = str..utils.dumpTable(tmp)
                curtbl = tmp
            else
                final = tmp
            end
        end
    end
    --return 'hit the deepExpand() with '..str..'\n'..'FINALLY='..final
    return final
end

function p.expand(frame)
    local ans = p.loadcrew(frame)
    local retval, curtbl, curval
    glbls.holdtbl = {}
	if ( string.find(ans,'Loaded...') == 1 ) then
        glbls.holdtbl = utils.tableShallowCopy(glbls.character)
        if not glbls.args[2] then
            retval = utils.dumpTableSorted(glbls.character)
        else
            curval = glbls.args[2]
            curtbl = glbls.character[curval]
            if not curtbl then
                retval = 'Unknown expansion-key >>' ..tostring(curval).. '<<\n'
            else
                if not glbls.args[3] then
                    retval = utils.dumpTableSorted(curtbl)
                else
                    local finval, fintbl
                    finval = glbls.args[3]
                    if type(curtbl) ~= 'table' then
                        retval = 'Cannot use dbl-expansion-key >>' ..tostring(finval).. '<< because >>' ..tostring(curval).. '<< did not return a table !!\n'
                    else
                        fintbl = curtbl[finval]
                        glbls.holdtbl = utils.tableShallowCopy(curtbl)
                        if not fintbl then
                            retval = 'Unknown dbl-expansion-key >>' ..tostring(finval).. '<<\n'
                        else
                        -- ick, using this secret-passage for internal-calls
                            if type(fintbl) == 'table' then
                                glbls.holdtbl = utils.tableShallowCopy(fintbl)
                            end
                            local test4upg = glbls.args[2]
                        -- double-ick, using another secret-passage !!!
                            if test4upg=='othersUpgrades' then
                                retval = deepExpand(glbls.holdtbl)
                            else
                                retval = utils.dumpTableSorted(fintbl)
                            end
                        end
                    end
                end
            end
        end
    else
        retval = ''
    end
    return retval
end

local emptyInfobox = [[
{{infobox character
 | name         = >><<
 | image        = >><<
 | imagecaption = >><<
 | aliases      = >><<
 | race         = >><<
 | gender       = >><<
 | series       = >><<
 | xnpc    = >><<
 | sdate   = >><<
 | aenu    = >><<
 | tier       = >><<
 | igpt       = >><<
 | lmin       = >><<
 | lmax       = >><<
 | limit      = >><<
 | hp         = >><<
 | nup            = >><<
 | skill1         = >><<
 | color1         = >><<
 | cost1          = >><<
 | desc1          = >><<
 | skill2         = >><<
 | color2         = >><<
 | cost2          = >><<
 | desc2          = >><<
 | skill3         = >><<
 | color3         = >><<
 | cost3          = >><<
 | desc3          = >><<
 | ar    = >><<
 | ag    = >><<
 | aw    = >><<
 | gorder       = >><<
 | dv1         = >><<
 | dv2         = >><<
 | dv3         = >><<
 | dv4         = >><<
 | dv5         = >><<
 | dv6         = >><<
}}
]]

local function reduceTVarrays(tbl)
        local descStr = ''
        -- literally assume that t- and v- items alternate and never go above t6...
        local chk = { 't1','v1','t2','v2','t3','v3','t4','v4','t5','v5','t6', }
        for i = 1,#chk do
            local subk, subv = chk[i], tbl[chk[i]]
            if subv ~= nil then descStr = descStr .. subv end
        end
        return descStr
end

-- this function returns the skill1 thru desc3 section of emptyInfobox above...
local function createSkillsValues(tbl)
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

-- this function returns the dv1 thru dv6 section of emptyInfobox above...
local function createDataValues(tbl)
    local retStr = ''
    for k,v in pairs(tbl) do
        if utils.isSimple(k) and utils.isSimple(v) then
            retStr = retStr .. '| '..tostring(k)..' = ' ..v.. '\n'
        else
            retStr = retStr .. '| badSomething = "'..type(k) ..type(v).. '"\n'
        end
    end
    return retStr
end

local function isGoodSkill(key,sknum)
    local retval = false
    if sknum > 3 then return retval end
    local fakeframe = { key, 'skills', 'desc'..sknum, }
        chkstr = p.expand(fakeframe)
    local tblsk = utils.tableShallowCopy(glbls.holdtbl)
    if not tblsk['t1'] then return retval end
    -- at this point, it should be good...
    glbls.holdtbl = tblsk
    retval = true
    return retval
end
local function isGoodUpgrade(key,sknum,skupg)
    -- assume we already passed isGoodSkill
    assert(sknum>0)
    assert(sknum<4)
    local retval = false
    if skupg < 2 then return retval end
    if skupg > 5 then return retval end
    local tblupgAll,tblupg
    local fakeframe = { key, 'skillsUpgrades', 'supgr'..skupg, }
        chkstr = p.expand(fakeframe)
    tblupgAll = utils.tableShallowCopy(glbls.holdtbl)
    if tblupgAll['desc1'] or tblupgAll['cost1'] then
        -- at this point, it should be good...
        retval = true
        glbls.holdtbl = tblupgAll
    end
    return retval
end


local function createSkillsString(returnCostInstead)
    -- we want to 'expand' and get correct table..
    local retstr = ''
    local key = glbls.args[1] or ''
    local sknum = tonumber(glbls.args[2]) or 0
    local skupg = tonumber(glbls.args[3]) or 0
    -- ignore return-dump, want global-xfer-stuff
    if utils.isNotBlank(key) and (sknum > 0) and (skupg > 0) then
        local tblsk
        if isGoodSkill(key,sknum) then
            tblsk = utils.tableShallowCopy(glbls.holdtbl)
            --retstr = retstr.. 'vars='
            --retstr = retstr..sknum..','..skupg
            --retstr = retstr..'\n\n'
            --retstr = retstr.. 'reduced='
            if skupg == 1 then
        -- horrible reverse indentations !!!
        if returnCostInstead then
                    glbls.doUpgradeCost = false
                    glbls.valUpgradeCost = false
                    retstr = tostring(glbls.valUpgradeCost)
        else
                retstr = retstr..reduceTVarrays(tblsk)
                --retstr = retstr..'\n\n'
        end

            elseif isGoodUpgrade(key,sknum,skupg) then
                local tblupgAll,tblupg
                tblupgAll = utils.tableShallowCopy(glbls.holdtbl)
                tblupg = tblupgAll['desc'..sknum]
                tbluc = tblupgAll['cost'..sknum]
                if utils.isSimple(tbluc) then
                --if isAvailableUpgradeCost(tbluc) then
                    glbls.doUpgradeCost = true
                    glbls.valUpgradeCost = tbluc
                else
                    -- symbolic value...  sigh...
                    glbls.doUpgradeCost = false
                    glbls.valUpgradeCost = false
                end
        -- horrible reverse indentations !!!
        if returnCostInstead then
                    retstr = tostring(glbls.valUpgradeCost)
        else

                --retstr = retstr..'upcost='
                --retstr = retstr..tostring(glbls.valUpgradeCost)
                --retstr = retstr..'......'
                --retstr = retstr.. 'upgrs='
                --retstr = retstr..utils.dumpTableSorted(tblupg)
                --retstr = retstr..'\n\n'
                --retstr = retstr.. 'reduced='
                retstr = retstr..reduceTVarrays(utils.mergeTable(tblsk,tblupg))
                --retstr = retstr..'\n\n'
        end
            else
                retstr = retstr..'bad SkillUpgrade='..skupg
            end
        else
            retstr = retstr..'bad Skillnum='..sknum
        end
    else
        retstr = 'not-useful-expansion for createSkillsString...'
    end
    return tostring(retstr)
end

function p.createSkillsString(frame)
    -- pass same-frame downwards...
--glbls.filename = 'data'
--glbls.filename = 'dataSmall'
    local chkstr = p.readargs(frame)
    local retstr = createSkillsString()
    return tostring(retstr)
--glbls.filename = 'data'
--glbls.filename = 'dataSmall'
end
function p.createSkillsCost(frame)
    -- totally subtle magic-key passing...
    local chkstr = p.readargs(frame)
    local retstr = createSkillsString(true)
    return tostring(retstr)
end



-- this function returns the emptyInfobox callout above, hopefully...
-- nb: order doesnt matter for an infobox and only two subtables matter:
---    the skills-subtable and the datavalues-subtable...
local function createInfoboxValues(k,v)
    local retStr = ''
        if utils.isSimple(v) then
            retStr = retStr .. '| '..k..' = ' ..v.. '\n'
        elseif type(v) == 'table' then
            if k == 'skills' then
                retStr = retStr .. createSkillsValues(v)
            elseif k == 'datavalues' then
                retStr = retStr .. createDataValues(v)
            else
                retStr = retStr .. '| '..k..' = "Unknown Table???"\n'
            end
        else
            retStr = retStr .. '| urpWannabe = ' ..type(v).. '\n'
        end
    return retStr
end


-- originally this constructed the complete emptyInfobox callout above,
-- but now it only checks that all inputs are good(?)-strings to use...
local function dumpInfobox(tbl)
    -- this assume the table is semi-'perfect' for dumping...
--    local retStr = '{{infobox character\n'
    local retStr = ''
    local urpTbl = {}
    -- reset the glbl each time this is called...
--    glbls.ERROR_URPS = ''
    glbls.ERROR_URPTF = false
    for k,v in pairs(tbl) do
            if type(k) == 'string' then
                retStr = retStr .. createInfoboxValues(k,v)
            elseif type(k) == 'number' then
                urpTbl[k] = utils.tableSimpleCopy(v)
            else
                local msg = 'WTF ??? key-type-error\n'
                msg = msg .. string.format('key-type is %s',type(k))
                msg = msg .. string.format(' with tostring-of %s', tostring(k))
                msg = msg .. string.format(' which receives a value-type of %s',type(v))
                msg = msg .. string.format(' with tostring-of %s', tostring(v))
                table.insert(urpTbl,msg)
            --    table.insert(urpTbl,'WTF ??? ' ..type(k).. '=' ..type(v))
            end
    end
--        retStr = retStr .. '}}\n'
    -- checks if empty urpTbl...
    if not next(urpTbl) then
        return retStr
    else
        glbls.ERROR_URPTF = true
--        glbls.ERROR_URPS = "urpTable follows:"
--        return  glbls.ERROR_URPS..'\n'..utils.dumpTable(urpTbl)
        return  'urpTable follows:\n'..utils.dumpTable(urpTbl)
    end
end


-- VERY INELEGANT SOLUTION to swapping templates based on input-requested ??
--  see the mini-fcn-calls below the main-fcn here for pass-back globals...  sigh...
--function p.mkInfobox(frame)
function mkInfobox(frame)
    local hero,urps
    local igpt
--    local retStr = '{{infobox character\n'
    local retStr = '{{infobox ' ..glbls.IB_type.. '\n'
    -- using side-effect of global populate of crewHero...  ick...
    igpt = p.codename(frame)
-- checking-for-nil is fine for externally-facing-fcns, imo...
--    if ( type(igpt) ~= 'nil' ) then
    if ( type(igpt) ~= 'nil' ) and ( igpt ~= '' ) then
-- --------    if ( p.codename(frame) ~= '' ) then
        hero = glbls.character
        urps = dumpInfobox(hero)
    	if glbls.ERROR_URPTF then
    	    return urps
	    else
	        retStr = retStr .. urps
            retStr = retStr .. '| igpt = ' ..igpt.. '\n'
            retStr = retStr .. '}}\n'
        end
    else
        retStr = 'NO JOY on igpt...  check input data...\n'
    end
    return retStr
end
-- these SHOULD be parsed upon the getargs[0] element (calling-name)...
local function chooseInfobox(word,frame)
    if word == 'mkInfobox' then glbls.IB_type = 'character' end
    if word == 'mkMiniInfobox' then glbls.IB_type = ' ' end
    if word == 'mkLevelInfobox' then glbls.IB_type = 'character2' end

    return mkInfobox(frame)
end
function p.mkInfobox(frame)
    return chooseInfobox('mkInfobox',frame)
end
function p.mkMiniInfobox(frame)
    return chooseInfobox('mkMiniInfobox',frame)
end
function p.mkLevelInfobox(frame)
    return chooseInfobox('mkLevelInfobox',frame)
end
function p.doInfobox(frame)
    return frame:preprocess(p.mkInfobox(frame))
end
function p.doMiniInfobox(frame)
    return frame:preprocess(p.mkMiniInfobox(frame))
end
function p.doLevelInfobox(frame)
    return frame:preprocess(p.mkLevelInfobox(frame))
end



function p.getAK()
    p.listkeys()
    return glbls.allkeys
end

--[[


--]]





--[====[





function p.getAK(frame)
    return getAllKeys()
end
--function p.listkeys(frame)
--    local allkeys
--    allkeys = getAllKeys()
--    -- this should not necessarily return the dump 'in-order' ???...
--    return utils.dumpTable(allkeys)
--end
function p.listkeys(frame)
    return utils.dumpTable(p.getAK(frame))
end
function p.listcodes(frame)
    local allcodes
    allcodes = makeAllCodes()
    -- note - codes are in alphabetical-order, and THEN tier-order...
    return utils.dumpTable(allcodes)
end


function p.simpleListKeys(frame)
    local allkeys
    allkeys = getAllKeys()
    --return utils.dumpSimpleList(allkeys,5,false)  -- assume mklinks==false
    return utils.dumpSimpleList(allkeys)
end
function p.simpleListCodes(frame)
    local allcodes
--    local rowgaps = false
    local rowgaps = 3.5
--    p.getargs(frame)
    allcodes = makeAllCodes()
    return utils.dumpSimpleList(allcodes,rowgaps,true)
--    return utils.dumpSimpleList(allcodes)
end

--]====]


return p

