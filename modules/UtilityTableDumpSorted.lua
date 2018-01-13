-- module:utilityTableDumpSorted
-- inside: [[Category:Modules]] using this line once...

-- see: http://lua-users.org/wiki/SortedIteration newbie...

local p = {}

local glbls = require('Module:Globals')
local dumpTable = require('Module:Utilities').dumpTable

--glbls.stack = {}

--[[
local function newStack ()
    return {""}   -- starts with an empty string
end
local function addString (stack, s)
    table.insert(stack, s)    -- push 's' into the the stack
    for i=table.getn(stack)-1, 1, -1 do
        if string.len(stack[i]) > string.len(stack[i+1]) then
            break
        end
        stack[i] = stack[i] .. table.remove(stack)
    end
end

-- see: http://www.lua.org/pil/12.1.1.html
local function serialize (o)
    local retStr = ''
    if type(o) == "number" then
        --io.write(o)
        retStr = retStr .. o
    elseif type(o) == "string" then
        --io.write(string.format("%q", o))
        retStr = retStr .. string.format("%q", o)
        --retStr = retStr .. tostring(o)
    elseif type(o) == "table" then
        --io.write("{\n")
        --retStr = retStr .. "{\n"
        retStr = retStr .. "{"
        for k,v in pairs(o) do
            --io.write("  ", k, " = ")
            --retStr = retStr .."  "..k.." = "
            retStr = retStr .. "["
            serialize(k)
            retStr = retStr .. "]="
            serialize(v)
            --io.write(",\n")
            retStr = retStr .. ", "
            --retStr = retStr .. ",\n"
        end
        --io.write("}\n")
        --retStr = retStr .. "}\n"
        retStr = retStr .. "} "
    else
        error("cannot serialize a " .. type(o))
    end
    return retStr
end
local function LogInit()
--    mw.clearLogBuffer()
--    mw.log('')
--    glbls.ReturnString = ''
--    glbls.stack = newStack()
--    table.insert(glbls.stack, '' )
--    table.insert(glbls.stack, serialize('') )
--    glbls.stack = {'',}
    glbls.stack = {}
--    local junk = nil
end
local function LogAdd(s)
    -- s is assumed string...
--    addString( glbls.stack, s ..'\n' )
--    addString( glbls.stack, s )
--    table.insert(glbls.stack, s )
    table.insert(glbls.stack, serialize(s) )
end
local function LogPrint()
    --return(tostring( glbls.stack ))
    -- add a blank final-newline...
    local retStr = ''
--    LogAdd('')
    retStr = table.concat(glbls.stack,'\n')
    return retStr
end

--]]

