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

local EventSeq = { eom, ad, is, eeq, ms, }  	-- events in sequence 1..5

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
                    		'2017-11-01', 	'2018-02-07', 
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
                    		'2018-01-24', 
                    	} ,
                    'generic date = ccYY-MM-dd' ,
                  }



local function mkIndex()
	local retstr = ''
	for k,v in pairs(EventNames) do
		-- skip the unnamed-events...
		if v then retstr = retstr..'[['..str(v)..']]\n' end
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
    elseif (what=='Story') or (what=='Storyline') then
        out = ''
    else
        out = "Hello, world! - doing..."..tostring(what)..
            "... with ==>"..utils.dumpTable(glbls.data)
    end
    return tostring( out )
end

return p

