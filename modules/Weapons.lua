-- Module:Weapons
-- inside: [[Category:Modules]] using this line once...

-- <pre>

local p={}

local getargs = require('Dev:Arguments').getArgs
local utils = require('Module:Utilities')
local glbls = require('Module:Globals')

glbls.latest = true
--glbls.latest = false

glbls.skipIcon = false
--glbls.skipIcon = true
glbls.useErrorMsg = false
--glbls.useErrorMsg = true
glbls.usecommas = true

-- pixels
local NORMALSIZE = 25
local WeaponPictures = { -- see discussion at: ???
                    oaT = 'R3 tos federation photon torpedo.png',
                    oaP = 'G2 tos federation phaser.png',
                    oaS = 'S2 tos federation shield cell.png',
                    okT = 'R3 tos klingon plasma torpedo.png',
                    okP = 'G2 tos klingon laser.png',
                    okS = 'S2 tos klingon shield cell.png',
                    orT = 'R3 tos romulan quantum torpedo.png',
                    orP = 'G2 tos romulan phase cannon.png',
                    orS = 'S2 tos romulan shield cell.png',
                    ogP = 'G2 general laser.png',

                    naT = 'R3 tng federation gravimetric torpedoes.png',
                    naP = 'G2 tng federation phaser.png',
                    naS = 'S2 tng federation (NOT romulan) shield cell.png',
                    nkT = 'R3 tng klingon photon torpedo.png',
                    nkP = 'G2 tng klingon pulse cannon.png',
                    nkS = '',
                    nrT = 'R3 tng romulan spatial torpedo.png',
                    nrP = 'G2 tng romulan plasma cannon.png',
                    nrS = '',
                    ncT = 'R3 tng cardassian positron torpedo.png',
                    ncP = 'G2 tng cardassian disrupter.png',
                    ncS = 'S2 tng cardassian shield cells.png',
                    nbT = '',
                    nbP = '',
                    nbS = 'S2 tng borg (NOT klingon) shield cell.png',
                    nfT = '',
                    nfP = '',
                    nfS = '',
                    ngP = 'G2 general laser.png',
                    }
local WeaponNames = {
                    oaT = 'Photon Torpedoes',
                    oaP = 'Phasers',
                    oaS = 'Shield Cells (blue)',
                    okT = 'Plasma Torpedoes',
                    okP = 'Lasers',
                    okS = 'Shield Cells (red)',
                    orT = 'Quantum Torpedoes',
                    orP = 'Phase Cannons',
                    orS = 'Shield Cells (purple)',
                    ogP = 'Lasers',

                    naT = 'Gravimetric Torpedoes',
                    naP = 'Phasers',
                    naS = 'Shield Cells (green)',
                    nkT = 'Photon Torpedoes',
                    nkP = 'Pulse Cannons',
                    nkS = '',
                    nrT = 'Spatial Torpedoes',
                    nrP = 'Plasma Cannons',
                    nrS = '',
                    ncT = 'Positron Torpedoes',
                    ncP = 'Disrupter',
                    ncS = 'Shield Cells (pink)',
                    nbT = '',
                    nbP = '',
                    nbS = 'Shield Cells (red)',
                    nfT = '',
                    nfP = '',
                    nfS = '',
                    ngP = 'Lasers',
-- * +2 White LNK+NAME [[File:NAME|frameless|50px]]
                    }
local WeaponColor = { r='T', g='P', w='S', t='T', p='P', s='S', }
local WeaponSeries = { o='TOS', n='TNG', }
local WeaponGovt = {
                --a = 'alliedFederation',
                a = 'Federation',
                k = 'Klingon',
                r = 'Romulan',
                c = 'Cardassian',
                b = 'Borg',
                --f = 'Ferengi',
                f = 'Alien',
                g = 'tbd...',
            }





local function handleBlank(x,instead)
    return utils.errBlank(x,instead)
