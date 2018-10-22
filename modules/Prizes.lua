-- Module:Prizes
-- inside: [[Category:Modules]] using this line once...

-- <pre>

local p={}

local getargs = require('Dev:Arguments').getArgs
local utils = require('Module:Utilities')
local glbls = require('Module:Globals')
glbls.latest = false
-- non breaking space html entity is &nbsp;
-- non breaking hyphen html entity is &#8209;
glbls.space = '&nbsp;'
glbls.hyphen = '&#8209;'
glbls.usecommas = true
-- ugly...
glbls.useshortnames = false
glbls.usenbspnumbers = false

-- pixels
local NORMALSIZE = 25
local PrizePictures = { -- see discussion at: ???
                        a = 'Trophy-badges.png', 
                        c = 'Currency-coin.png', 
                        g = 'Currency-coins.png',        --gold, plural=pile
                        d = 'Currency-dilithium.png', 
                        x = 'Currency-dilithiums.png',   --xtal, plural=pile
                        b = 'Pack-blue.png',
                        i = 'Pack-blue2.png',            --Individual-pack
                        r = 'Pack-red.png',
                        s = 'Pack-red2.png',             --Some-pack
                        y = 'Pack-yellow.png',
                        t = 'Pack-yellow2.png',          --Ten-Pack
                        h = 'Repair-Health.png',
                        e = 'Repair-Health.png',        --energy
                        w = 'Repair-Wrench.png',
                        f = 'Repair-Wrench.png',        --fixup
                    }
local PrizeNames = {
                        a = 'Awards [trophy-badge]',
                        b = '1'..glbls.hyphen..'Pack [blue]',
                        c = 'Coins [gold]',
                        d = 'Dilithium [purple]',
                        --e = 'Health-crew [red-cross]',
                        e = 'Health-crew [red'..glbls.hyphen..'cross]',
                        f = 'FixUp-ship [wrench]',
                        g = 'Coins [gold]',
                        h = 'Health-crew [red'..glbls.hyphen..'cross]',
                        i = '1'..glbls.hyphen..'Pack [blue]',
                        r = '5'..glbls.hyphen..'Pack [red]',
                        s = '5'..glbls.hyphen..'Pack [red]',
                        t = '10'..glbls.hyphen..'Pack [yellow]',
                        w = 'FixUp-ship [wrench]',
                        x = 'Dilithium [purple]',
                        y = '10'..glbls.hyphen..'Pack [yellow]',
                    }
local PrizeNamesShort = {
                        a = 'awards',
                        b = 'blue'..glbls.hyphen..'packs',
                        c = 'coins',
                        d = 'dilithium',
                        e = 'heals',
                        f = 'repairs',
                        g = 'coins',
                        h = 'heals',
                        i = 'blue'..glbls.hyphen..'packs',
                        r = 'red'..glbls.hyphen..'packs',
                        s = 'red'..glbls.hyphen..'packs',
                        t = 'yellow'..glbls.hyphen..'packs',
                        w = 'repairs',
                        x = 'dilithium',
                        y = 'yellow'..glbls.hyphen..'packs',
                    }

local function chooseName(inChar)
    -- ugly hack, but wth...
    if glbls.useshortnames then
        return utils.chooseOne(inChar,PrizeNamesShort)
    else
        return utils.chooseOne(inChar,PrizeNames)
    end
end
local function choosePicture(inChar)
    -- make double-width icon for multi-packs...
    if inChar=='i' or inChar=='s' or inChar=='t' then
        NORMALSIZE = 2*NORMALSIZE
    end
    return utils.chooseOne(inChar,PrizePictures)
end
local function makeLink(item,size)
--    return '[[File:' ..item.. '|' ..size.. 'px|link= ]]'
    return '[[File:' ..item.. '|' ..size.. 'px|link=Currency ]]'
end

