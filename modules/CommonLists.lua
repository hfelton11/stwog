-- commonlists module
-- inside: [[Category:Modules]] using this line once...
-- has all the functions that will operate on/about crew/ships

-- trying to make html-tables for index, navbox, etc...
-- <pre>

local p = {}

local comns = comns or require('Module:CommonCodes')
local getargs = getargs or require('Dev:Arguments').getArgs
local glbls = require('Module:Globals')
local gems = gems or require('Module:Gems')
local utils = utils or require('Module:Utilities')

--local Mcc = Mcc or require('Module:Charactercodes')
--local McL = McL or require('Module:CharacterLists')
--local Mss = Mss or require('Module:Starshipcodes')
--local MsL = MsL or require('Module:StarshipLists')

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
-- data gets rewritten often (used for mkIndex-fcn)
-- 		might be list_of_keys
--		or table_of_all_data
--		or table_of_current_key_data
glbls.data = {}
-- chkTbl was used for main-myList-fcn
glbls.chkTbl = {}
-- used in mkIndex-fcn...
glbls.keys = {}

-- since TWILIGHT means no-new-info, can hard-code these two lists...
-- however, these are just the dumpTable() strings - NOT the tables...
local currentCrewKeysString = '{ [1] = AH,[2] = AK,[3] = AM,[4] = ANU,[5] = AP,[6] = AR,[7] = ASP,[8] = AV,[9] = AWR,[10] = B1,[11] = B2,[12] = B3,[13] = B4,[14] = BA,[15] = BD,[16] = BE,[17] = BRU,[18] = CA,[19] = CAV,[20] = CBC,[21] = CCP,[22] = CDA,[23] = CDR,[24] = CDT,[25] = CHS,[26] = CHT,[27] = CK,[28] = CLF,[29] = CLM,[30] = CMS,[31] = CNU,[32] = CP,[33] = CPC,[34] = CR,[35] = CT,[36] = CWF,[37] = CWR,[38] = DA,[39] = DBC,[40] = DE,[41] = DLM,[42] = DM,[43] = EK,[44] = EMS,[45] = GLF,[46] = HE,[47] = HO,[48] = HS,[49] = HV,[50] = IN,[51] = KG,[52] = KN,[53] = KO,[54] = KOR,[55] = KU,[56] = KY,[57] = LB,[58] = LD,[59] = LE,[60] = LF,[61] = LOP,[62] = LPC,[63] = MEL,[64] = MS,[65] = NL,[66] = NO,[67] = NU,[68] = NVZ,[69] = OP,[70] = PC,[71] = PG,[72] = PP,[73] = QQ,[74] = RU,[75] = SF,[76] = SG,[77] = SP,[78] = SS,[79] = SV,[80] = SWF,[81] = TA,[82] = TE,[83] = TH,[84] = TK,[85] = TK50,[86] = TN,[87] = TO,[88] = TR,[89] = TT,[90] = TV,[91] = TYD,[92] = TYL,[93] = TYM,[94] = TZZ,[95] = VE,[96] = WC,[97] = WF,[98] = WS,}'
local currentShipKeysString = '{ [1] = ANT,[2] = BC1,[3] = BC2,[4] = BR,[5] = CG,[6] = CH,[7] = EN,[8] = ENA,[9] = ENB,[10] = END,[11] = FDM,[12] = HOZ,[13] = KBP,[14] = KD5,[15] = KEB,[16] = KKT,[17] = KNV,[18] = KR,[19] = KV,[20] = RBP,[21] = RD7,[22] = RDD,[23] = REL,[24] = RS,[25] = RV7,[26] = RVD,[27] = SGZ,[28] = THC,[29] = TS,[30] = VA,[31] = VDK,[32] = VTM, }'

-- this is the table-i-want for saying "CK is lvl-50, AK is lvl-95"
-- needed to figure out JSON encoding using either two-separate-arrays
--		>>["CK","AK"]<<  and  >>[50,95]<<  or one valued-table
--		>>{"CK":50,"AK":95}<<  where numbers do-not-need-quotes
--	and arrays use square-brackets and value-tables use curly-braces...
local junk = {CK=50,AK=95,}