end
--[[
local function handleBlank(x,instead)
    local replStr = 'ERROR'
    if type(instead) == 'string' then
        replStr = instead
    end
    if utils.isBlank(x) then
        return(replStr)
    else
        return tostring(x)
    end
end
--]]
local function decodeThree(nc,skipIcon)
    -- 3 letters are TOS/TNG, Category-Govt, Weapon-Type
    -- return useful links with icon...
    local lnkStart = '[[Weapons]] [[:Category:'
    local tempStr,lnk,icon,series,retval,ncl,ncf
    ncl = string.lower(nc)
    series = handleBlank(WeaponSeries[string.sub(ncl,1,1)],'XXX')..' '
    tempStr = handleBlank(WeaponGovt[string.sub(ncl,2,2)],'Alien')
    lnk = lnkStart..tempStr..'|'..tempStr..']] '
    -- recreating nc for final-lookup..
    tempStr = handleBlank(WeaponColor[string.sub(ncl,3,3)],'X')
        ncf = string.sub(ncl,1,1)..string.sub(ncl,2,2)..tempStr
    -- final lookup...
    retval = handleBlank(WeaponNames[ncf])
    if glbls.useErrorMsg==true and retval=='ERROR' then
        retval = nil
        skipIcon = true
    else
        -- prepending...
        retval = lnk..series..retval
    end
    if not skipIcon then
        --icon = ' [[File:' ..handleBlank(WeaponPictures[nc],'Example.jpg')
        icon = ' [[File:' ..handleBlank(WeaponPictures[ncf],'Example.jpg')
        icon = icon..'|'.. NORMALSIZE..'px]] '
        return retval..icon
    else
        return retval
    end
end


local function oneWeapon(args)
    local msg,retval
    local tempstr
    local namCode,nam,num,pic
    msg = 'no weapon chosen'
    namCode = args[1]
    num = args[2]
    -- fixup for name...
    -- ugly-hack
    nam = decodeThree(namCode,glbls.skipIcon)
    if not nam then return msg end
    if nam == 'nil' then
        msg = 'weapon code is required >>'..namCode..'<< is not valid'
        return msg
    else
        if not num then
            retval = '1 '..nam
        elseif utils.toNum(num) == 0 then
            msg = 'Weapon quantity is zero ? >>'..num..'<<'
            return msg
        else
            local nmbr = utils.toNum(num)
            if math.abs(nmbr) > 999 then
                if glbls.usecommas then
                    num = utils.comma_value(nmbr)
                end
            end
            -- last secret/hacky-code...
            if nmbr < 0 then
                -- redo without icon...
                nam = decodeThree(namCode,true)
                -- fixup negative-sign
                num = tostring(-1 * nmbr)
            end
            -- tadah...
            retval = num..' '..nam
        end
        return retval
    end
end




local function listOfWeapons(args)
--    return 'args are :' .. utils.dumpTable(args)
    local numLoops = #args/2  -- known integral from caller...
    local subargs = {}
    local tempstr, retval
    local substrs = {}
        for i = 1,numLoops do
            subargs[1] = args[2*(i-1)+1]
            subargs[2] = args[2*(i-1)+2]
            tempstr = oneWeapon(subargs)
--            if utils.stringStarts(tempstr,'(') then
            if glbls.latest then
                substrs[#substrs+1] = tempstr
            else
                retval = 'ERROR: listOfWeapons : loop#'..tostring(i)
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
    -- this cleans up outside calls for args
    local a
    local one,chkpairs
    a = utils.tableShallowCopy(getargs(frame))
    if #a == 0 then return false end
    chkpairs = #a % 2
    if chkpairs == 0 or #a == 1 then
        glbls.args = a
        return true
    else
--        return 'bad argument list'
        return false
    end
end

function p.choice(frame)
    local retval = 'invalid call to weapons-choice: '
    glbls.usecommas = true
    if not p._main(frame) then
        retval = retval..'zero or too-many arguments passed'
        return retval
    end
    return oneWeapon(glbls.args)
end

function p.choiceList(frame)
    local retval = 'invalid call to weapons-choiceList: '
--    glbls.latest = false
    glbls.usecommas = false
--    glbls.useshortnames = true
--    glbls.usenbspnumbers = true
    if not p._main(frame) then
        retval = retval..'zero arguments passed'
        return retval
    end
    local a = glbls.args
    if (#a > 2) and ((#a % 2) == 0) then
        return listOfWeapons(a)
    elseif (#a == 2) then
        return oneWeapon(a)
    else
        retval = retval..'weaponsLists must be in name,number pairs'
        return retval
    end
end

return p

