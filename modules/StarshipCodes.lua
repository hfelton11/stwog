-- starshipcodes module
-- inside: [[Category:Modules]] using this line once...
-- has all the functions that will operate on/about starships

-- <pre>

local p = {}
-- see: http://stackoverflow.com/questions/13964764/lua-how-to-avoid-circular-requires?noredirect=1&lq=1
local getargs = getargs or require('Dev:Arguments').getArgs
local utils = utils or require('Module:Utilities')
local glbls = glbls or require('Module:Globals')
local blnks = blnks or require('Module:BlankCommons')
local comns = comns or require('Module:CommonCodes')
local gems = gems or require('Module:Gems')

-- most of these globals are used in 'comns'-modules...
-- but lets see if i do NOT have to pre-declare them here...
-- ERROR_URPTF being nil means false...
--glbls.sorc = 's'
--glbls.typename = 'Module:Starshipcodes/'
--glbls.filename = 'data'
--glbls.keysLoaded = false
--glbls.keys = {}
glbls.data = {}
glbls.args = {'junk',}
glbls.starship = 'starsh'
--glbls.dumpGLBL = 'TEST-dumpGLBL'

function p.hello()
    return 'Hello, world!'
end

local function mkOKitems()
    local items = {}
    for k,v in pairs(blnks.ship()) do
        if utils.isSimple(v) then
            --items[#items+1]=k
            items[k]=k
        end
    end
    return items
end

local function mkTBLitems()
    local items = {}
    for k,v in pairs(blnks.ship()) do
        if type(v)=='table' then
            --items[#items+1]=k
            items[k]=k
        end
    end
    return items
end

function p._main(frame)
    -- this cleans up outside calls for args
    local a
    a = utils.tableShallowCopy(getargs(frame))
    if #a == 0 then return false end
    glbls.args = a
    return true
end
function p.rewrap(frame)
    local a = {}
    if not p._main(frame) then return false end
    local numargs = #glbls.args
    a[1] = 's'
    for i=1,numargs do a[i+1]=glbls.args[i] end
    return true,a
    --mkordered
--    return utils.dumpSimpleList(a,false,false,true,false)
end


function p.main(frame)
    local ok,a
    local retval='main-fail'
    ok,a = p.rewrap(frame)
    if ok then retval=comns.main(a) end
    return retval
end
function p.codename(frame)
    local ok,a
    local retval='codename-fail'
    ok,a = p.rewrap(frame)
    if ok then retval=comns.makeIGPTfromKey(a) end
    return retval
end

local function getItemfromKey(key,item)
    local ok,a
    local retval='getItem-fail'
    local fakeframe = {key,item}
    ok,a = p.rewrap(fakeframe)
    if ok then retval=comns.getItemfromKey(a) end
    return retval
end
local function getSkillItemfromKey(key,sknum,item,skupg)
	-- this retrieves just a string from the skills/features table
	-- key = SGZ, sknum = 1to3, item = cost/desc/, skupg = 1to5
    local ok,a
    local retval='getSkillItem-fail'
    local fakeframe = {key,sknum,item,skupg}
    ok,a = p.rewrap(fakeframe)
    if ok then retval=comns.SkFt(a) end
    return retval
end


--  how to pass TABLES rather than strings like for skills...
--  how to pass TABLES rather than strings like for skills...
--  how to pass TABLES rather than strings like for skills...
--  how to pass TABLES rather than strings like for skills...
--  how to pass TABLES rather than strings like for skills...


local function getTablefromKey(k,tblNm)
    local fake = {}
    local retval='getTable-fail'
    local retTBL
    fake[1]='s'
    fake[2]=tostring(k)
    fake[3]=tostring(tblNm)
    --fake[3]='skills'
    retval=comns.passTBL(fake)
--    retTBL = utils.JSONdecodeString2Table(retval)
    glbls.data = utils.JSONdecodeString2Table(retval)
    return retval
end

local function dumpTBLs(key)
    local retval,okTables,tmpTBL
    local retStr,tmpSTR1,tmpSTR2
    okTables = mkTBLitems()  -- ANTI utils.isSimple()
    retStr = ''
    for k,v in pairs(okTables) do
        -- need magic happening...
        tmpSTR1 = 'Table-'..tostring(k)..' = '
        tmpTBL = getTablefromKey(key,v)
        tmpSTR2 = utils.dumpTableSorted(tmpTBL)
        retStr = retStr..tmpSTR1..tmpSTR2..'\n'
    end
end

function p.showTBLs(frame)
    local ok,a
    local retval='showTBLs-fail'
    ok,a = p.rewrap(frame)
    if ok then retval=dumpTBLs(glbls.args[1]) end
    return retval
end

function p.skills(frame)
--local function getskills(frame)
	-- this retrieves the complete skills-table...
    local ok,a
    local retval='skills-fail'
    ok,a = p.rewrap(frame)
    a[#a+1]='skills'
    if ok then retval=comns.passTBL(a) end
    return retval
end

function p.mkSkillsTable(frame)
	-- do the html-stuff in CommonLists module...
end




local function dumpInfobox(key)
    local retval,okItems,fk
    local retStr,tmpSTR1,tmpSTR2
    local fakeframe = {}
    okItems = mkOKitems()  -- only utils.isSimple()
    retStr = ''
    for k,v in pairs(okItems) do
        tmpSTR1 = '|'..tostring(k)..' = '
        tmpSTR2 = getItemfromKey(key,v)
        retStr = retStr..tmpSTR1..tmpSTR2..'\n'
    end
    -- all starships have 3 skills, unlike crew who some-have-only-2...
    -- also, only need un-upgraded skills here...
    for i=1,3 do
        for _,nm in ipairs({'skill','color','cost','desc',}) do
            local nmi = nm..tostring(i)
            tmpSTR1 = '|'..nmi..' = '
            tmpSTR2 = getSkillItemfromKey(key,i,nm,1)
            retStr = retStr..tmpSTR1..tmpSTR2..'\n'
        end
    end
	-- here is where CREW-table additions go...
    return retStr
end

--function p.dumpInfobox(frame)
--    return dumpInfobox('SGZ')
--end


-- should test/continue this...


-- VERY INELEGANT SOLUTION to swapping templates based on input-requested ??
--  see the mini-fcn-calls below the main-fcn here for pass-back globals...  sigh...
function mkInfobox(frame)
    local hero,urps
    local igpt,key
    local retStr = '{{infobox ' ..glbls.IB_type.. '\n'
    igpt = p.codename(frame)
    key = glbls.args[1]
    if ( type(igpt) ~= 'nil' ) and ( igpt ~= '' ) then
        hero = glbls.starship
        urps = dumpInfobox(key)
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
    if word == 'mkInfobox' then glbls.IB_type = 'starship' end
    if word == 'mkMiniInfobox' then glbls.IB_type = ' ' end
    if word == 'mkLevelInfobox' then glbls.IB_type = 'starship2' end

    return mkInfobox(frame)
end

function p.mkInfobox(frame)
    return chooseInfobox('mkInfobox',frame)
end

function p.doInfobox(frame)
    return frame:preprocess(p.mkInfobox(frame))
end

function p.doMiniInfobox(frame)
    return frame:preprocess(chooseInfobox('mkMiniInfobox',frame))
end
function p.doLevelInfobox(frame)
    return frame:preprocess(chooseInfobox('mkLevelInfobox',frame))
end

return p

