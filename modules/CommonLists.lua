-- commonlists module
-- inside: [[Category:Modules]] using this line once...
-- has all the functions that will operate on/about crew/ships

-- trying to make html-tables for index, navbox, etc...
-- <pre>

local p = {}
-- see: http://stackoverflow.com/questions/13964764/lua-how-to-avoid-circular-requires?noredirect=1&lq=1
--local cc = cc or require('Module:Charactercodes')

local comns = comns or require('Module:CommonCodes')
local getargs = getargs or require('Dev:Arguments').getArgs
local glbls = require('Module:Globals')
local gems = gems or require('Module:Gems')
local utils = utils or require('Module:Utilities')

-- semi-dummy statement because 'out' is going to hold the final html-object...
glbls.out = true

-- these are only one-level-down possibles...  not all possibilities in cc.expand()...
local possibles = { 'name',     'image',    'imagecaption',
                    'aliases',  'govt',
                    'series',   'xnpc',     'sdate',
                    'aenu',     'tier',     'igp',
                    'lmin',     'lmax',     'limit',
                    'hp',       'nup',
                    'ar',       'ag',       'aw',
                    'code',     'key',      'currentlevel',
                  }
local defaultOrder = { 'key', 'image', 'name', 'aliases',
                        'code', 'tier', 'series', 'hp', }
glbls.choices = defaultOrder
glbls.sorc = 'x'
glbls.data = {}

local function getTablefromKey(k,tblNm)
	-- having brain-farts whether to return true/false or msgs...
    local fake = {}
    local retmsg='getTable-fail'
    local retval,retTBL
    -- set SorC before this call...
	fake[1]=glbls.sorc
	fake[2]=tostring(k)
	fake[3]=tostring(tblNm)
	retval=comns.passTBL(fake)
	if not retval or retval ~= 'false' then
		retTBL = utils.JSONdecodeString2Table(retval)
		retmsg = true
	else
		return retmsg
	end
	glbls.data = utils.tableShallowCopy(retTBL)
    return retval
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


local function loadCrewOne(k,chosens)
    local fakeFrame = {}
    local getvals,chkreadargs
    local rtbl = {}
		fakeFrame[1] = k
        rtbl.key = k
--[[
        if not chosens then chosens = possibles end
        if type(chosens)~='table' then chosens = possibles end
		for _,c in ipairs(chosens) do
		    fakeFrame[2] = c
		    chkreadargs = cc.expand(fakeFrame)
		    if isGoodExpansion(chkreadargs) then
	            rtbl[c] = tostring(chkreadargs)
	        end
        end
--]]
    return rtbl
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


local function addRow( crew, cols )
	-- Init
	local row = mw.html.create('tr')
	local defaultCols = { 'key', 'image', 'aliases', }

    if not cols then
        usecols = glbls.choices
    else
        usecols = chooseCols(cols)
    end

	for _,c in ipairs(usecols) do
		if c=='key' then
			row
				:css('text-align','center;')
                :tag('td'):wikitext(crew.key):done()
		end
	end

	return row
end



local function mkRow(k,cols)
    local newrow, chkvals
    local crew = loadCrewOne(k)
        crew.key = k
        chkvals = chkCrew(crew)
		newrow = addRow( chkvals, cols )
    return newrow
end


local function mkIndex0()
	local fakeFrame = {}
	local retval
		-- main | s | full | keylist
		--fakeFrame[1] = 'main'
		fakeFrame[1] = glbls.sorc
		fakeFrame[2] = 'full'
		fakeFrame[3] = 'keylist'
		retval = comns.main(fakeFrame)
    return retval
end

local function mkCount0()
	local fakeFrame = {}
	local retval
		-- main | s | full | keycount
		--fakeFrame[1] = 'main'
		fakeFrame[1] = glbls.sorc
		fakeFrame[2] = 'full'
		fakeFrame[3] = 'keycount'
		retval = tonumber(comns.main(fakeFrame))
    return retval
end

