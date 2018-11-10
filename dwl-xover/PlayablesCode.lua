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
--glbls.debug = true
--glbls.debug = false

function p.hello()
	return 'Hello, world!'
end

local function isGoodKey(k)
	local allKeys,found
--	if k==nil then return false end
	if k==nil then return 'nil' end
--	if not glbls.keysLoaded then return false end
	if not glbls.keysLoaded then return 'keyLd' end
	found = false
	if glbls.data[k] then
		found = true
	else
		found = false
	end
	return found
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
	glbls.doctors = utils.tableShallowCopy(idxDocs)
	glbls.allies = utils.tableShallowCopy(idxAllys)
	return true	
end

function p.isGoodKey(frame)
	local dora,k
	--if not p._main(frame) then return 'main' end
	if not p._main(frame) then return false end
	-- catch these before fake-frame passing for GLBLsorc...
	k = glbls.args[1]
	--dora = glbls.args[1]
	--k = glbls.args[2]
	--if not p.passGLBLsorc(frame) then return false end
	--if not loadDataNow() then return 'load' end
	if not loadDataNow() then return false end
	return isGoodKey(k)
	--return utils.dumpTable(glbls.args)
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
	local a,dora,mKey
	local tempStr
	if not p._main(frame) then
        retval = retval..'zero arguments passed'
        return retval
	end
	a = glbls.args
	dora = a[1]
	mKey = a[2]
	if mKey then 
		--retval = 'main ok: '..tostring(mKey)
		retval = 'main ok: '
		if loadDataNow() then
			retval = retval..utils.dumpTable(glbls.doctors)
			--retval = retval..utils.dumpTable(glbls.allies)
		end
	else
		retval = tostring(dora)
	end
	return retval
end


return p

