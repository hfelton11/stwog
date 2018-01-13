-- characterlists module
-- inside: [[Category:Modules]] using this line once...
-- has all the functions that will operate on/about characters

-- trying to make html-tables for index, navbox, etc...
-- <pre>

local p = {}
local getargs = require('Dev:Arguments').getArgs
local utils = require('Module:Utilities')
-- see: http://stackoverflow.com/questions/13964764/lua-how-to-avoid-circular-requires?noredirect=1&lq=1
local cc = cc or require('Module:Charactercodes')
local gems = gems or require('Module:Gems')
local glbls = require('Module:Globals')

-- semi-dummy statement because 'out' is going to hold the final html-object...
glbls.out = true

-- these are only one-level-down possibles...  not all possibilities in cc.expand()...
local possibles = { 'name',     'image',    'imagecaption',
                    'aliases',  'race',     'gender',
                    'series',   'xnpc',     'sdate',
                    'aenu',     'tier',     'igp',
                    'lmin',     'lmax',     'limit',
                    'hp',       'nup',      'gorder',
                    'ar',       'ag',       'aw',
                    'code',     'key',      'currentlevel',
                  }
local defaultOrder = { 'key', 'image', 'name', 'aliases',
                        'code', 'tier', 'series', 'hp', }
glbls.choices = defaultOrder


local function chkCrew(c)
    -- assume dummy-values, but put in valid ones if available...
    assert(type(c)=='table')
    local dummy = 'dummy'
    local rettbl = {}
	for _,k in ipairs(possibles) do
        if utils.isNotBlank(c[k]) then
            rettbl[k] = c[k]
        else
            rettbl[k] = dummy
        end
    end
    return rettbl
end

local function chooseCols( cols )
    -- assumes cols is a valid table already...
    -- do in-order of choices and with repeats...
    local choices = {}
    if utils.isSequence(cols) then
        for _,v in ipairs(cols) do