local function mkIndex(k)
	local fakeFrame = {}
	local retval,tempStr,keysEnc,allKeys
		-- first loadup the glbl-tbls...
		fakeFrame[1] = glbls.sorc
		fakeFrame[2] = 'full'
		fakeFrame[3] = 'keyTbl'
		tempStr = comns.main(fakeFrame)
		-- hacky decode of the JSON...
		-- use rest-of-string after-equal-sign...
		keysEnc = utils.splitStrPat(tempStr,'=+')
		allKeys = utils.JSONdecodeString2Table(keysEnc[#keysEnc])
		retval = utils.dumpTable(allKeys)
		--retval = utils.dumpTable(glbls.keys)  NOGOOD...
    local r  -- to hold extra nodes/rows
    glbls.out = mw.html.create('table'):addClass('wikitable sortable')
    r = addHeader()
    glbls.out:node(r)  -- adds a child-node of (row) to current-instance (table)
    for _,key in ipairs(allKeys) do
		r = mkRow(key)
		glbls.out:node(r)
    end
    r = addHeader()
    glbls.out:node(r)
    return glbls.out
end

local function loadCrewSkillsBegin(k)
	-- bring in full skills-table for key-k...
    local fakeFrame = {}
    local getvals,chkreadargs
    local tempStr
    local rtbl = {}
    -- string holds ENcoded, glbls.data holds table, sorc predone
	tempStr = getTablefromKey(k,'skills')
	--rtbl = utils.tableShallowCopy(glbls.data)
	local basics = {'skill','color','cost',}
	--local basics = {'skill','color','cost','desc',}
		for i = 1,3 do
			rtbl[i] = {}
			for _,c in ipairs(basics) do
				tempStr = c..tostring(i)
				rtbl[i][c] = glbls.data[tempStr]
			end
			-- remove empty-skills
			if utils.tblFullSize(rtbl[i]) == 0 then
				rtbl[i] = nil
			end
		end
--]]
	return rtbl
end

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

local function loadCrewSkillsEnd(k,begtbl)
	local fakeFrame = {}
	local getStr,retval
	local rtbl = {}
	fakeFrame[1]=glbls.sorc
	fakeFrame[2]=tostring(k)
		for sk,_ in ipairs(begtbl) do
			rtbl[sk] = {}
			fakeFrame[3]=sk
			--local defCost = begtbl[sk]['cost']
			for up = 1,5 do
				rtbl[sk][up] = {}
				getStr = 'desc'
				fakeFrame[4]=getStr
				fakeFrame[5]=up
				-- this forces all skill-upgrades to provide a 'desc' field !!!
				retval = comns.SkFt(fakeFrame)
					rtbl[sk][up][getStr] = retval
				getStr = 'cost'
				fakeFrame[4]=getStr
				retval = comns.SkFt(fakeFrame)
					rtbl[sk][up][getStr] = retval
			end
		end
	return rtbl
--    return 'main-fail'
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
--    return 'main-fail'
end


function p._main(frame)
    -- this cleans up outside (or INside) calls for args
    local a
    a = utils.tableShallowCopy(getargs(frame))
    if #a == 0 then return false end
    glbls.args = a
    return true
end

function p.main(frame)
    local retval = 'invalid call to CommonLists-main: '
    local a,sorc,mKey,mItem
    local ok,tempStr
    if not p._main(frame) then
        retval = retval..'zero arguments passed'
        return retval
    end
    a = glbls.args
	sorc = a[1]
    ok,tempStr = checkSorC(sorc)
    if ok then
		glbls.sorc = tempStr
		glbls.args[1] = tempStr  -- bypass REchecking later...
	else
		return 'invalid sorc-value >>'..tostring(sorc)..'<<'
	end
    --mKey = a[2]
    --mItem = a[3]
    local what = a[2]
    local how = a[3]
    local which = a[4]
    local value = a[5]
    local out
	if what=='index' then
		out = mkIndex()
	elseif what=='index0' then
		out = mkIndex0()
	elseif what=='count0' then
		out = mkCount0()
    elseif (what=='testSkills') or (what=='skills') then
		local begtbl = loadCrewSkillsBegin(how)
		local endtbl = loadCrewSkillsEnd(how,begtbl)
		if what=='skills' then
			out = mkTableSkills(begtbl,endtbl)
		else
			out = utils.dumpTable(begtbl)
			out = out..'\n\n'..utils.dumpTable(endtbl)
		end
	else
--        out = "Hello, world! - doing..."..what..utils.dumpTable(glbls.data)
        out = "Hello, world! - for... "..tostring(sorc)..
				" doing... "..tostring(what)..
                " ...using how... "..tostring(how)..
                " ...choosing which... "..tostring(which)..
                " ...as value... "..tostring(value).." ???\n\n\n"
    end
    return tostring( out )
end

return p

