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

local EventSeq = { 'eom', 'ad', 'is', 'eeq', 'ms', }  	-- events in sequence 1..5

local EventNames = { -- abbr to actual-names
                    eom = 'Empty of the Mind' ,
                    ad = 'Adrift' ,
                    is = 'Isolated Station' ,
                    eeq = 'Event-Equilibrium' ,
                    ms = 'Missing' ,
                    -- catchall-bad
                    'Unnamed Event' ,
                  }

local EventDates = { -- abbr to known-dates
                    eom = {
                    		'2017-01-11', 	'2017-04-05', 	'2017-07-19',
                    		'2017-11-01', 	'2018-02-07', 	'2018-04-04',
                    	} ,
                    ad = {
                    		'2016-11-23', 	'2017-04-26', 	'2017-08-09',
                    		'2017-12-13', 	'2018-02-21',
                    	} ,
                    is = {
                    		'2017-02-01', 	'2017-05-17', 	'2017-08-30',
                    		'2017-11-22', 	'2018-03-07',
                    	} ,
                    eeq = {
                    		'2017-02-22', 	'2017-06-07', 	'2017-09-20',
                    		'2018-01-03',
                    	} ,
                    ms = {
                    		'2017-03-15', 	'2017-06-28', 	'2017-10-11',
                    		'2018-01-24', 	'2018-03-21',
                    	} ,
                    'generic date = ccYY-MM-dd' ,
                  }

local function mkTable(inpT,hdrT,flgT)
	local retOut,inputTable,headerTable
	local dbgOut = ''
	local possFlags = { "flgClass", "flgAutoNumRows", }
	local dbgOut = '\n\n'
	dbgOut = dbgOut .. 'begin-dbgOut... \n\n'
	dbgOut = dbgOut .. 'flag-Table is \n\n'
	dbgOut = dbgOut .. utils.dumpTable(flgT) ..'\n\n'
	dbgOut = dbgOut .. 'header-Table is \n\n'
	dbgOut = dbgOut .. utils.dumpTable(hdrT) ..'\n\n'
	dbgOut = dbgOut .. 'input-Table is \n\n'
	dbgOut = dbgOut .. utils.dumpTable(inpT) ..'\n\n'
	dbgOut = dbgOut .. 'end-dbgOut... \n\n '
	retOut = mw.html.create('table')
	-- check and DO the flag-Table
	for _,flg in pairs(possFlags) do
		if flg == 'flgClass' then
			-- 'wikitable sortable'
			if utils.isNotBlank(flgT[flg]) then
				retOut:addClass(flgT[flg])
			else
				retOut:addClass('wikitable')
			end
		end
		if flg == 'flgAutoNumRows' then
			-- adjust inputTable, headerTable for first-column-numbering...
			if utils.isNotBlank(flgT[flg]) then
				headerTable = { "###"}
				utils.mergeTable(headerTable,hdrT)
			else
				headerTable = utils.tableShallowCopy(hdrT)
			end
		end
	end
	-- once flags are done, do the headers...
	-- once headers are done, do the actual rows...
	retOut:done()
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
    local out,holdstr
    local tempstr=''
    if what=='index' then
        out = mkIndex()
    elseif (what=='Events') or (what=='EventsDebug') then
		if what=='EventsDebug' then
			glbls.dbg = true
		end
		local iT,ht,fT
		fT = { flgClass='wikitable, sortable', flgAutoNumRows='true', }
		hT = { 'abbr', 'name', 'datesList', }
		iT = { 	{ 'ev9', 'event Nine', {'dt9', 'dt8', 'dt7',}, },
				{ 'ev4', 'event Four', {'dt2', 'dt3', 'dt4',}, },
				{ 'ev5', 'event Five', {'dt5', 'dt6', 'dt7',}, },
				{ 'ev1', 'event One', {'dt0', 'dt1', 'dt2',}, },
			}
        out = mkTable(iT,hT,fT)
    else
        out = "Hello, world! - doing..."..tostring(what)..
            "... with ==>"..utils.dumpTable(glbls.data)
    end
    return tostring( out )
end

return p

