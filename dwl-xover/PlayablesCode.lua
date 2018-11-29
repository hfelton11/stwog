-- playablesCode module

-- <pre>

local p = {}
local getargs = getargs or require('Dev:Arguments').getArgs

local utils = {}
function utils.tableShallowCopy(obj)
	-- see: https://gist.github.com/tylerneylon/81333721109155b2d244
	-- does not work with meta-tables or recursive-tables...
	if type(obj) ~= 'table' then return obj end
	-- local res = setmetatable({}, getmetatable(obj))
	local res = {}
	for k, v in pairs(obj) do res[utils.tableShallowCopy(k)] = utils.tableShallowCopy(v) end
	return res
end
function utils.dumpTable(o)
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
				if type(k) ~= 'number' then k = '"'..k..'"' end
				s = s .. '['..k..'] = ' .. utils.dumpTable(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end


local glbls = {}
glbls.filename = 'Module:Playables/data'
glbls.keysLoaded = false
glbls.data = {}
glbls.args = {'junk',}
glbls.doctors = {}
glbls.allies = {}
glbls.dora = 'x'
glbls.item = {}
--glbls.debug = true
--glbls.debug = false

function p.hello()
	return 'Hello, world!'
end

local function glblsSet(k,v)
	-- assert(type(k)=='string')
	if type(k) ~= 'string' then return false end
	glbls[k] = utils.tableShallowCopy(v)
	return true
end

local function isGoodDorA(inDA)
	local retval=false
	local locDA=string.lower(inDA)
	if string.len(locDA) ~= 1 then return false end
	if locDA == 'd' or locDA == 'a' then
		retval = glblsSet('dora',locDA)
	end
	return retval
end

local function isGoodCode(c)
	local retval=false
	local numC= tonumber(c)
	local tblChoice
	if glbls.dora == 'd' then
		tblChoice = glbls.data['Doctor']
	end
	if glbls.dora == 'a' then
		tblChoice = glbls.data['Ally']
	end
	if not numC then return false end -- early...
	if tblChoice.base <= numC and numC <= tblChoice.last then
		--retval = true
		retval = numC
	end
	return retval
end

local function isGoodKey(k)
	local allKeys,found
	if k==nil then return false end
	--if k==nil then return 'nil' end
	if not glbls.keysLoaded then return false end
	--if not glbls.keysLoaded then return 'keyLd' end
	found = false
	-- technically this covers first-level TABLES, not indiv. keys
	if glbls.data[k] then
		found = true
	else
		found = false
	end
	-- this assumes DorA is preset elsewhere...
	if not found then
		if glbls.dora == 'd' then
			for _,doc in ipairs(glbls.doctors) do
				if k==doc then
					found = true
				end
			end
		end
		if glbls.dora == 'a' then
			for _,ally in ipairs(glbls.allies) do
				if k==ally then
					found = true
				end
			end
		end
	end
	if found then
		local passTbl = {}
		passTbl['name'] = k
		passTbl['code'] = 0
		glblsSet('item',passTbl)
	end
	return found
end

local function getCode(k)
	local retval
	local codeTbl={}
--	if k==nil then return false end
--	if not glbls.keysLoaded then return false end
	if not isGoodKey(k) then return 'no-code' end
	if glbls.dora == 'd' then
		codeTbl=glbls.data.AllDoctors
	end
	if glbls.dora == 'a' then
		codeTbl=glbls.data.AllAllies
	end
	-- magic begin-value (assumed working)
	retval=codeTbl.Emptyend
	for item,code in pairs(codeTbl) do
		if k==item then
			retval = code
		end
	end
	return retval
end


local function loadDataNow()
	local fn,alldata,k
	local allDocs,allAllys
	local idxDocs,idxAllys
	fn = glbls.filename
	alldata = mw.loadData(fn)
	glbls.data = utils.tableShallowCopy(alldata)
	--
	allDocs = {}
	allAllys = {}
	idxDocs = {}
	idxAllys = {}
	-- magically know the sub-tables...  sigh...
	for k,_ in pairs(alldata.AllDoctors) do
		-- flush the silly color-ending-values...
		if not string.find(k, "..end$") then
			idxDocs[#idxDocs+1] = k
		end
	end
	for k,_ in pairs(alldata.AllAllies) do
		if not string.find(k, "..end$") then
			idxAllys[#idxAllys+1] = k
		end
	end
	if #idxAllys and #idxDocs then
		glbls.keysLoaded = true
	end
	-- inplace alphabetical-sort
	table.sort(idxDocs)
	table.sort(idxAllys)
	glbls.doctors = utils.tableShallowCopy(idxDocs)
	glbls.allies = utils.tableShallowCopy(idxAllys)
	return true
end

function p.isGoodKey(frame)
	local dora,k
	--if not p._main(frame) then return 'main' end
	if not p._main(frame) then return false end
	-- catch these before fake-frame passing for GLBLsorc...
	--k = glbls.args[1]
	dora = glbls.args[1]
	k = glbls.args[2]
	--if not p.passGLBLsorc(frame) then return false end
	--if not loadDataNow() then return 'load' end
	if not loadDataNow() then return false end
	if isGoodDorA(dora) then
		return isGoodKey(k)
	else
		return isGoodKey(dora)
	end
	--return utils.dumpTable(glbls.args)
end

function p.passGLBL(frame)
    local what,whatval,a
    local retval = false
    if not p._main(frame) then return retval end
    a = glbls.args
    if #a ~= 2 then return retval end
-- no other error checks here...
    what = a[1]
    whatval = a[2]
    glbls[what] = whatval
    retval = 'glbls.'..what..'='..whatval
--    retval = true
    return retval
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
	local retval = 'invalid call to PlayablesCode-main: '
	local a,dora,what,mKey
	local tempStr
	if not p._main(frame) then
        retval = retval..'zero arguments passed'
        return retval
	end
	a = glbls.args
	dora = a[1]
	if not isGoodDorA(dora) then
		retval = tostring(dora)
		return retval   -- early
	end
	what = a[2]
	if what then
		retval = 'main ok: '
		retval = retval .. 'DorA=' .. string.upper(glbls.dora) .. ' : '
		--retval = 'main ok: '..tostring(mKey)
		if not loadDataNow() then
			retval = retval..'ERROR loading data...'
			return retval   -- early
		end
	end
	if string.lower(what)=='dump' then
		if glbls.dora == 'd' then
			retval = retval..utils.dumpTable(glbls.doctors)
		elseif glbls.dora == 'a' then
			retval = retval..utils.dumpTable(glbls.allies)
		else
			retval 'ERROR impossible try/catch dora...'
		end
		return retval  -- early
	end
	which = a[3]
	if isGoodKey(which) then
		local code = getCode(which)
		local gdWhat = false
		glbls.item.code = code
		retval = retval .. 'mKey=>>>'..tostring(which)..'<<< : '
		if string.lower(what)=='code' then
			retval = retval .. 'code=' .. tostring(code)
			gdWhat = true
		end
		if string.lower(what)=='decode' then
			retval = retval .. 'tbd...'
			gdWhat = true
		end
		if not gdWhat then
			retval = retval .. 'what='..what..' means ???'
		end
	elseif which then
		local retKey = isGoodCode(which)
		local tmpStr = ''
		local gdWhat = false
		if retKey then
			tmpStr = tmpStr .. 'mKey=>>>'..tostring(retKey)..'<<< : '
			tmpStr = tmpStr .. 'from CODE='..tostring(which)..' : '
		end
		if string.lower(what)=='colors' then
			tmpStr = tmpStr .. 'colors=>>>' .. '<<< : tbd...'
			gdWhat = true
		end
		if not gdWhat then
			retval = retval..'what='..what..',which='..which
		else
			retval = retval..tmpStr
		end
	else
		retval = retval..what
	end
	return retval
end


return p

