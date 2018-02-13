-- Module:Ships
-- inside: [[Category:Modules]] using this line once...

-- <pre>

local p={}

local getargs = require('Dev:Arguments').getArgs
local utils = require('Module:Utilities')
local glbls = require('Module:Globals')
local ssc = require('Module:Starshipcodes')

glbls.latest = true
--glbls.latest = false

glbls.skipIcon = false
--glbls.skipIcon = true
glbls.useErrorMsg = false
--glbls.useErrorMsg = true
glbls.usecommas = true

-- weird/hacky-solution, but translate
-- the SO/RBP codes im used to into a
-- similar 3-letter-code for this lua...

--[[  NEW-CODE-LETTERS at front
   tier-1 ships => o = TOS / n = TNG
oaE                en      o
naE                end     n
nkV                kv      n
ncH                ch      n
okB                kbp     o
orB                rbp     o
   tier-2 ships =  
oaA                ena     o
nbC                bc1     n
ncG                cg      n
nfD                fdm     n
nkN                knv     n
okE                keb     o
okK                kkt     o
okR                kr      o
nrS                rs      n
nrD                rdd     n
orV                rv7     o
orS                rd7     o
   tier-3 ships =  
naS                sgz     n
oaR                rel     o
naV                va      n 
naT                ts      n
nbR                br      n
nbT                bc2     n
okD                kd5     o
**nrV                rvd     n
**ovD                vdk     o
        3.5 =   
oaB                enb     o
oaH                hoz     o
--ofT                tm     o  
**ovT                vtm     o  

alphabetical-to-tier we get
naE1,naS3,naT3,naV3
nbC2,nbR3,nbT3
ncG2,ncH1
nfD2
nkN2,nkV1
nrD2,nrS2,nrV3

oaA2,oaB4,oaE1,oaH4,oaR3
okB1,okD3,okE2,okK2,okR2
orB1,orS2,orV2
ovD3,ovT4

in alphabetical-order we get...
naE,naS,naT,naV
nbC,nbR,nbT
ncG,ncH
nfD
nkN,nkV
nrD,nrS,nrV

oaA,oaB,oaE,oaH,oaR
okB,okD,okE,okK,okR
orB,orS,orV
ovD,ovT
--]]
-- pixels
local NORMALSIZE = 50
local ShipPictures = { -- see discussion at: ???
                naE = 'Next Enterprise.png',
                naS = 'Stargazer.png',
                naT = 'Tsiolkovsky.png',
                naV = 'Valiant.png', 
                nbC = 'Cube 1.png',
                nbR = 'Renegade.png',
                nbT = 'Cube 2.png',
                ncG = 'Galor.png',
                ncH = 'Hideki.png', 
                nfD = 'Marauder.png',
                nkN = 'Neghvar.png',
                nkV = 'Vorcha.png', 
                nrD = 'Dderidex.png',
                nrS = 'Scout.png',
                nrV = 'Valdore.png',
                oaA = 'Enterprise A.png',
                oaB = 'Enterprise B.png',
                oaE = 'Original Enterprise.png',
                oaH = 'Horizon.png',
                oaR = 'Reliant.png',
                okB = 'Klingon bop.png',
                okD = 'D-5.png',
                okE = 'Early bop.png',
                okK = 'Ktinga.png',
                okR = 'Raptor.png',
                orB = 'Romulan bop.png',
                orS = 'D-7.png',
                orV = 'V-7.png',
                ovD = 'Dkyr.png',
                ovT = 'Timur.png',
                    }
local ShipNames = { -- this should be a lookup into ../Data
                    }