-- technically these are just arrays so can use ipairs()...
local currentCrewKeys = {"AH","AK","AM","ANU","AP","AR","ASP","AV","AWR","B1","B2","B3","B4","BA","BD","BE","BRU","CA","CAV","CBC","CCP","CDA","CDR","CDT","CHS","CHT","CK","CLF","CLM","CMS","CNU","CP","CPC","CR","CT","CWF","CWR","DA","DBC","DE","DLM","DM","EK","EMS","GLF","HE","HO","HS","HV","IN","KG","KN","KO","KOR","KU","KY","LB","LD","LE","LF","LOP","LPC","MEL","MS","NL","NO","NU","NVZ","OP","PC","PG","PP","QQ","RU","SF","SG","SP","SS","SV","SWF","TA","TE","TH","TK","TK50","TN","TO","TR","TT","TV","TYD","TYL","TYM","TZZ","VE","WC","WF","WS",}
local currentShipKeys = {"ANT","BC1","BC2","BR","CG","CH","EN","ENA","ENB","END","FDM","HOZ","KBP","KD5","KEB","KKT","KNV","KR","KV","RBP","RD7","RDD","REL","RS","RV7","RVD","SGZ","THC","TS","VA","VDK","VTM",}

local function getTablefromKey(k,tblNm)
	-- having brain-farts whether to return true/false or msgs...
    local fake = {}
    local retmsg='getTable-fail'
    local retval,retTBL
    -- set SorC before this call...
	fake[1]=glbls.sorc
	fake[2]=tostring(k)
	if not tblNm then
		--retval='Get FullKey...'
		retval = comns.getFullKey(fake)
		retTBL = utils.JSONdecodeString2Table(retval)
		if type(retTBL) ~= 'table' then
			retTBL = {}
			retTBL["key"]=k
		end
		glbls.data = utils.tableShallowCopy(retTBL)
	    return retval  -- early
	end
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
		--usecols = chooseCols(cols)
		usecols = cols
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


local function isValidEvol(val)
	local retval=false
	local nEv=utils.toNum(val,9999)
	if utils.isBlank(val) then
		retval = true
	else
		local possEV = {9999,3,9,10,15}
		for _,v in pairs(possEV) do
			if nEv == v then retval = true end
		end
	end
	return retval
end


local function matchKeys2Values(inStr)
	local chkStr,chkTbl
	local mkTbl,rettbl
	local retstr=''
	local cntr
	chkTbl = utils.tableShallowCopy(glbls.chkTbl)
	--if type(chkTbl) ~= 'table' then return 'bad inTbl?' end
	chkStr = string.upper(tostring(inStr))
	mkTbl = utils.JSONdecodeString2Table(chkStr)
	rettbl = {}
	cntr = utils.tblFullSize(chkTbl)
	if #mkTbl ~= cntr then return false end  -- early
	-- now, just hand-merge the tables...
	for k,idx in pairs(chkTbl) do
		rettbl[k] = mkTbl[idx]
	end
	glbls.chkTbl = utils.tableShallowCopy(rettbl)
	retstr = utils.dumpTable(rettbl)
--[[
	retstr = retstr..tostring(cntr)..utils.dumpTable(rettbl)
	retstr = 'YAY'
--]]
	return retstr
end


