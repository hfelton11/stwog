-- eventdates module
-- inside: [[Category:Modules]] using this line once...
-- replaces the template_event-text-01 (limit of 9-ish dates)
-- also is the central holding place for when each event occurred...

-- <pre>

local p = {}
local getargs = getargs or require('Dev:Arguments').getArgs
local utils = utils or require('Module:Utilities')
local glbls = require('Module:Globals')

-- semi-dummy statement because 'out' is going to hold the final html-object...
glbls.out = true
glbls.data = {}
glbls.dbg = false

-- local EventSeq = { 'eom', 'ad', 'is', 'eeq', 'ms', }  	-- events in sequence 1..5
local EventSeq = { 'eom', 'ad', 'vi', 'is', 'eeq', 'ms', }  	-- events in sequence 1..6

local EventNames = { -- abbr to actual-names
                    eom = 'Empty of the Mind' ,
                    ad = 'Adrift' ,
                    vi = 'Virus' ,
                    is = 'Isolated Station' ,
                    eeq = 'Event-Equilibrium' ,
                    ms = 'Missing' ,
                    -- catchall-bad (numeric-key vs. alphabetic)
                    'Unnamed Event' ,
                  }

local EventDates = { -- abbr to known-dates
                    eom = {
                    		'2017-01-11', 	'2017-04-05', 	'2017-07-19',
                    		'2017-11-01', 	'2018-02-07', 	'2018-04-04',
                    		'2018-06-27',
                    	} ,
                    ad = {
                    		'2016-11-23', 	'2017-04-26', 	'2017-08-09',
                    		'2017-12-13', 	'2018-02-21', 	'2018-05-02',
                    		'2018-08-08',
                    	} ,
                    vi = {
                    		'2018-05-16',	'2018-07-11',
                    	} ,
                    is = {
                    		'2017-02-01', 	'2017-05-17', 	'2017-08-30',
                    		'2017-11-22', 	'2018-03-07', 	'2018-04-18',
                    		'2018-07-25',
                    	} ,
                    eeq = {
                    		'2017-02-22', 	'2017-06-07', 	'2017-09-20',
                    		'2018-01-03',   '2018-05-30',   '2018-08-22',
                    	} ,
                    ms = {
                    		'2017-03-15', 	'2017-06-28', 	'2017-10-11',
                    		'2018-01-24',   '2018-03-21',   '2018-06-13',
                    		'2018-09-05',
                    	} ,
                    'generic date = ccYY-MM-dd' ,
                  }



