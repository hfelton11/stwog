-- infoboxes module
-- inside: [[Category:Modules]] using this line once...
-- has all the functions that will create infoboxes for both crew and ships

-- <pre>

local p = {}
local getargs = require('Dev:Arguments').getArgs
local utils = require('Module:Utilities')
local glbls = require('Module:Globals')

-- this is for switching-out the datacode/fileset quickly...
--glbls.typehero = 'Starship'
glbls.typehero = 'Character'
glbls.typecode = 'Module:'..glbls.typehero..'codes'
glbls.fileset = 'data'
--glbls.fileset = 'dataSmall'
--glbls.fileset = 'dataBaseline'
glbls.filename = glbls.typecode..'/'..glbls.fileset

local herocode = require(glbls.typecode)


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
    igpt = herocode.codename(frame)
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



return p