local function chooseSubTbl(inStr)
	local chkStr,chkTbl
	local mkTbl,rettbl
	local retstr=''
	local cntr=0
	chkTbl = utils.tableShallowCopy(glbls.chkTbl)
	if type(chkTbl) ~= 'table' then return 'bad inTbl?' end
	--if glbls.sorc == 'c' then inTbl = currentCrewKeys end
	--if glbls.sorc == 's' then inTbl = currentShipKeys end
	chkStr = string.upper(tostring(inStr))
	mkTbl = utils.JSONdecodeString2Table(chkStr)
	rettbl = {}
	if type(mkTbl) == 'table' then
		for _,gdKey in ipairs(chkTbl) do
			if type(gdKey) == 'string' then
			for k,v in pairs(mkTbl) do
				if tostring(k)==gdKey then
					--retstr = 'KV: found a Key in gdKey... '
					--retstr = retstr..'KK;'
					retstr = true
					-- mkTbl is in key/level pairs, so copy...
					rettbl[k]=v
				end
				if tostring(v)==gdKey then
					--retstr = 'KO: found a Value in gdKey... '
					retstr = retstr..'KV;'
					cntr=cntr+1
					-- mkTbl is most-likely just an array of keys...
					if type(k)=='number' then
						rettbl[gdKey]=k
					else
						--retstr = retstr..'BUT dont understand structure...'
						retstr = retstr..'err|'
					end
				end
			end  -- loop input-table
			end  -- if-string
		end  -- loop good-key-list
	else
		retstr = false
	end
	--if #rettbl > 0 then
	if utils.tblFullSize(rettbl) > 0 then
		--glbls.data = utils.tableShallowCopy(rettbl)
		glbls.chkTbl = utils.tableShallowCopy(rettbl)
		--glbls.chkTbl = utils.tableShallowCopy(junk)
		--retstr = 'YAY'
	end
--[[
	retstr = retstr..tostring(cntr)..utils.dumpTable(rettbl)
--	retstr = 'YAY'
--]]
	return retstr
end


local function chooseOldNew(inStr)
	local chkStr,chkTbl
	local useTOS,useTNG
	local retstr,rettbl
	chkStr = string.upper(tostring(inStr))
	chkTbl = utils.tableShallowCopy(glbls.chkTbl)
	if string.find(chkStr,'O') then
		useTOS = true
	else
		useTOS = false
	end
	if string.find(chkStr,'N') then
		useTNG = true
	else
		useTNG = false
	end
	if useTOS and useTNG then
		retstr = ' ON '
		rettbl = utils.tableShallowCopy(chkTbl)
	elseif useTOS then
		retstr = ' O '
		rettbl = {'needs work to choose O...',}
	elseif useTNG then
		retstr = ' N '
		rettbl = {'needs work to choose N...',}
	else
		retstr = false
		rettbl = {'nothing-chosen...',}
	end
	glbls.chkTbl = utils.tableShallowCopy(rettbl)
	return retstr
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
	-- bring in full skills-table for key-k...
	local fakeFrame = {}
	local getvals,chkreadargs
	local tempStr
	local rtbl = {}
    -- string holds encoding, glbls.data holds FULL table, sorc predone
	tempStr = getTablefromKey(k)
	--rtbl = utils.tableShallowCopy(glbls.data)
	rtbl = utils.JSONdecodeString2Table(tempStr)
	if rtbl.key ~= k then return false end   -- early...
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
	-- cannot pass back tables ?
--    return rtbl
    return tempStr
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
		-- this should double-check the table...
		-- usecols = chooseCols(cols)
		usecols = cols
    end

	for _,c in ipairs(usecols) do
		if c=='key' then
			row
				:css('text-align','center;')
                :tag('td'):wikitext(crew.key):done()
        elseif c=='series' then
            row
                :tag('td'):wikitext(crew.series):done()
        elseif c=='hp' then
            row
                :tag('td'):wikitext(crew.hp):done()
        elseif c=='tier' then
            row
                :tag('td'):wikitext(crew.tier):done()
        else
            row
                :tag('td'):wikitext('other'):done()
        end
	end

	return row
end



local function mkRow(k,cols)
	local newrow, chkvals, chkcols
	local crew
	local dummy = loadCrewOne(k)
	-- retval is stupid string, table is at glbls.data
	local chkvals
		-- hardcoded for now...
		chkcols = {"key","tier","name",}
		if not dummy then
			-- false passback is bad...
			newrow = addHeader(chkcols)
			return newrow   -- early
		else
			crew = utils.tableShallowCopy(glbls.data)
			chkvals = chkCrew(crew)
		end
