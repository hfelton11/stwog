-- module:utilities
-- inside: [[Category:Modules]] using this line once...
-- <pre>

local p = {}
local ttools = require('Dev:TableTools')
local json = require('Dev:Json')
--local username = require('Dev:USERNAME')


local function tchelper( first, rest )
   return first:upper()..rest:lower()
end
function p.USERNAME()
    -- http://dev.wikia.com/wiki/Thread:13736
    -- http://templates.wikia.com/wiki/Template:USERNAME
    return ''
end
function p.TitleCase(str)
    -- normal-stuff didnt work correctly...  sigh
--    return string.gsub(str, "(%a)([%w_']*)", tchelper)
    local langobj = mw.language.new("en")
    return langobj:ucfirst(str)
end
function p.toNum(str,val)
    -- annoying issue with returning 'nil' values...
    -- note: 2,000 does NOT seem to return as a number...  sigh...
    local zero = tonumber("0")
    -- val is optional return-value in-place-of number-0
    if val then zero = val end
    if type(tonumber(str))=='number' then
        return tonumber(str)
    else
        return zero
    end
end
--[[
function p.toStr(str,defaultStr)
    -- annoying issue with returning 'nil' values...
    -- note: 2,000 does NOT seem to return as a number...  sigh...
    local zero = tonumber("0")
    -- val is optional return-value in-place-of number-0
    if val then zero = val end
    if type(tonumber(str))=='number' then
        return tonumber(str)
    else
        return zero
    end
end
--]]
function p.comma_value(n) -- credit http://richard.warburton.it
    -- to convert 2000 to 2,000 for numbers
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

-- rehash of ttools items that made-sense to me...
function p.isSequence(t)
    return ttools.isSequence(t)
end
function p.tblFullSize(t)
    return ttools.size(t)
end
-- see: http://wiki.garrysmod.com/page/table/Merge
-- i think the one i copied below p.mergeTableAlt() is equiv...
function p.mergeTable(dest,source)
    return ttools.merge(dest,source)
end
-- not sure i grok this one or some of the other un-added-here ones
-- so check: http://dev.wikia.com/wiki/Module:TableTools
function p.pack(...)
    return ttools.pack(...)
end

--rehash of json items for table-encoding/decoding...
function p.JSONdecodeString2Table(s)
    -- testString = [[ { "one":1 , "two":2, "primes":[2,3,5,7] } ]]
    -- decoded = json.decode(testString)
    -- table.foreach(decoded, print)
    -- print ("Primes are:")
    -- table.foreach(o.primes,print)
    -- one     1
    -- two     2
    -- primes      table: 0032B928
    -- Primes are:
    -- 1       2
    -- 2       3
    -- 3       5
    -- 4       7
    return json.decode(s)
end
function p.JSONencodeTable2String(t)
    -- print(json.encode({ 1, 2, 'fred', {first='mars',second='venus',third='earth'} }))
    -- [1,2,"fred", {"first":"mars","second":"venus","third"????"earth"}]
    return json.encode(t)
end


function p.isSimple(obj)
    local retval = false
    if type(obj) == 'string' then retval = true end
    if type(obj) == 'number' then retval = true end
    if type(obj) == 'boolean' then retval = true end
    return retval
end