local function onePrize(args)
    local msg,retval
    local tempstr
    local namL,nam,num,pic
    msg = 'no prize chosen'
    namL = args[1]
    num = args[2]
    pic = args[3]
    -- fixup for lcFirst-only of name...
    nam = string.lower(string.sub(namL,1,1))
    if not nam then return msg end
        tempstr = tostring(chooseName(nam))
    if tempstr == 'nil' then
        msg = 'prize name is required >>'..nam..'<< is not valid'
        return msg
    else
        if not num then
            glbls.latest = true
--            retval = '(1) '..tempstr
            retval = '1 '..tempstr
        elseif utils.toNum(num) == 0 then
            msg = 'prize quantity is zero ? >>'..num..'<<'
            return msg
        else
            glbls.latest = true
            local nmbr = utils.toNum(num)
--            retval = '('..utils.toNum(num)..') '..tempstr
--            retval = tostring(utils.toNum(num))..tempstr
            -- assuming integers...
            if math.abs(nmbr) > 999 then
                if glbls.usecommas then
                    num = utils.comma_value(nmbr)
                end
            end
            if glbls.usenbspnumbers then
                retval = num..glbls.space..tempstr
            else
                retval = num..' '..tempstr
            end
        end
        if pic then
            glbls.latest = false
            tempstr = tostring(choosePicture(pic))
            if tempstr == 'nil' then
                msg = 'prize pic is invalid ? >>'..pic..'<<'
                return msg
            else
                glbls.latest = true
                --retval = retval..'  mklink-from:'..tempstr
                retval = retval..'  '..makeLink(tempstr,NORMALSIZE)
            end
        end
        return retval
    end
end




local function listOfPrizes(args)
--    return 'args are :' .. utils.dumpTable(args)
    local numLoops = #args/2  -- known integral from caller...
    local subargs = {}
    local tempstr, retval
    local substrs = {}
        for i = 1,numLoops do
            subargs[1] = args[2*(i-1)+1]
            subargs[2] = args[2*(i-1)+2]
            tempstr = onePrize(subargs)
--            if utils.stringStarts(tempstr,'(') then
            if glbls.latest then
                substrs[#substrs+1] = tempstr
            else
                retval = 'ERROR: listOfPrizes : loop#'..tostring(i)
                retval = retval..' args were '..utils.dumpTable(subargs)
                return retval
            end
        end
    if #substrs == 1 then
        retval = substrs[1]
    elseif #substrs == 2 then
        retval = substrs[1]..' and '..substrs[2]
    else
        retval = substrs[1]
        for i = 2,#substrs-1 do
            retval = retval..', '..substrs[i]
        end
        retval = retval..', and '..substrs[#substrs]
    end
    return retval
end




function p._main(frame)
    -- this cleans up outside calls to assuming either
    -- 2-at-a-time argument pairs (for prizeList) or
    -- 3-at-a-time possible-arguments (for prizes)...
    local a
    a = utils.tableShallowCopy(getargs(frame))
    if #a == 0 then 
--        return 'bad argument list'
        return false
    else
        glbls.args = a
        glbls.latest = false
        return true
    end
end



function p.prize(frame)
    local retval = 'invalid call to prize: '
    glbls.latest = false
    glbls.usecommas = true
    if not p._main(frame) then
        retval = retval..'zero arguments passed'
        return retval
    end
    return onePrize(glbls.args)
end

function p.prizeList(frame)
    local retval = 'invalid call to prizeList: '
    glbls.latest = false
    glbls.usecommas = false
    glbls.useshortnames = true
    glbls.usenbspnumbers = true
    if not p._main(frame) then
        retval = retval..'zero arguments passed'
        return retval
    end
    local a = glbls.args
    if (#a > 2) and ((#a % 2) == 0) then
        return listOfPrizes(a)
    elseif (#a == 2) then
        return onePrize(a)
    else
        retval = retval..'prizeLists must be in name,number pairs'
        return retval
    end
end


return p