--            for _,u in ipairs(glbls.choices) do
            for _,u in ipairs(possibles) do
                if u==v then
                    choices[#choices+1] = v
                end
            end
        end
    else
        for k,v in pairs(cols) do
--            for _,u in ipairs(glbls.choices) do
            for _,u in ipairs(possibles) do
                if v and u==k then
                    choices[#choices+1] = k
                end
            end
        end
    end
    if #choices == 0 then choices = glbls.choices end
    return choices
end

local function addRowSkills( idx, tbl )
	local row = mw.html.create('tr')
	local cost = tbl[idx]['cost']
    row
        :css('text-align','center;')
        :tag('td'):wikitext(idx):done()
        :tag('td'):wikitext(cost):done()

	local desc = tbl[idx]['desc']
    row
        :css('text-align','left;')
        :tag('td'):wikitext(desc):done()
    return row
end

glbls.sorter = 0.001
local function addRow( crew, cols )
	-- Init
	local row = mw.html.create('tr')
	local defaultCols = { 'key', 'image', 'aliases', }

    if not cols then
        usecols = glbls.choices
    --elseif type(cols)~='table' then
    --    usecols = defaultCols
    else
        usecols = chooseCols(cols)
    end


    local lnk,lnki
        local ser = crew.series
        local dirser = ''
        if ser=='TOS' then dirser='CO/' end
        if ser=='TNG' then dirser='CN/' end

    for _,c in ipairs(usecols) do
        if c=='key' then
            lnk = '[['..dirser..crew.key..'|'..crew.key..']]'
            row
                :css('text-align','center;')
	            --:tag('td'):wikitext(crew.key):done()
                :tag('td'):wikitext(lnk):done()
        elseif c=='image' then
            -- making link point to level-50 possibilities...
            lnk = dirser..'L50/'..crew.key
            --lnk = dirser..crew.key
        --    --lnki = '[[File:'..crew.image..'|35px|link= ]]'
            lnki = '[[File:'..crew.image..'|35px|link='..lnk..']]'
        --    lnki = '[[File:'..crew.image..'|35px]]'
            row
                :tag('td'):wikitext(lnki):done()
        elseif c=='tier' then
            --glbls.sorter = glbls.sorter + 0.001
            --local sorter = glbls.sorter + utils.toNum(crew.tier)
            lnk = '[[:Category:Tier '..crew.tier..'|'..crew.tier..']]'
            row
                --:attr('data-sort-value',sorter)
                :tag('td'):wikitext(lnk):done()
        elseif c=='series' then
            lnk = '[[:Category:'..crew.series..' Crew|'..crew.series..']]'
            row
                :tag('td'):wikitext(lnk):done()
        elseif c=='hp' then
            lnk = utils.toNum(crew.hp,'')
            row
                :attr('data-sort-type','numeric')
                :tag('td'):wikitext(lnk):done()
        else
            row
                :tag('td'):wikitext(crew[c]):done()
        end
    -- endfor
    end

	return row
end

local function addHeaderSkills()
	local row = mw.html.create('tr')
    local cols = {'upgrade','cost','description',}
    for _,c in ipairs(cols) do
        row:tag('th'):wikitext(utils.TitleCase(c)):done()
    end
	return row
end

local function addHeader(cols)
	local row = mw.html.create('tr')
	local usecols = {}
    if not cols or type(cols)~='table' then
        usecols = glbls.choices
    else
        usecols = chooseCols(cols)
    end
	-- the :tag adds nodes-to-builder (row) and returns updated-instance (row)
    for _,c in ipairs(usecols) do
        if c=='key' then
            row
                :tag('th')
                    :css('width','8%')
                    :wikitext('Key'):done()
        elseif c=='series' then
            row
                :tag('th'):wikitext('TOS/TNG'):done()
        elseif c=='hp' or c=='tier' then
            local nam = c:upper()
            row
                :tag('th')
                :css('width','8%')
                --:cssText(' scope="col" data-sort-type="numeric" ')
                :attr('scope','col')
                :attr('data-sort-type','numeric')
                :wikitext(nam):done()
        else
            row
                --:tag('th'):wikitext(utils.TitleCase(tostring(c))):done()
                :tag('th'):wikitext(utils.TitleCase(c)):done()
                --:tag('th'):wikitext(c):done()
        end
    -- endfor
    end
	return row
end

local function isGoodExpansion(unk)
    retval = false
    if type(unk) == 'string' then
        -- skip unknown and cannot-use strings...
        -- obscure-feature 'true' for no-magic-pattern-chars
        -- see: http://www.lua.org/manual/5.2/manual.html#pdf-string.find
        if not string.find(unk,'dbl-exp',1,true) then
            retval = true
        end
    elseif utils.isSimple(unk) then
        -- order is important, because strings would normally be ok...
        retval = true
    else
        retval = false
    end
    return retval
end

local function loadCrewSkillsBegin(k)
    local fakeFrame = {}
    local getvals,chkreadargs
    local rtbl = {}
    --local basics = {'skill','color',}
    local basics = {'skill','color','cost',}
    --local basics = {'skill','color','cost','desc',}
		fakeFrame[1] = k
	    fakeFrame[2] = 'skills'
        for i = 1,3 do
            rtbl[i] = {}
    		for _,c in ipairs(basics) do
                fakeFrame[3] = c..tostring(i)
                chkreadargs = cc.expand(fakeFrame)
                if isGoodExpansion(chkreadargs) then
                    rtbl[i][c] = tostring(chkreadargs)
                end
            end
            -- remove empty-skills
            if utils.tblFullSize(rtbl[i]) == 0 then
                rtbl[i] = nil
            end
            --if rtbl[i] then rtbl[i]['desc']='end['..tostring(i)..']' end
        end
    return rtbl
end
local function loadCrewSkillsEnd(k,begtbl)
    local fakeFrame = {}
    local getvals,chkreadargs
    local rtbl = {}
        --rtbl.key = k
		fakeFrame[1] = k
		for sk,_ in ipairs(begtbl) do
		    rtbl[sk] = {}
            local defCost = begtbl[sk]['cost']
            for up = 1,5 do
		        fakeFrame[2] = sk
        		fakeFrame[3] = up
        		rtbl[sk][up] = {}
        		-- this forces all skill-upgrades to provide a 'desc' field !!!
    		    chkreadargs = cc.createSkillsString(fakeFrame)
                    rtbl[sk][up]['desc'] = chkreadargs
                chkreadargs = cc.createSkillsCost(fakeFrame)
                if chkreadargs=='false' then
                    rtbl[sk][up]['cost'] = defCost
                else
                    rtbl[sk][up]['cost'] = chkreadargs
	            end
            end
        end
	return rtbl
end


local function mkCrewCategories(rtbl,choice)
    local rstbl = {}
    local retval = ''
        for key,val in pairs(rtbl) do
            if choice=='print' then
                rstbl[#rstbl+1] = '[[:Category:'..val..'|'..val..']]'
            elseif choice=='colors' then
                if key:sub(1,5)=='color' then
                    -- rstbl[#rstbl+1] = '[[:Category:'..val..']]'
                    rstbl[#rstbl+1] = '[[Category:'..val..']]'
                    retval = retval..rstbl[#rstbl]
                end
            else
            end
        end
            if choice=='print' then
                retval = utils.dumpTable(rstbl)
            end
    --return rstbl
    return retval
end


local function loadCrewCategories(k)
    local fakeFrame = {}
    local getvals,chkreadargs
    local rtbl = {}
    local rstbl = {}
    local basics = {'series','tier',}
    local colors = {'color1','color2','color3'}
    local convert = {tier='Tier ',}
		fakeFrame[1] = k
		for i = 1,#basics do
            fakeFrame[2] = basics[i]
            chkreadargs = cc.expand(fakeFrame)
            if isGoodExpansion(chkreadargs) then
                --rtbl[#rtbl+1] = tostring(chkreadargs)
                rtbl[basics[i]] = tostring(chkreadargs)
            end
        end
        for i = 1,#colors do
            fakeFrame[2] = 'skills'
            fakeFrame[3] = colors[i]
            chkreadargs = cc.expand(fakeFrame)
            if isGoodExpansion(chkreadargs) then
                --rtbl[#rtbl+1] = tostring(chkreadargs)
                rtbl[colors[i]] = tostring(chkreadargs)
            end
        end
        for key,val in pairs(rtbl) do
            for chk1,cnv2 in pairs(convert) do
                if key==chk1 then
                    val = cnv2..tostring(val)
                end
            end
            rstbl[key] = val
        end
    return rstbl
end


local function loadCrewOneOthersUpgrades(k,chosens,upg1,upg2)
    local fakeFrame = {}
    local chkreadargs
    local rtbl = {}
    local ffnum
		fakeFrame[1] = k
        rtbl.key = k
    if type(upg1)~='string' then return rtbl end
        fakeFrame[2] = 'othersUpgrades'
        fakeFrame[3] = upg1
    if not upg2 then ffnum = 4 end
    if type(upg2)~='string' then
        ffnum = 4
    else
        fakeFrame[4] = upg2
        ffnum = 5
    end
        if not chosens then chosens = possibles end
        if type(chosens)~='table' then chosens = possibles end
		for _,c in ipairs(chosens) do
		    fakeFrame[ffnum] = c
		    chkreadargs = cc.expand(fakeFrame)
		    if isGoodExpansion(chkreadargs) then
	            rtbl[c] = tostring(chkreadargs)
	        end
        end
    return rtbl
end


local function loadCrewOne(k,chosens)
    local fakeFrame = {}
    local getvals,chkreadargs
    local rtbl = {}
		fakeFrame[1] = k
        rtbl.key = k
        if not chosens then chosens = possibles end
        if type(chosens)~='table' then chosens = possibles end
		for _,c in ipairs(chosens) do
		    fakeFrame[2] = c
		    chkreadargs = cc.expand(fakeFrame)
		    if isGoodExpansion(chkreadargs) then
	            rtbl[c] = tostring(chkreadargs)
	        end
        end
    return rtbl
end


local function mkRow(k,cols)
    local newrow, chkvals
    local crew = loadCrewOne(k)
        crew.key = k
        chkvals = chkCrew(crew)
		newrow = addRow( chkvals, cols )
    return newrow
end





local function mkIndex()
    local allkeys = cc.getAK(fakeFrame)
    local r  -- to hold extra nodes/rows
    glbls.out = mw.html.create('table'):addClass('wikitable sortable')
    r = addHeader()
    glbls.out:node(r)  -- adds a child-node of (row) to current-instance (table)
    for _,key in ipairs(allkeys) do
        r = mkRow(key)
        glbls.out:node(r)
    end
    r = addHeader()
    glbls.out:node(r)
    return glbls.out
end

local function chooser(k,c,v)
    -- end up loading the row twice...
    local crew = loadCrewOne(k)
    if crew[c]==v then
        return true
    else
        return false
    end
end

local function mkTable(cols,choose,rows)
    local allkeys = cc.getAK(fakeFrame)
    local r
    glbls.out = mw.html.create('table'):addClass('wikitable sortable')
    r = addHeader(cols)
    glbls.out:node(r)
    for _,key in ipairs(allkeys) do
        if not choose or chooser(key,choose,rows) then
            r = mkRow(key,cols)
            glbls.out:node(r)
        end
    end
    r = addHeader(cols)
    glbls.out:node(r)
    return glbls.out
end


local function mkColorDiv(skColor,txt)
    local tmp, tmp2, tmp3
    -- need more checks on 'color'...
    assert(type(skColor)=='string')
    tmp2 = skColor:lower()..";"
    if utils.isBlank(txt) then txt = skColor end
    tmp3 = '[[:Category:'..txt..'|'..txt..']]'
    tmp = mw.html.create('span')
    tmp
        :css('color',tmp2)
--        :wikitext(txt)
        :wikitext(tmp3)
    return tmp
end


local function mkTableSkillsOne(begT,endT,chooseNum)
    local r
    local outDiv = mw.html.create('div')
    local outTbl = mw.html.create('table'):addClass('wikitable sortable')
    --glbls.out = mw.html.create('table'):addClass('wikitable sortable')
    local skName = begT[chooseNum]['skill']
    local skColor = begT[chooseNum]['color']

    outDiv
        :attr('id',skName)
        :wikitext('Skill Number '..chooseNum..' is called ')
        :wikitext("'''"..skName.."'''.")
        :newline()
        --:wikitext('Its color is '..skColor..'.')
        :wikitext('Its color is ')
        --:node(mkColorDiv(skColor)):done()
        :node(mkColorDiv(skColor))
        :wikitext('.  '..gems.one({skColor,'15'}))
        :newline()

    r = addHeaderSkills()
    outTbl:node(r)

    --local upgrTbl = utils.tableShallowCopy(endT[chooseNum])
    local upgrTbl = endT[chooseNum]
    for up = 1,#upgrTbl do
        r = addRowSkills(up,upgrTbl)
        outTbl:node(r)
    end

    outDiv
        :node(outTbl)
        :newline()
        :newline()
        :newline()
        :newline()
        --:tag('hr')
        --:done()

    return outDiv
end
local function mkTableSkills(begT,endT)
    local retOut
    glbls.out = mw.html.create()
    for i=1,#begT do
        retOut = mkTableSkillsOne(begT,endT,i):done()
        glbls.out:node(retOut)
    end
    return glbls.out

end


--- hello-world to setup testcases correctly...
function mkUpgradetemplate(k,upNum)
    -- check k for good person-key...
    -- check upNum for good values ('up10',...)
    local fakeFrame = {}
    --local str01 = '{{#invoke:Charactercodes|expand|'
    local items01 = {   'image',    'name', 'series',
                        'limit',    'tier',    'lmin', }
    --local str02 = 'othersUpgrades|up10|'
    local items02 = {   'ag',   'ar',   'aw',   'hp',   'gorder',
                        'currentlevel', 'skillschosen', }
    --local str03 = 'datavalues|'
    local items03 = {   'dv1',  'dv2',  'dv3',  'dv4',  'dv5',  'dv6',  }
    local retval
    local tmptbl, tmp
    retval = '{{Infobox character2\n'
        tmptbl = loadCrewOne(k,items01)
        --retval = retval .. utils.dumpTable(tmptbl)
    for _,v in ipairs(items01) do
        tmp = ' = '..tmptbl[v]..'\n'
        retval = retval..'|'..v..tmp
    end
        tmptbl = loadCrewOneOthersUpgrades(k,items02,upNum)
    for _,v in ipairs(items02) do
        tmp = ' = '..tmptbl[v]..'\n'
        retval = retval..'|'..v..tmp
    end
        tmptbl = loadCrewOneOthersUpgrades(k,items03,upNum,'datavalues')
    for _,v in ipairs(items03) do
        tmp = ' = '..tmptbl[v]..'\n'
        retval = retval..'|'..v..tmp
    end
    -- failsafe: if dv returns a string (rather than a number) them abort...
    if tmp:sub(1,6)==' = Unk' then return '' end
    return retval..'}}'
    --return tmp
end


--- hello-world to setup testcases correctly...
function p.main(frame)
    local a = getargs(frame)
    local what = a[1]
    local how = a[2]
    local which = a[3]
    local value = a[4]
    local out
    if what=='index' then
        out = mkIndex()
    elseif (what=='testSkills') or (what=='skills') then
        local begtbl = loadCrewSkillsBegin(how)
        local endtbl = loadCrewSkillsEnd(how,begtbl)
        if what=='skills' then
            out = mkTableSkills(begtbl,endtbl)
        else
            out = utils.dumpTable(begtbl)
            --out = out..'\n\n'..utils.dumpTable(endtbl)
        end
--    elseif what=='skills' then
--        local begtbl = loadCrewSkillsBegin(how)
--        local endtbl = loadCrewSkillsEnd(how,begtbl)
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
            --out = mkTable(tblHow,which,value)
            out = "Hello, table! - doing... "..what..
                " ...using how... "..how..
                " ...choosing which... "..which..
                " ...as value... "..value.." ???\n\n\n"
        else
            --out1 = '\n\n\nhow...>>>'..how..'<<<\n\n\n'
            --out2 = '\n\n\nhow...>>>'..how:sub(1,1)..'<<<\n\n\n'
            out = mkTable(tblHow,which,value)
            --out = out1..out2..tostring(out3)
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
                --rtbl = mkCrewCategories(cattbl,how)
                --out2 = utils.dumpTable(rtbl)
                out2 = mkCrewCategories(cattbl,how)
                out = out..'\n'..out2
        elseif how=='colors' then
            out = 'add the color categories to the category-list...\n'..out
                --rtbl = mkCrewCategories(cattbl,how)
                --out2 = utils.dumpTable(rtbl)
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
    else
--        out = "Hello, world! - doing..."..what..utils.dumpTable(glbls.data)
        out = "Hello, world! - doing... "..tostring(what)..
                " ...using how... "..tostring(how)..
                " ...choosing which... "..tostring(which)..
                " ...as value... "..tostring(value).." ???\n\n\n"
    end
    return tostring( out )
end

return p

