-- codelists module
-- inside: [[Category:Modules]] using this line once...
-- has all the functions that will operate on/about characters and starship codes

-- <pre>

local p = {}
local getargs = require('Dev:Arguments').getArgs
local utils = require('Module:Utilities')
local glbls = require('Module:Globals')

glbls.typeC = 'Module:Charactercodes/'
glbls.typeS = 'Module:Starshipcodes/'
glbls.fileD = 'data'

local function choosewhere(w)
    -- silliness to choose crew or ship
    local c
    c = mw.text.trim(w)
    c = string.upper(c)
    c = string.sub(c,1,1)
    if c == 'S' then
		glbls.typename = glbls.typeS
	else
		glbls.typename = glbls.typeC
	end
	glbls.filename = glbls.typename..glbls.fileD
	return
end

--- hello-world to setup testcases correctly...
function p.main(frame)
    local a = getargs(frame)
    local where = a[1]   -- crew or ship
    local what = a[2]    -- verb describing 'job'
    local how = a[3]     -- qualifiers
    local which = a[4]
    local value = a[5]
    local out
    choosewhere(where)
    if what=='index' then
        out = mkIndex()
--[[
    elseif (what=='testSkills') or (what=='skills') then
        local begtbl = loadCrewSkillsBegin(how)
        local endtbl = loadCrewSkillsEnd(how,begtbl)
        if what=='skills' then
            out = mkTableSkills(begtbl,endtbl)
        else
            out = utils.dumpTable(begtbl)
        end
    elseif what=='printUp03' then
        out = mkUpgradetemplate(how,'up03')
    elseif what=='printUp09' then
        out = mkUpgradetemplate(how,'up09')
    elseif what=='printUp10' then
        out = mkUpgradetemplate(how,'up10')
    elseif what=='printUp15' then
        out = mkUpgradetemplate(how,'up15')
    elseif what=='mkUp03' then
        return frame:preprocess(mkUpgradetemplate(how,'up03'))
    elseif what=='mkUp09' then
        return frame:preprocess(mkUpgradetemplate(how,'up09'))
    elseif what=='mkUp10' then
        return frame:preprocess(mkUpgradetemplate(how,'up10'))
    elseif what=='mkUp15' then
        return frame:preprocess(mkUpgradetemplate(how,'up15'))
    elseif what=='testJSON' then
        local test1 = { 'key', 'image', 'name', }
        local test2 = { 'key', 'image', 'name', tier=2, }
        local test3 = '["key","image","name","tier"]'
        local en1 = utils.JSONencodeTable2String(test1)
        local en2 = utils.JSONencodeTable2String(test2)
        local de1 = utils.JSONdecodeString2Table(en1)
        local de2 = utils.JSONdecodeString2Table(en2)
        local de3 = utils.JSONdecodeString2Table(test3)
        local out1,out2,out3
        out1 = '>>>'..utils.dumpTable(test1)..'<<< encodes to: >>>'..en1..'<<< and decodes to: >>>'..utils.dumpTable(de1)..'<<<\n\n\n'
        out2 = '>>>'..utils.dumpTable(test2)..'<<< encodes to: >>>'..en2..'<<< and decodes to: >>>'..utils.dumpTable(de2)..'<<<\n\n\n'
        out3 = '>>>'..utils.dumpTable(test3)..'<<< decodes to: >>>'..utils.dumpTable(de3)..'<<<\n\n\n'
        out = out1..out2..out3
    elseif what=='table' then
        local tblHow = {}
        if how:sub(1,2)=='["' then
            tblHow = utils.JSONdecodeString2Table(how)
        end
        if #tblHow==0 then
            out = "Hello, table! - doing... "..what..
                " ...using how... "..how..
                " ...choosing which... "..which..
                " ...as value... "..value.." ???\n\n\n"
        else
            out = mkTable(tblHow,which,value)
        end
	elseif what=='categories' then
        local cattbl
        local hero = tostring(value)
        out = ''
        -- making string backwards (pre-pending) below cuz easier to do logic...
        if which=='one' then
            out = out..'for one hero...\n'
            if hero~='' then
                out = out..'named >'..hero..'< ...\n'
                cattbl = loadCrewCategories(hero)
            else
                out = out..'who needs to be named !?!?!?...\n\n\n'
            end
        elseif which=='all' then
            out = out..'for all the heroes...\n'
            if hero~='' then
                out = out..'ignoring >'..hero..'< ...\n'
            end
        else
            out = out..'dont know for which heroes...\n'
        end
        -- PREpending...
        if how=='print' then
            out = 'print out the categories...\n'..out
                out2 = mkCrewCategories(cattbl,how)
                out = out..'\n'..out2
        elseif how=='colors' then
            out = 'add the color categories to the category-list...\n'..out
                out2 = mkCrewCategories(cattbl,how)
                out = out2
        elseif how=='replace' then
            out = 'replace all the categories...\n'..out
        elseif how=='append' then
            out = 'append to current categories...\n'..out
        elseif how=='remove' then
            out = 'remove one categories...\n'..out
        elseif how=='zero' then
            out = 'remove all the categories...\n'..out
        elseif how=='fix' then
            out = 'fix the categories...\n'..out
        else
            out = 'dont know how to work with the categories...\n'..out
        end
        -- back to usual appending...
        -- out = out..'\n\n\n'
--]]
    else
        out = "Hello, world! - whereupon... "..tostring(where)..
				" - doing what... "..tostring(what)..
                " ...using how... "..tostring(how)..
                " ...choosing which... "..tostring(which)..
                " ...as value... "..tostring(value).." ???\n\n\n"
    end
    return tostring( out )
end


return p

