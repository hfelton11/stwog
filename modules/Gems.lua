-- inside: [[Category:Modules]] using this line once...

-- <pre>

local p={}

local getargs = require('Dev:Arguments').getArgs
local utils = require('Module:Utilities')

local GemColors = { -- crew-versions of gems
                    r = 'Red.png' ,
                    y = 'Yellow.png' ,
                    b = 'Blue.png' ,
                    w = 'White.png' ,
                    p = 'Purple.png' ,
                    o = 'Orange.png' ,
                    -- all/combined-gems is 5-colors
                    a = '5gem.png' ,
                    c = '5gem.png' ,
                    -- ship-versions of gems
                    -- (green-phasers/voltage, red-torpedos,
                    --  purple-purple/q-after-p, white-shields)
                    v = 'Green-ship.png' ,
                    t = 'Red-ship.png' ,
                    s = 'White-ship.png' ,
                    q = 'Purple-ship.png' ,
                    -- hidden-UNUSED
                    h = 'Hidden-Green.png' ,
                    -- catchall-bad
                    z = 'Stone.png' ,
                  }

local SMALLSIZE = 2
local NORMALSIZE = 25


local function chooseMany(order)
    -- assumes order is a normal text-string, containing so-so-inititals
    local a,c,d
    local msg1 = ''
    local colorList = {}
    local gemSizes = {}
        a = string.lower(order)
    for i=1,#order do
        c = string.sub(a,i,i)
        d = utils.chooseOne(c,GemColors)
        if not d then
            msg1 = msg1 .. 'Unknown Gem...>' ..c.. '<...\n'
            d = utils.chooseOne('z',GemColors)
            gemSizes[i]=SMALLSIZE
        else
            gemSizes[i]=NORMALSIZE
        end
        colorList[i]=d
    end
    return colorList,gemSizes
end

local function makeLink(color,size)
    return '[[File:' ..color.. '|' ..size.. 'px|link= ]]'
end
local function makeLinks2Path(str)
    -- HACK because i dont want to sort-out patterns and splitting...
    return string.gsub(str,'%[%[File%:','%/%[%[File%:')
end

local function getPositionLink(linkString,pos)
    -- assumes inputs are already 'perfect' string,number
    local s,retStr, retTbl
    s = makeLinks2Path(linkString)
    retTbl = utils.split_path(s)
    retStr = retTbl[pos]
    return retStr
end



function p.six(frame)
    local a,order,ct,st
    local retTbl = {}
    a = getargs(frame)
    order = a[1]
    if #order ~= 6 then return 'wrong length of color-list' end
    s = a[2]
    if not s then s = NORMALSIZE end
    ct,st = chooseMany(order)
    for i,v in ipairs(st) do
        if v == NORMALSIZE then
            -- allow override, if needed...
            table.insert(retTbl,i,makeLink(ct[i],s))
        else
            -- assuming tiny-return...
            table.insert(retTbl,i,makeLink(ct[i],st[i]))
        end
    end
    return table.concat(retTbl,' ')
end


function p.ordered(frame)
    local a,cc,order,pos
    local retStr = ''
    local msg0,msg1
    local miniFrame
    a = getargs(frame)
    order = a[1]
    -- dropping the position-arg so it doesnt adjust 'size' of icons
    miniFrame = { args={order,}, getParent = function ()
                local pargs = {order,} return {args=pargs} end
            }
    retStr = p.six(miniFrame)
    cc = string.sub(retStr,1,2)
    -- pass back errors...
    if cc ~= '[[' then return retStr end
    pos = a[2]
    if not pos then
        msg0 = 'Empty Position choice...>nil<...'
        else
        pos = tonumber(pos)
        if not pos or pos < 1 or pos > 6 then
            msg1 = 'Invalid Position...>' ..tostring(pos).. '<...'
        else
            return getPositionLink(retStr,pos)
        end
    end
    -- if we got here, then we 'could' print the msg...
    -- or we can make a horrible assumption...
    if msg0 or msg1 then
        return msg0 or msg1
--        return makeLink(chooseOne('z'),SMALLSIZE)
    else
        return 'Impossible to get here ?'
    end
end


function p.one(frame)
    local a,c,d,s
    local msg0,msg1
    a = getargs(frame)
    c = a[1]
    s = a[2]
    if not s then s = NORMALSIZE end
    if not c then
--        return 'Empty Gem choice...>nil<...'
        msg0 = 'Empty Gem choice...>nil<...'
    else
        c = mw.text.trim(c)
        c = string.lower(c)
        c = string.sub(c,1,1)
        d = utils.chooseOne(c,GemColors)
        if not d then
--            return 'Unknown Gem...>' ..c.. '<...'
            msg1 = 'Unknown Gem...>' ..c.. '<...'
        else
--            return 'Gem...>' ..c.. '<... is at ' ..d
--            return '[[File:' ..d.. '|25px|link= ]]'
--            return '[[File:' ..d.. '|' ..s.. 'px|link= ]]'
            return makeLink(d,s)
        end
    end
    -- if we got here, then we 'could' print the msg...
    -- or we can make a horrible assumption...
--    return msg0 or msg1
    if msg0 then
        return makeLink(utils.chooseOne('z',GemColors),SMALLSIZE)
    else
        return msg1
    end
end

return p