--[[
glbls.ReturnString = newStack()
glbls.PrintString = addString(glbls.ReturnString,
--]]

--------------------------------------
-- Insert value of any type into array
--------------------------------------
local function arrayInsert( ary, val, idx )
    -- Needed because table.insert has issues
    -- An "array" is a table indexed by sequential
    -- positive integers (no empty slots)
    local lastUsed = #ary + 1
    local nextAvail = lastUsed + 1

    -- Determine correct index value
    local index = tonumber(idx) -- Don't use idx after this line!
    if (index == nil) or (index > nextAvail) then
        index = nextAvail
    elseif (index < 1) then
        index = 1
    end

    -- Insert the value
    if ary[index] == nil then
        ary[index] = val
    else
        -- TBD: Should we try to allow for skipped indices?
        for j = nextAvail,index,-1 do
            ary[j] = ary[j-1]
        end
        ary[index] = val
    end
end

--------------------------------
-- Compare two items of any type
--------------------------------
local function compareAnyTypes( op1, op2 ) -- Return the comparison result
    -- Inspired by http://lua-users.org/wiki/SortedIteration
    local type1, type2 = type(op1),     type(op2)
    local num1,  num2  = tonumber(op1), tonumber(op2)

    if ( num1 ~= nil) and (num2 ~= nil) then  -- Number or numeric string
        return  num1 < num2                     -- Numeric compare
    elseif type1 ~= type2 then                -- Different types
        return type1 < type2                    -- String compare of type name
    -- From here on, types are known to match (need only single compare)
    elseif type1 == "string"  then            -- Non-numeric string
        return op1 < op2                        -- Default compare
    elseif type1 == "boolean" then
        return op1                              -- No compare needed!
         -- Handled above: number, string, boolean
    else -- What's left:   function, table, thread, userdata
        return tostring(op1) < tostring(op2)  -- String representation
    end
end

-------------------------------------------
-- Iterate over a table in sorted key order
-------------------------------------------
local function pairsByKeys (tbl, func)
    -- Inspired by http://www.lua.org/pil/19.3.html
    -- and http://lua-users.org/wiki/SortedIteration

    if func == nil then
        func = compareAnyTypes
    end

    -- Build a sorted array of the keys from the passed table
    -- Use an insertion sort, since table.sort fails on non-numeric keys
    local ary = {}
    local lastUsed = 0
    for key --[[, val--]] in pairs(tbl) do
        if (lastUsed == 0) then
            ary[1] = key
        else
            local done = false
            for j=1,lastUsed do  -- Do an insertion sort
                if (func(key, ary[j]) == true) then
                    arrayInsert( ary, key, j )
                    done = true
                    break
                end
            end
            if (done == false) then
                ary[lastUsed + 1] = key
            end
        end
        lastUsed = lastUsed + 1
    end

    -- Define (and return) the iterator function
    local i = 0                -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if ary[i] == nil then
            return nil
        else
            return ary[i], tbl[ary[i]]
        end
    end
    return iter
end

---[[
--For testing, here's a generic table pretty-printer:
---------------------------------------------
-- Return indentation string for passed level
---------------------------------------------
local function tabs(i)
    return string.rep(".",i).." "   -- Dots followed by a space
end
--]]

-----------------------------------------------------------
-- Return string representation of parameter's value & type
-----------------------------------------------------------
local function toStrType(t)
    return serialize(t)
end
local function toStrTypeOrig(t)
    local function fttu2hex(t) -- Grab hex value from tostring() output
        local str = tostring(t);
        if str == nil then
            return "tostring() failure! \n"
        else
            local str2 = string.match(str,"[ :][ (](%x+)")
            if str2 == nil then
                return "string.match() failure: "..str.."\n"
            else
                return "0x"..str2
            end
        end
    end
    -- Stringify a value of a given type using a table of functions keyed
    -- by the name of the type (Lua's version of C's switch() statement).
    local stringify = {
        -- Keys are all possible strings that type() may return,
        -- per http://www.lua.org/manual/5.1/manual.html#pdf-type.
        ["nil"]			= function(v) return "nil (nil)"			    end,
        ["string"]		= function(v) return '"'..v..'" (string)'	    end,
        ["number"]		= function(v) return v.." (number)"			    end,
        ["boolean"]		= function(v) return tostring(v).." (boolean)"  end,
        ["function"]	= function(v) return fttu2hex(v).." (function)" end,
        ["table"]		= function(v) return fttu2hex(v).." (table)"	end,
        ["thread"]		= function(v) return fttu2hex(v).." (thread)"	end,
        ["userdata"]	= function(v) return fttu2hex(v).." (userdata)" end
    }
    return stringify[type(t)](t)
end

-------------------------------------
-- Count elements in the passed table
-------------------------------------
local function lenTable(t)		-- What Lua builtin does this simple thing?
    local n=0                   -- '#' doesn't work with mixed key types
    if ("table" == type(t)) then
        for key in pairs(t) do  -- Just count 'em
            n = n + 1
        end
        return n
    else
--        return nil
        return 0
    end
end

--------------------------------
-- Pretty-print the passed table
--------------------------------
local function do_dumptable(t, indent, seen)
    -- "seen" is an initially empty table used to track all tables
    -- that have been dumped so far.  No table is dumped twice.
    -- This also keeps the code from following self-referential loops,
    -- the need for which was found when first dumping "_G".
    --local retStr = ''
    if ("table" == type(t)) then	-- Dump passed table
        seen[t] = 1
        if (indent == 0) then
            --print ("The passed table has "..lenTable(t).." entries:")
            --mw.log("The passed table has "..lenTable(t).." entries:")
            LogAdd("The passed table has "..lenTable(t).." entries:")
            indent = 1
        end
        for f,v in pairsByKeys(t) do
            if ("table" == type(v)) and (seen[v] == nil) then    -- Recurse
                --print( tabs(indent)..toStrType(f).." has "..lenTable(v).." entries: {")
                --mw.log(tabs(indent)..toStrType(f).." has "..lenTable(v).." entries: {")
                LogAdd(tabs(indent)..toStrType(f).." has "..lenTable(v).." entries: {")
                do_dumptable(v, indent+1, seen)
                -- print( tabs(indent).."}" )
                --mw.log(tabs(indent).."}")
                LogAdd(tabs(indent).."}")
            else
                --print( tabs(indent)..toStrType(f).." = "..toStrType(v))
                --mw.log(tabs(indent)..toStrType(f).." = "..toStrType(v))
                LogAdd(tabs(indent)..toStrType(f).." = "..toStrType(v))
            end
        end
    else
        --print (tabs(indent).."Not a table!")
        --mw.log(tabs(indent).."Not a table!")
        --mw.log(tabs(indent)..toStrType(t))
        LogAdd(tabs(indent)..toStrType(t))
    end
--    glbls.ReturnString = glbls.ReturnString .. mw.getLogBuffer()
--    retStr = retStr .. ' ' .. mw.getLogBuffer() .. ' \n'
--    return retStr
    --return mw.getLogBuffer()
    LogAdd('')
--    return
end

--------------------------------
-- Wrapper to handle persistence
--------------------------------
function p.TableDumpSorted(t)   -- Only global declaration in the package
    -- This wrapper exists only to set the environment for the first run:
    -- The second param is the indentation level.
    -- The third param is the list of tables dumped during this call.
    -- Getting this list allocated and freed was a pain, and this
    -- wrapper was the best solution I came up with...
    LogInit()
    do_dumptable(t, 0, {})
    --return do_dumptable(t, 0, {})
    return LogPrint()
end

return p