--[[
		-- fill this in...
		if not cols then
			-- weird nil passthru...
			chkcols = cols
		elseif type(cols) == 'table' then
			local dummy=true
			-- should do real chk against possibles...
		else
			-- this is normally the ELSE-case for a valid-table...
			-- i.e. what i hard-coded above as new-defaults...
		end
--]]
		newrow = addRow( chkvals, chkcols )
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
local function mkIndex_N(n)
	local fakeFrame = {}
	local retval
		-- main | s | full | keylist
		--fakeFrame[1] = 'main'
		fakeFrame[1] = glbls.sorc
		fakeFrame[2] = 'select'
		fakeFrame[3] = 'keylist'
		fakeFrame[4] = 'tier'
		fakeFrame[5] = tostring(n)
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
local function mkCount_N(n)
	local fakeFrame = {}
	local retval
		fakeFrame[1] = glbls.sorc
		fakeFrame[2] = 'select'
		fakeFrame[3] = 'keycount'
		fakeFrame[4] = 'tier'
		fakeFrame[5] = tostring(n)
		retval = tonumber(comns.main(fakeFrame))
    return retval
end

local function mkIndex(k)
	local fakeFrame = {}
	local retval,tempStr,keysEnc,allKeys
		-- first loadup the glbl-tbls...
		fakeFrame[1] = glbls.sorc
		fakeFrame[2] = 'full'
		fakeFrame[3] = 'keylist'
		tempStr = comns.main(fakeFrame)
		if not tempStr then return tempStr end
		--       -- hacky decode of the JSON...
		--       -- use rest-of-string after-equal-sign...
		--       keysEnc = utils.splitStrPat(tempStr,'=+')
		--       allKeys = utils.JSONdecodeString2Table(keysEnc[#keysEnc])
		allKeys = utils.JSONdecodeString2Table(tempStr)
		glbls.keys = utils.tableShallowCopy(allKeys)
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
	--if type(allKeys) ~= 'table' then return 'ERROR...' end
	--return retval
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

local function makeEvolutions(key)
	local LvlNms = {'50','95','96','165',}
	local OKitems = {'name','series','tier',}
	local beg,mid,tr,sl,nl
	local ok,retstr
	local tempstr,mKey
		mKey = tostring(key)
			-- string is JUNK, glbls.data holds table, sorc predone
			tempStr = getTablefromKey(mKey,nil)
		beg = '* [['
		mid = string.upper(glbls.sorc)
		mid = mid..string.sub(glbls.data['series'],2,2)  -- tNg or tOs
		-- sigh...
		beg = beg..mid
		tr = tonumber( string.sub(glbls.data['tier'],1,1) )  -- shorten 3.5 to 3
		sl = '/'
		nl = ']] \n\n'
		--retstr = beg..sl..mid..sl..mKey..nl
		retstr = ''
		if tr == 1  then
			tempstr = beg..sl..'L50'..sl..mKey..nl
			retstr = retstr..tempstr
		elseif tr == 2  then
			tempstr = beg..sl..'L50'..sl..mKey..nl
			retstr = retstr..tempstr
			tempstr = beg..sl..'L95'..sl..mKey..nl
			retstr = retstr..tempstr
		elseif tr == 3 then
			tempstr = beg..sl..'L50'..sl..mKey..nl
			retstr = retstr..tempstr
			tempstr = beg..sl..'L96'..sl..mKey..nl
			retstr = retstr..tempstr
			tempstr = beg..sl..'L165'..sl..mKey..nl
			retstr = retstr..tempstr
		else
			retstr = false
		end
	return retstr
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
    local dummy = a[6]
    local out
    local capNi,capNc
    capNi=string.match(what,'index(%d+)')
    capNc=string.match(what,'count(%d+)')
    -- subtle, the captures (if worked) will return TRUEs
	if what=='index' then
		-- eventually pass more stuff like chooseCols, etc...
		out = mkIndex()
	elseif capNi then
		if capNi == '0' then
			out = mkIndex0()
		else
			-- replace obscure side-case of 4==3.5
			if capNi == '4' then
				out = mkIndex_N(3.5)
			else
				out = mkIndex_N(capNi)
			end
		end
	elseif capNc then
		if capNc == '0' then
			out = mkCount0()
		else
			-- replace obscure side-case of 4==3.5
			if capNc == '4' then
				out = mkCount_N(3.5)
			else
				out = mkCount_N(capNc)
			end
		end
    elseif (what=='testSkills') or (what=='skills') then
		local begtbl = loadCrewSkillsBegin(how)
		local endtbl = loadCrewSkillsEnd(how,begtbl)
		if what=='skills' then
			out = mkTableSkills(begtbl,endtbl)
		else
			out = utils.dumpTable(begtbl)
			out = out..'\n\n'..utils.dumpTable(endtbl)
		end
    elseif (what=='dbgMyList') or (what=='MyList') then
		local dbgstr = 'CommonLists-MyList:'
		local junk = dbgstr..' FAIL: '
		local ok = false
		local tOstNg
		local enTbl
		local tbdVals
		local fullTbl = {}
			if what=='dbgMyList' then ok = true end
			-- rather than hard-coded, could use comns.main(full,keylist)
			if glbls.sorc == 'c' then fullTbl = currentCrewKeys end
			if glbls.sorc == 's' then fullTbl = currentShipKeys end
		if how then
			local tmpVal
			--tOstNg = tostring(how)
			-- ugly, but modify table in chooseOldNew (if nec.)
				glbls.chkTbl = utils.tableShallowCopy(fullTbl)
				tmpVal = chooseOldNew(how)
				if not tmpVal then return junk..'ON' end  -- early...
				tOstNg = tmpVal
				ok = true
			elseif ok then
				tOstNg = 'xxx ON xxx;'
			else
				tOstNg = junk..'tOstNg '
		end
		if which and ok then
			local tmpVal
				enTbl = tostring(which)
				tmpVal = chooseSubTbl(which)
				if not tmpVal then return junk..'TBL' end  -- early...
				enTbl = tmpVal  -- stupid, just for printing...
				if tmpVal == true then
					-- Full-KK key-value info already provided...
					ok = false
					enTbl = '--- enTbl ---'
				else
					ok = true
				end
			elseif ok then
				enTbl = 'xxx enTbl xxx;'
			else
				ok = false
				enTbl = junk..'enTbl '
		end
		if value and ok then
			local tmpVal
				tbdVals = 'HI...'..tostring(value)
				tmpVal = matchKeys2Values(value)
				if not tmpVal then return junk..'val-TBL' end  -- early...
				tbdVals = tmpVal  -- more stupid printing...
				ok = true
			elseif ok then
				tbdVals = 'xxx tbdVals xxx'..' assuming all items are Level 0'
				--tbdVals = 'xxx tbdVals xxx'..utils.dumpTable(glbls.chkTbl)
				--tbdVals = 'xxx tbdVals xxx'..utils.JSONencodeTable2String(glbls.chkTbl)
			else
				ok = false
				tbdVals = junk..'tbdVals '
		end
		if what=='MyList' then
			--out = dbgstr..tOstNg..enTbl..tbdVals..'\n\n* '
			--out = out..utils.dumpTable(glbls.chkTbl)
			out = utils.dumpTable(glbls.chkTbl)..'\n\n* '
		else
			--out = dbgstr..tOstNg..enTbl..tbdVals
			out = dbgstr..'prt-'..glbls.sorc
			out = out..'\n\n*'..utils.JSONencodeTable2String(fullTbl)
		end
--[[
--]]
    elseif (what=='dbgEVLnks') or (what=='EVLnks') then
		local dbgstr = 'CommonLists-EVLnks:'
		local junk = dbgstr..' FAIL: '
		local retstr = makeEvolutions(how)
		-- either pass a string - or nil/false
		if not retstr then return junk end  -- early...
		if what=='EVLnks' then
			out = tostring(retstr)
		else
			out = dbgstr..'nothing to debug...'
		end
	    out = tostring(retstr)
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