--local ShipLetters = { 
local ShipSeriesKeyLinks = { 
                naE = '[[SN/END]]',
                naS = '[[SN/SGZ]]',
                naT = '[[SN/TS]]', 
                naV = '[[SN/VA]]', 
                nbC = '[[SN/BC1]]',
                nbR = '[[SN/BR]]',
                nbT = '[[SN/BC2]]',
                ncG = '[[SN/CG]]',
                ncH = '[[SN/CH]]', 
                nfD = '[[SN/FDM]]',
                nkN = '[[SN/KNV]]',
                nkV = '[[SN/KV]]', 
                nrD = '[[SN/RDD]]',
                nrS = '[[SN/RS]]',
                nrV = '[[SN/RVD]]',
                oaA = '[[SO/ENA]]',
                oaB = '[[SO/ENB]]',
                oaE = '[[SO/EN]]',
                oaH = '[[SO/HOZ]]',
                oaR = '[[SO/REL]]',
                okB = '[[SO/KBP]]',
                okD = '[[SO/KD5]]',
                okE = '[[SO/KEB]]',
                okK = '[[SO/KKT]]',
                okR = '[[SO/KR]]',
                orB = '[[SO/RBP]]',
                orS = '[[SO/RD7]]',
                orV = '[[SO/RV7]]',
                ovD = '[[SO/VDK]]',
                ovT = '[[SO/VTM]]',
                    }
local ShipKeys = { 
                naE = 'END',
                naS = 'SGZ',
                naT = 'TS', 
                naV = 'VA', 
                nbC = 'BC1',
                nbR = 'BR',
                nbT = 'BC2',
                ncG = 'CG',
                ncH = 'CH', 
                nfD = 'FDM',
                nkN = 'KNV',
                nkV = 'KV', 
                nrD = 'RDD',
                nrS = 'RS',
                nrV = 'RVD',
                oaA = 'ENA',
                oaB = 'ENB',
                oaE = 'EN',
                oaH = 'HOZ',
                oaR = 'REL',
                okB = 'KBP',
                okD = 'KD5',
                okE = 'KEB',
                okK = 'KKT',
                okR = 'KR',
                orB = 'RBP',
                orS = 'RD7',
                orV = 'RV7',
                ovD = 'VDK',
                ovT = 'VTM',
                    }
local ShipTier = { 
        naE = 1, nas = 3, naT = 3, naV = 3, 
        nbC = 2, nbT = 3, nbR = 3,
        ncG = 2, ncH = 1, nfD = 2,
        nkN = 2, nkV = 1, 
        nrD = 2, nrS = 2, nrV = 3,
        oaA = 2, oaB = 4,oaE = 1,
        oaH = 4, oaR = 3,
        okB = 1, okD = 3, okE = 2, okK = 2, okR = 2,
        orB = 1, orS = 2, orV = 2,
        ovD = 3, ovT = 4,
    }
local ShipSeries = { o='TOS', n='TNG', }
local ShipGovt = {
                --a = 'alliedFederation',
                a = 'Federation',
                k = 'Klingon',
                r = 'Romulan',
                c = 'Cardassian',
                b = 'Borg',
                --f = 'Ferengi',
                f = 'Alien',
                g = 'tbd...',
                v = 'Vulcan',
            }




local function handleBlank(x,instead)
    return utils.errBlank(tostring(x),instead)
end
local function decodeThree(nc,skipIcon,skipLinks)
    -- 3 letters are TOS/TNG, Category-Govt, code-Letter-into-name
    -- return useful links with icon...
    local lnkStart = '[[:Category:'
    local tempStr,lnk,icon,series,retval,ncl,ncu,ncf
    local tier,lnk1,lnk2,lnk3,govt,nam,key
    local extnam,extpic,exttir,extgov,extser,chk,ans
    ncl = string.lower(nc)
    ncu = string.upper(nc)
    -- recreating nc for final-lookup..
    ncf = string.sub(ncl,1,1)..string.sub(ncl,2,2)..string.sub(ncu,3,3)
    -- use external data now...
    key = ShipKeys[ncf]
    extnam = handleBlank( ssc.main({key,}) )
    extpic = handleBlank( ssc.main({'icon',key,}), 'Example.jpg' )
    exttir = handleBlank( ssc.main({'tier',key,}), 'nil' )
    extgov = handleBlank( ssc.main({'govt',key,}), 'ExtGOV' )
    extser = handleBlank( ssc.main({'series',key,}), 'ExtNoO' )
    --chk,ans = utils.isWikiLink(extgov)
    --if chk then extgov = ans end
    --
    tempStr = handleBlank(ShipSeriesKeyLinks[ncf],'[[tbd...]]')
    --tempStr = handleBlank(ShipSeriesKeyLinks[ncf],'tbd...')
    series = handleBlank(ShipSeries[string.sub(ncl,1,1)],'Stardock')..' '
    lnk1 = lnkStart..series..' Ship|'..series..']] '
    --lnk1 = 'sloc='..series..' slkp='..extser..' '
    govt = handleBlank(ShipGovt[string.sub(ncl,2,2)],'Alien')
    lnk2 = lnkStart..govt..'|'..govt..']] '
    --lnk2 = 'gloc='..govt..' glkp='..extgov..' '
    -- dont use lowercase...
    --tier = handleBlank(tostring(ShipTier[ncf]),'999')
    --lnk = lnkStart..'Tier '..tier..'|T-'..tier..']] '
    lnk = lnkStart..'Tier '..exttir..'|T-'..exttir..']] '
    --lnk = 'tloc='..tier..' tlkp='..exttir..' '
    -- setup pre-name links...
    lnk3 = lnk..lnk1..lnk2
    -- so far, have the parts: [[T-1]] [[TOS]] [[Federation]] in lnk3...
    -- and [[SO/EN]] in tempStr...
    --
    if glbls.useErrorMsg==true and extnam=='ERROR' then
        retval = nil
        skipIcon = true
        skipLinks = true
    else
        -- prepending...
        retval = lnk3..tempStr..' '..extnam..' '
    end
    tempStr = retval
    if not skipIcon then
        --icon = ' [[File:' ..handleBlank(ShipPictures[ncf],'Example.jpg')
        icon = ' [[File:' ..extpic
        icon = icon..'|'.. NORMALSIZE..'px]] '
        retval = tempStr..icon..' '
    else
        retval = tempStr
    end
    if skipLinks then
        retval = extnam
    end
    return retval
end


local function oneShip(args,noLinks)
    local msg,retval
    local tempstr,removeNumber
    local namCode,nam,num,pic,skIc,skPreLnk
    namCode = args[1]
    num = args[2]
    msg = 'no ship chosen'
    if not namCode then return msg end
    -- fixup for name...
    -- ugly-hack 1
    --nam = decodeThree(namCode,glbls.skipIcon)
    -- ugly-hack 2  (better-chk for neg-numbr below)
    -- ugly-hack 3  (.. secret code to removenumber-1)
    if num=='..' then
        removeNumber = true
    else
        removeNumber = false
    end
    tempStr = string.sub(tostring(num),1,1)
    if tempStr=='.' then
        local renum
        skPreLnk = true
        --num = 1
        -- hacky fix for zero,frac values for icon-size...
        renum = math.abs(utils.toNum(num,'0.'..NORMALSIZE))
        if renum < 1.0 then
            num = tostring(1 + renum)
        end
    else
        skPreLnk = false
    end
    if tempStr=='-' then
        skIc = not glbls.skipIcon
    else
        skIc = glbls.skipIcon
    end
    nam = decodeThree(namCode,skIc,skPreLnk)
    msg = 'ship code is required >>'..namCode..'<< is not valid'
    if nam == nil then
        return msg
    else
        if not num then
            retval = '1 '..nam
        elseif removeNumber then
            retval = nam
        elseif utils.toNum(num) == 0 then
            msg = 'ship quantity is zero ? >>'..num..'<<'
            return msg
        else
            local nmbr,nmbra,nmbrc,fnum
            local szIc,junk
            -- lots of tricky stuff in the number-value here...
            nmbr = utils.toNum(num)
            nmbra = math.abs(nmbr)
            nmbrc = math.ceil(nmbra)
            fnum = nmbra
            if nmbra < nmbrc then
                local i2d,frac
                i2d = utils.splitStrPat(num,'[\.]+')  -- one-or-more-decimals
                szIc = utils.toNum(i2d[2])
                -- 1.140 gives a 140px icon
                -- neg(2.100) give a 100px icon
                NORMALSIZE = szIc
                frac = nmbrc - nmbra
                --fnum = fnum + 1 - frac  -- integer part of nmbra
                fnum = math.floor(nmbra)  -- integer part of nmbra
                -- catch the weird-ones...
                if fnum == 0 then fnum = 1 end
            --else
            --    szIC = NORMALSIZE  -- 50px
            end
            if nmbra > 999 then
                if glbls.usecommas then
                    num = utils.comma_value(fnum)
                end
            else
                --num = 1
                num = fnum
            end
            -- now we are ready to put-it-together for-real...
                nam = decodeThree(namCode,skIc,skPreLnk)
            -- Final hacky thing...
            if noLinks==true then
            -- just for fun, undo the LINK-parts of name...
                --nam = decodeThree(namCode,-1)
                nam = decodeThree(namCode,-1,skPreLnk)
                --tempStr = string.sub(nam,1,-4)
                --junk = utils.splitStrPat(tempStr,'[\[\[]+')
                --retval = num..' '..junk[#junk]
                -- get last link...
                junk = utils.splitStrPat(nam,'[\[\[]+')
                tempStr = utils.splitStrPat(junk[#junk],'[\]\]]+')
                retval = num..' '..tempStr[1]
            else
                retval = num..' '..nam
            end
        end
        return retval
    end
end




local function listOfShips(args)
--    return 'args are :' .. utils.dumpTable(args)
    local numLoops = #args/2  -- known integral from caller...
    local subargs = {}
    local tempstr, retval
    local substrs = {}
        for i = 1,numLoops do
            subargs[1] = args[2*(i-1)+1]
            subargs[2] = args[2*(i-1)+2]
            -- remove all links and icons...
            tempstr = oneShip(subargs,true)
--            if utils.stringStarts(tempstr,'(') then
            if glbls.latest then
                substrs[#substrs+1] = tempstr
            else
                retval = 'ERROR: listOfShips : loop#'..tostring(i)
                retval = retval..' args were '..utils.dumpTable(subargs)
                return retval
            end
        end
    if #substrs == 1 then
        retval = substrs[1]..' '
    elseif #substrs == 2 then
        retval = substrs[1]..' and '..substrs[2]..' '
    else
        retval = substrs[1]
        for i = 2,#substrs-1 do
            retval = retval..', '..substrs[i]
        end
        retval = retval..', and '..substrs[#substrs]..' '
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
    local retval = 'invalid call to ship-choice: '
    glbls.usecommas = true
    if not p._main(frame) then
        retval = retval..'zero or too-many arguments passed'
        return retval
    end
    return oneShip(glbls.args)
end

function p.choiceList(frame)
    local retval = 'invalid call to ships-choiceList: '
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
        return listOfShips(a)  --..'am-a-gt-2'
    elseif (#a == 2) then
        --if a[2] == '.' then
        if string.sub(a[2],1,1) == '.' then
            -- skip, via side-effects...
            return oneShip(a,false)  --..'am-a-eq-2-.'
        else
            -- noLinks=true
            return oneShip(a,true)  --..'am-a-eq-2-else'
        end
    else
        retval = retval..'shipsLists must be in name,number pairs'
        return retval
    end
end

return p

