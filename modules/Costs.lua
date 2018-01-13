-- <pre>
-- module:costs - create easily-callable cost-tables...

local p = {}

local tablebuilder = require("Dev:Tablebuilder")
local getargs = require("Dev:Arguments").getArgs
local util = require("Module:Utilities")
local glbls = require("Module:Globals")


local function mkLevelCostsByIncr(sl,el,sc,ic)
    -- start-level, end-level (increment=1)
    -- start-cost, incremental-cost
    -- return array with level-#, cost-vals
    local diffLevels = el - sl + 1
    local arrLevels, arrCosts, retTbl
    arrLevels = p._costs(sl,1,diffLevels)
    arrCosts = p._costs(sc,ic,diffLevels)
    retTbl[1] = { sl, sc }
    for i = 1,#arrLevels do
        retTbl[i] = { arrLevels[i], arrCosts[i] }
    end
    return retTbl
end

local function mkLevelCostsComplete(ctbl)
--    local startLevelNames = { slvl1,
end



local function doChoice(ctbl,how)
--    return 'tadah...'..ctbl['name']..' doing '..how
    local hasGoodLevelData
end


-- function added late-in-the-game for catching cases...
local function isGoodCostKey(k, chkvalid)
    local retval
    local ispossible, isvalid
    local possibleCosts = { 't1c', 't2c', 't3c', 't4c',
                            't1s', 't2s', 't3s', 't4s', }
    local validCosts = {    true,  true,  true,  false,
                            true,  false,  false, false, }
--                            true,  true,  false, false, }
    assert ( #possibleCosts == #validCosts )
    ispossible = false
    if type(k) ~= 'string' then retval = false end
    for i = 1,#possibleCosts do
        if k == possibleCosts[i] then
            ispossible = true
            isvalid = validCosts[i]
        end
    end
    retval = ispossible
    if ispossible then
        if util.isSimpleTrue(chkvalid) then
            retval = isvalid
        end
    end
    return retval
end

local function loadCosts(dataName)
    local noError, data = pcall( mw.loadData, 'Module:Costs/data')
    if noError then
        local chkName
        if (dataName == 'All') then
            -- note: All costs should be in-order as a sequence...
            return data
        end
        if isGoodCostKey(dataName) then
            chkName = data[dataName]
            if chkName then
                return chkName
            end
        -- not trying to trap this-error (badHeroKey)... for now...
        end
    end
    -- error( data )
    return nil;
end



function p._costs(beg,incr,e)
    --assert(type(beg) == "number", "_costs expects a number")
    assert(type(beg) == "number")
    assert(type(incr) == "number")
    assert(type(e) == "number")
    -- beginning-cost, incremental-cost, number-of-increments
    -- return array of costs
    local arr = {}
    arr[1] = beg
    for i = 2,e do
        arr[#arr+1] = arr[#arr] + incr
    end
    return arr
end
function p._sums(beg, incr, e)
    --assert(type(beg) == "number", "_costs expects a number")
    assert(type(beg) == "number")
    assert(type(incr) == "number")
    assert(type(e) == "number")
    local arr = {}
    arr[1] = {beg, beg}  -- begin-val, begin-sum
    for i = 2, (e) do
        sum = arr[#arr][2]
        cur = arr[#arr][1] + incr
        arr[#arr+1] = {cur, sum + cur}
    end
    return arr
end


function p._dilithium(s)
    assert(type(s)=='string', 'bad call to _dilithium()')
    if s == 't1c' then
        -- starts 1    ends 50
        --arr = p._costs(100,25,1+50-1)
        return p._sums(100,25,1+50-1)
        -- chkd (mccoy)+ refunds(75,0)
        -- final refund(50=3750)
    elseif s == 't1s' then
        -- ship matches crew !!!
        -- starts 1    ends 50
        return p._sums(100,25,1+50-1)
        -- lvl8-9 = 275
        -- chkd(1-3) + refunds(75,0)
        -- chkd (9=275) + refunds(8=600,...)
        -- final refund(50=3750)

    elseif s == 't2c' then
        -- starts 10   ends 95
        --arr = p._costs(75,25,1+95-10)
        return p._sums(75,25,1+95-10)
        -- chkd (...) + refunds(125,0)
        -- unk (13=125) + refunds(12=375,...) 2@125
        -- chkd (15=175) + refunds(14=625,...) 2@125
        -- chkd (17=225) + refunds(16=875,...) 2@125
        -- chkd (19=275) + refunds(18=1125,...) 2@125
        -- chkd (21=325) + refunds(20=1375,...) ??? 5@125
        -- tbd??? (26=450) + refunds(25=2000,...)

    elseif s == 't3c' then
        -- starts 40   ends 165
        --return p._costs(50,25,1+165-40)
        return p._sums(50,25,1+165-40)
        -- unk (43=100) + refunds(42=750)
        -- chkd?? (gorn)+ refunds(250,0)

    elseif s == 'TESTtest' then
        -- starts 1   ends 3
        --arr = p._costs(20,5,1+3-1)
        return p._sums(20,5,1+3-1)

    end
    assert(true,'fell thru _dilithium()')
end


function p.dilithium(frame)
    local a = getargs(frame)
    local arr, tbl, retval
    local _, c, s
    local what = a[1]
    local how = a[2]

    --if true then return 'what is '..what..' and how is '..tostring(how) end

    retval = nil

    if not what or what == '' then
        retval = 'nothing ventured, nothing gained...'
        --return 'nothing ventured, nothing gained...'
        --return blanktable()
    end

    tbl = {'t1c', 't2c', 't3c', 't1s', 'TESTtest', }  -- known sequences...
    local tbloffset = {false, 10-1, 40-1, false, 'TESTtest', }
    for _, c in ipairs(tbl) do
        s = tbloffset[_]
        if c == what then
            arr = p._dilithium(what)
            if not how or how == '' then
                retval = util.dumpSimpleList(arr)
            elseif how == 'fancy' then
                local bign = 999
                -- really hacking issues here but NEED 40  in tbloffset ???
                local stroffrow = '(level'
                if s then
                    stroffrow = stroffrow..'+'..tostring(s)
                end
                stroffrow = stroffrow..'),  '
                --for: no-gaps, mklinks
                --retval = util.dumpSimpleList(arr, 51, true)
                --for: no-gaps, no-mklinks, yes-ordered, header
                --local strhead = '(level), [1]=cost-for-upgrade , [2]=total-cost-so-far'
                local strhead = stroffrow..'[1]=cost-for-upgrade , [2]=total-cost-so-far'
                retval = util.dumpSimpleList(arr, bign, false, true, strhead)
            else
                retval = 'i dont know how to do the how called '..how
            end
        end
    end

    -- EARLY RETURN !!!
    if retval then return retval end
    --if true then return 'what is '..what..' and how is '..tostring(how) end

--crew
    if what == 't4c' then
        return p._costs(100,100,245)

--ships
    elseif what == 't2s' then
        -- ship matches crew !!!
        -- starts 10   ends 95
        return p._costs(75,45,1+95-10)
        -- lvl12-13 = 165
            -- unk (11=75) 90/2 + refunds(10=125,...) 2@125      .1
        -- chkd (13=165) 90/2 + refunds(12=375,...) 2@125        1
        -- chkd (15=255) 85/2 + refunds(14=625,...) 2@125        2
        -- chkd (17=340) 285/9 + refunds(16=875,...) 9@125       3
            -- unk (17=340) 85/2 + refunds(16=875,...) 2@125    3?
            -- unk (19=425) 75/2 + refunds(18=1125,...) 2@125   4?
            -- unk (21=500) 125/5 + refunds(20=1375,...) 5@125  5?
        -- chkd (26=625) + refunds(25=2000,...)                  6

    elseif what == 't3s' then
        -- ship matches crew ???
        -- starts 40   ends 165 ???
        return p._costs(175,75,1+195-40)

    elseif what == 'calc' then
        --local beg = math.floor(tonumber(how))
        local beg = math.floor(tonumber(a[2]))
        local incr = math.floor(tonumber(a[3]))
        local maxlvl = math.floor(tonumber(a[4]))
            if beg < 0 then beg = 0 end
            if incr < 0 then incr = 0 end
            if maxlvl < 0 then maxlvl = 0 end
            return p._costs(beg,incr,maxlvl)
    else
        return 'a lot of effort for naught...'
    end
end


-- need to decide stuff...

function p.main(frame)
    local retval, msg
    local a = getargs(frame)
    local what = a[1]
    local which = a[2]
    local how = a[3]
    local ctbl

    -- retval = 'what='..tostring(what)..' and which='..tostring(which)

    -- reverse order so get what, if needed - else which...
    if not how or how == '' then
        --msg = 'choose HOW - s)ums or t)able or l)evel or d)iff...'
    --retval = msg
        retval = 'choose HOW - s)ums or t)able or l)evel or d)iff...'
    end
    if not which or which == '' then
        retval = 'choose WHICH - A)ll or t)ier-#)1234-cs)crew/ship...'
    end
    if not what or what == '' then
        retval = 'choose WHAT - d)ilithium or c)oins...'
    end

    -- this first-load clears everything into the system...  for second-loads...
    ctbl = loadCosts('All',true)

    if not retval then
        -- t2s is currently not-valid, but yes-data
        ctbl = loadCosts(which,true)
        --ctbl = loadCosts(which)

        --return 'ctbl='..tostring(ctbl)..' type='..type(ctbl) end

        if not ctbl then
            retval = 'unable to load data for which='..which
        else
            if msg then
                retval = util.dumpTable(ctbl)
            else
                retval = doChoice(ctbl,how)
            end
        end
    end

    return retval
--]]
end



return p