local function mkTable(inpT,hdrT,flgT)
	local retOut,inputTable,headerTable
	local rowHdr,rowDat
	local miniTbl = {}
	local chkHdrs
	local hdrSzs = { 10, 30, 50, }
	local possFlags = { "flgClass", "flgAutoNumRows", "flgHeaderDetails", }
	local dbgOut = '\n\n'

	retOut = mw.html.create('table')
	retOut:attr( 'border', '1')

	-- check and DO the flag-Table
	for _,flg in ipairs(possFlags) do
		if flg == 'flgClass' then
			-- override class for options like 'wikitable sortable'
			if utils.isNotBlank(flgT[flg]) then
				retOut:addClass(flgT[flg])
			else
				retOut:addClass('articletable')
			end
		end
		if flg == 'flgHeaderDetails' then
			-- only deal with one-item...
			if utils.isNotBlank(flgT[flg]) then
				chkHdrs=true
				table.insert(hdrSzs,1,10)
			else
				chkHdrs=false
			end
		end
		if flg == 'flgAutoNumRows' then
			-- adjust headerTable for first-column-numbering...
			if utils.isNotBlank(flgT[flg]) then
				local nr = 0
				table.insert(hdrT,1,"###")
			-- THEN adjust inputTable for first-column-numbering...
				-- require inpT to have UNnamed rows of table-data...
				for k,v in ipairs(inpT) do
					nr = nr + 1
					table.insert(v,1,nr)
					miniTbl[k] = utils.tableShallowCopy(v)
				end
				-- overwrite original...
				inpT = miniTbl
			end
		end
	end
	headerTable = utils.tableShallowCopy(hdrT)
	inputTable = utils.tableShallowCopy(inpT)

	-- once flags are done, do the headers...
	if glbls.dbg then
	dbgOut = '\n\n'
	dbgOut = dbgOut .. 'begin-dbgOut... \n\n'
	dbgOut = dbgOut .. 'flag-Table is \n\n'
	dbgOut = dbgOut .. utils.dumpTable(flgT) ..'\n\n'
	dbgOut = dbgOut .. 'header-Table is \n\n'
	dbgOut = dbgOut .. utils.dumpTable(hdrT) ..'\n\n'
	dbgOut = dbgOut .. 'hdrSzs-Table is \n\n'
	dbgOut = dbgOut .. utils.dumpTable(hdrSzs) ..'\n\n'
	dbgOut = dbgOut .. 'input-Table is \n\n'
	dbgOut = dbgOut .. utils.dumpTable(inpT) ..'\n\n'
	dbgOut = dbgOut .. 'end-dbgOut... \n\n '
	end
	-- HeaderDetails include formatting, sizing, etc. ???
	rowHdr = mw.html.create('tr')
	-- for _,hdr in ipairs(headerTable) do
	for hdr = 1, #headerTable do
		local FmtHdr
		FmtHdr = utils.TitleCase(headerTable[hdr])
		-- FmtHdr = hdr:upper()
		-- FmtHdr = hdr:lower()
		-- if i try to break-out the rowHdr props, it fails...
		if chkHdrs then
			rowHdr
				:tag('th')
				:wikitext(FmtHdr)
				:attr('scope','col')
				:css('width',tostring(hdrSzs[hdr])..'%')
				:done()
		else
			rowHdr
				:tag('th')
				:wikitext(FmtHdr)
				:attr('scope','col')
				-- :attr('data-sort-type','numeric')
				-- :css('width','50%')
				:done()
		end
	end
	retOut:node(rowHdr)
	-- once headers are done, do the actual rows...
	for k,v in ipairs(inputTable) do
		local subTbl, subStr
		if type(v) == 'table' then
			local rowDat = mw.html.create('tr')
			for dat = 1, #v do
				if type(v[dat]) == 'table' then
					subTbl = v[dat]
					subStr = utils.dumpTable(subTbl)
				else
					subStr = tostring(v[dat])
				end
				rowDat
					:tag('td')
					:wikitext(subStr)
					:done()
			end
			retOut:node(rowDat)
		end
	end
	retOut:node(rowHdr)
	-- retOut:done()
	-- returning...
	if not glbls.dbg then
		return retOut
	else
		return dbgOut
	end
end

local function mkIndex()
	local retstr = '\n'
--	for k,v in pairs(EventDates) do
	-- this runs in n-squared time...
	for i,a in ipairs(EventSeq) do
		for k,v in pairs(EventNames) do
			-- skip the unnamed-events...
			if type(k) == 'string' then
				if a==k then
					retstr = retstr..tostring(i)..' - '
					retstr = retstr..'[['..tostring(v)..']]'..'\n\n'
					retstr = retstr.. utils.dumpTableSorted(EventDates[k]) ..'\n\n'
				end
			end
		end
	end
    return retstr
end



--- hello-world to setup testcases correctly...
function p.main(frame)
    local a = getargs(frame)
    glbls.data = utils.tableShallowCopy(a)
    local what = a[1]
    local out,hold
    local tempstr=''
    if what=='index' then
        out = mkIndex()
    elseif what=='count0' then
        out = tostring(#EventSeq)
    elseif (what=='Events')
						or (what=='EventsDebug')
						or (what=='EventsAddRowNums') then
		if what=='EventsDebug' then
			glbls.dbg = true
		end
		local iT,hT,fT
		local junkStr
		if what=='EventsAddRowNums' then
			fT = { flgClass='wikitable, sortable', flgAutoNumRows='true', flgHeaderDetails='true',}
		else
		--	fT = {}
			fT = { flgClass='wikitable', flgHeaderDetails='true',}
		end
		hT = { 'abbr', 'name', 'datesList', }
		iT = {}
		for seq = 1,#EventSeq do
			local abr = EventSeq[seq]
			iT[seq] = { abr, EventNames[abr], EventDates[abr], }
		end
--		iT = { 	{ 'ev9', 'event Nine', {'dt9', 'dt8', 'dt7',}, },
--				{ 'ev4', 'event Four', {'dt2', 'dt3', 'dt4',}, },
--				{ 'ev5', 'event Five', {'dt5', 'dt6', 'dt7',}, },
--				{ 'ev1', 'event One', {'dt0', 'dt1', 'dt2',}, },
--			}
		out = mw.html.create()
		hold = mkTable(iT,hT,fT)
--		junkStr = addParagraph('junk Paragraph...')
--		out:node(junkStr)
--		out:node(junkStr)
		out:node(hold)
--		out:node(junkStr)
    else
        out = "Hello, world! - doing..."..tostring(what)..
            "... with ==>"..utils.dumpTable(glbls.data)
    end
    return tostring( out )
end

return p