function p.stringTrim(obj)
    local s
    local retval = obj
    if type(obj) == 'string' then
        -- horribly-crude hack...
        --retval = string.gsub(obj,' ','')
        --s = tostring(obj)
        -- see: http://lua-users.org/wiki/StringTrim
        -- this uses 'basic' trim1
        retval = string.gsub(obj,"^%s*(.-)%s*$", "%1")
        -- this uses trim6 (which is better performance...
        --retval = string.match(obj,'^()%s*$') and ''
          --      or string.match(obj,'^%s*(.*%S)')
    end
    return retval
end


function p.isNotBlank(obj)
    local retval = false
    if p.isSimple(obj) then
    --if p.isSimple(p.stringTrim(obj)) then
        if #(obj) > 0 then retval = true end
    end
    return retval
end
function p.isBlank(obj)
    return (not p.isNotBlank(obj))
end
function p.errBlank(obj,errStr)
    local replStr = 'ERROR'
    if type(errStr) == 'string' then
        replStr = errStr
    end
    if p.isBlank(obj) then
        return(replStr)
    else
        return tostring(obj)
    end
end


function p.isSimpleTrue(obj)
    local retval = false
    local notTrues = { false, 'false', 0, '0', '', 'no', }
    if p.isSimple(obj) then
        retval = true
        for i = 1,#notTrues do
            local sobj = string.lower(obj)
            if sobj == notTrues[i] then
                retval = false
            end
        end
    end
    return retval
end
function p.isSimpleBlank(obj)
    local retval = false
    if not p.isSimpleTrue(obj) then
        if obj=='' then
            retval = true
        end
    end
    return retval
end

function p.isWikiLink(obj)
    local begLnk = '%['
    local endLnk = '%]'
    local tempStr,inside,retval,retStr
    if not type(obj)=='string' then return false,'' end
        tempStr = p.stringTrim(obj)
        --hack
        if #tempStr > 4 then inside = string.sub(tempStr,3,#tempStr-2) end
        if tempStr[1]==begLnk and tempStr[2]==begLnk and
            tempStr[#tempStr]==endLnk and
            tempStr[#tempStr-1]==endLnk then
                retStr = p.errBlank(inside,'')
                retStr = 'HELO'
                retVal = true
        else
            retVal = false
            retStr = ''
        end
    return retVal,retStr
end


function p.tableShallowCopy(obj)
    -- see: https://gist.github.com/tylerneylon/81333721109155b2d244
    -- does not work with meta-tables or recursive-tables...
    if type(obj) ~= 'table' then return obj end
    -- local res = setmetatable({}, getmetatable(obj))
    local res = {}
    for k, v in pairs(obj) do res[p.tableShallowCopy(k)] = p.tableShallowCopy(v) end
    return res
end

function p.chooseOne(k,t)
    -- originally used this to pick an initial-letter from a dict...
    -- trying to keep this simple for the 'key'...
    if not p.isSimple(k) then return nil end
    -- trying to keep this simple for the 'table'...
    local tbl = p.tableShallowCopy(t)
    if type(tbl) == 'table' then
        for sk,sv in pairs(tbl) do
            if k == sk then return sv end
        end
    end
        return nil
end

function p.tableDeepCopy(obj) -- deep-copy a table
    -- see: https://gist.github.com/MihailJP/3931841
    -- or just use mw.clone(obj)
    if type(obj) ~= "table" then return obj end
    local meta = getmetatable(obj)
    local target = {}
    for k, v in pairs(obj) do
        if type(v) == "table" then
            target[k] = p.tableDeepCopy(v)
        else
            target[k] = v
        end
    end
    setmetatable(target, meta)
    return target
end


function p.dumpTable(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
                if type(k) ~= 'number' then k = '"'..k..'"' end
                s = s .. '['..k..'] = ' .. p.dumpTable(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end


function p.mergeTableAlt(t1,t2)
    -- sub-tables-in-2 are merged/overwrite onto subtables-in-1...
    -- see: http://stackoverflow.com/a/1283608/1411473
    assert(type(t1)=='table')
    assert(type(t2)=='table')
    for k, v in pairs(t2) do
        if (type(v) == "table")
        and (type(t1[k] or false) == "table") then
            p.mergeTableAlt(t1[k], t2[k])
        else
            t1[k] = v
        end
    end
    return t1
end


local function spairs(t, order)
    -- assumes a table with 'reasonable' keys...
    -- collect the keys  (to apply sorting)
    local keys = {}
	--for k in pairs(t) do keys[#keys+1] = k end
	for k in pairs(t) do table.insert(keys,k) end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end


function p.tableSort(o,iterSort)
	retTbl = {}
	retFcn = nil
	-- see: https://www.lua.org/pil/19.3.html  pairsByKeys()
    if (not iterSort) or (type(iterSort) ~= 'function') then
        if type(o) == 'table' then
			return spairs(o)
		else
			return retTbl,retFcn
		end
	else
        if type(o) == 'table' then
			return spairs(o,iterSort)
		end
		return retTbl,retFcn
	end
end

function p.dumpTableSorted(o, iterSort)
    if (not iterSort) or (type(iterSort) ~= 'function') then
        if type(o) == 'table' then
            local s = '{ '
            -- heres the sort-occurring call...
            -- assumes 'key-sort' for now, while i think-about-it...
            for k,v in spairs(o) do
                if type(k) ~= 'number' then k = '"'..k..'"' end
                s = s .. '['..k..'] = ' .. p.dumpTableSorted(v) .. ','
            end
            return s .. '} '
        else
            return tostring(o)
        end
        -- sort-by-table-value DEscending
        -- function(t,a,b) return t[b] < t[a] end
        -- sort-by-table-key AScending
        -- function(t,a,b) return a < b end
    else
        -- for now, lets assume that both table and sorter are ok...
            local s = '{ '
            -- heres the sort-occurring call...
            -- assumes 'key-sort' for now, while i think-about-it...
            for k,v in spairs(o,iterSort) do
                if type(k) ~= 'number' then k = '"'..k..'"' end
                s = s .. '['..k..'] = ' .. p.dumpTableSorted(v,iterSort) .. ','
            end
            return s .. '} '
    end
end

function p.dumpSimpleList(tbl,rowgaps,mklinks,mkordered,strhead)
    -- this assume the highest key-set is an indexable-array/list (even if multi-layered table)
    local d = {}
    local j
    local numRow = 5
    local listtype
    -- optional gaps in row listing...
    -- assumes response would be 'true'...
    if not p.isSimple(rowgaps) then
        j = numRow
    else
        if rowgaps == true then
            j = numRow
        elseif type(rowgaps) == 'number' then
            j = math.floor(rowgaps)
        else
            -- covers false also...
            j = math.huge
        end
    end
    if mkordered then
        listtype = '#'
    else
        listtype = '*'
    end
    -- when translated to wiki-page creates a list (bullets) of links (dbl-brackets) of key-items...
	for i = 1, #tbl do
	    -- sub-dumps...
	    local o = tbl[i]
	    local s = p.dumpTable(o)
--        d[#d+1] = '*[['..tbl[i]..']]'
--        d[#d+1] = '*[['..s..']]'
        if mklinks then
            -- like hero-table names...
            --d[#d+1] = '*[['..s..']]'
            d[#d+1] = listtype..'[['..s..']]'
        else
            -- just simple bullet-list...
            --d[#d+1] = '*'..s
            d[#d+1] = listtype..s
        end
        if (i % j) == 0 then
            --d[#d+1] = '* --(' ..i.. ')--'
            d[#d+1] = listtype..' --(' ..i.. ')--'
        end
    end
    -- outside-loop...
        -- if called with '* {{#invoke...' this prints header...
        -- or called with '# ...'
        if strhead and type(strhead) == 'string' then
            table.insert(d,1,'HEADER==>'..strhead)
            --d[1] = strhead
        end
    return table.concat(d, '\n')
end

function p.stringStarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end
function p.stringEnds(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end
-- see: http://lua-users.org/wiki/SplitJoin
-- Compatibility: Lua-5.1
function p.splitStrPat(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end
function p.split_path(str)
   return p.splitStrPat(str,'[\\/]+')
end

-- see: http://stackoverflow.com/questions/8695378/how-to-sum-a-table-of-numbers-in-lua
-- namely: table.reduce( {1, 2, 3}, function (a, b) return a + b end)
function p.tableReduce(seqTable, fn)
    -- BEWARE - no type-checking !!!
    local acc
    for k, v in ipairs(seqTable) do
        if 1 == k then
            acc = v
        else
            acc = fn(acc, v)
        end
    end
    return acc
end


return p

