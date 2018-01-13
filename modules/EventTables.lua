-- eventtables module
-- inside: [[Category:Modules]] using this line once...
-- has some functions to create wikitables more easily than mw.html.create...

-- <pre>

local p = {}
local getargs = require('Dev:Arguments').getArgs
local utils = require('Module:Utilities')
local glbls = require('Module:Globals')

-- semi-dummy statement because 'out' is going to hold the final html-object...
glbls.out = true
glbls.rows = true
glbls.passStr = ''
glbls.sortable = 'sortable'

local StoryTable = { 'Lvl #', 'Mission Title', 'Level Type CrewFight/ Diplomacy/ ShipBattle',
                    'Storyline', '#Prizes' }
local StorylineTable = { 'Lvl #', 'Mission Title', 'Lvl Type C/D/S',
                    'Storyline', '#E', '#N', '#L', }
--local StorylineTable = { 'Lvl #', 'Mission Title', 'Lvl Type C/D/S',
--        'Mission Enemy(ies)', 'Storyline', '#E', '#N', '#L', }
local StoryEnemyTable = { 'Lvl #', 'Mission Title', 'CrewFight/ Diplomacy/ ShipBattle',
                    'EnemyDetails', 'Enemy(ies)', }
local EnemiesTable = { 'Lvl #', 'Mission Title', 'Type C/D/S',
                    'Easy', 'Normal', 'Legendary', 'Enemy(ies)', }
--local ScoringTable = { 'Lvl #', 'Mission Title', 'Mission Points', 'Total # Prizes',
local ScoringTable = { 'Mission #', 'Mission Points', 'Total # Prizes',
                    '1st Win Prize', '2nd Win Prize', '3rd Win Prize',
                    '4th Win Prize', }
local ScoringStoryTable = { 'Mission #',      'Total # Prizes', '1st Win Prize',
                    '2nd Win Prize', '3rd Win Prize', '4th Win Prize', }
local RewardsPointsTable = { 'Row #', 'Easy Points', 'Easy Rewards',
                    'Normal Points', 'Normal Rewards',
                    'Legendary Points', 'Legendary Rewards', }
local RewardsTables = { 'Points', 'Rewards',  }
local RewardsEasy = { 100,  '{{P|b}}',          300,    '{{P|d|150|x}}',
                    600,    '{{P|w|2|w}}',      1000,   '{{P|h|5|h}}',
                    1500,   '{{P|g|15|g}}',     2100,   '[[tbd...]]',
                    2800,   '{{P|d|200|x}}',    3600,   '[[tbd...]]',
                    4500,   '{{P|d|250|x}}',    5500,   '{{P|g|45|g}}',
                    6600,   '{{P|d|500|x}}',    7800,   '{{P|b|2}}',
                    9100,   '{{P|d|1000|x}}',   10500,  '{{P|g|75|g}}',
                    12000,  '{{P|d|1500|x}}',   13600,  '{{P|r}}',
                    15300,  '{{P|g|150|g}}',    17100,  '[[tbd...]]',
                    19000,  '[[tbd...]]',     }
local RewardsNormal = { 200,    '{{P|b}}',      600,    '{{P|d|300|x}}',
                    1200,       '{{P|w|4}}',    2000,   '{{P|h|10}}',
                    3000,       '{{P|g|25|g}}', 4200,   '[[tbd...]]',
                    5600,       '{{P|d|400}}',  7200,   '[[tbd...]]',
                    9000,       '{{P|d|500|x}}',  11000, '{{P|g|75|g}}',
                    13200,      '{{P|d|1000|x}}', 15600, '{{P|b|3}}',
                    18200,      '{{P|d|2000|x}}', 21000, '{{P|g|150|g}}',
                    24000,      '{{P|d|3000|x}}', 30000, '{{P|r}}',
                    35000,      '{{P|g|300|g}}',    45000,  '[[tbd...]]',
                    50000,      '[[tbd...]]',     }
local RewardsLegendary = { 300,    '{{P|b}}',   900,    '{{P|d|600|x}}',
                    1800,   '{{P|w|8}}',        3000,   '{{P|h|20}}',
                    4500,   '{{P|g|50|g}}',     6300,   '[[tbd...]]',
                    8400,   '{{P|d|800}}',      10800,  '[[tbd...]]',
                    13500,  '{{P|d|1000|x}}',   16500,  '{{P|g|150|g}}',
                    19800,  '{{P|d|2000|x}}',   23400,  '{{P|r}}',
                    27300,  '{{P|d|4000|x}}',   31500,  '{{P|g|300|g}}',
                    40000,  '{{P|d|6000|x}}',   55000,  '{{P|r|2}}',
                    70000,  '{{P|g|600|g}}',    85000,  '[[tbd...]]',
                    90000,'[[tbd...]]',       }
local RewardsPositionTable = { 'Row #',
                'Solo Posn', 'Easy Solo Rewards',
                'Normal Solo Rewards', 'Legendary Solo Rewards',
                'Team Posn', 'Easy Team Rewards',
                'Normal Team Rewards', 'Legendary Team Rewards', }
local PositionsTable = { 'Positions Solo Players',
                        'Rewards earned Solo',
                        'Positions Team Alliances',
                        'Rewards earned Team',   }
local Positions = { '1 - 2',                '1 - 2',
                    '3 - 10',               '3 - 5',
                    '11 - 20',              '6 - 10',
                    '21 - 50',              '11 - 20',
                    '51 - 100',             '21 - 35',
                    '101 - 150',            '36 - 50',
                    '151 - 300',            '51 - 70',
                    '301 - 800',            '71 - 90',
                    '801 - 1000',           '91 - 120',
                    '1001 - 2000',          '121 - 150',
                    '2,001 - 5,000',        '151 - 200',
                    '5,001 - 10,000',       '201 - 1000',
                    'lower than 10,000',    'lower than 1000',  }
--                    '5,001 - 10,000',       '201 - 500',
--                    'lower than 10,000',    'lower than 500',  }

glbls.choices = StorylineTable
glbls.numPrzEasy = 0
glbls.numPrzNorm = 0
glbls.numPrzLegd = 0
glbls.numBoni = 0
glbls.numLvls = 0

local function updateFirstNumbers(mtx,locBs,which)
    -- now we have to 'undo' the first-column-numbering for bonuses
    -- routine goes up the triangles of bonus-levels doing each subtraction
    local newLvl,numB,curB
    tmpNM = which[1]
    for i,v in ipairs(locBs) do
        curB = v
        for m=curB,#mtx do
            numB = i - 1
            newLvl = m - numB
            mtx[m][tmpNM] = newLvl
            if m == curB then
                mtx[m][tmpNM] = newLvl - 0.5
            else
                mtx[m][tmpNM] = newLvl - 1
            end
        end
    end
    return mtx
end


local function addHeader(namtbl)
	local row = mw.html.create('tr')
	local usecols = {}
    if not namtbl or type(namtbl)~='string' then
        usecols = glbls.choices
    else
        if namtbl == 'Enemies' then
            usecols = EnemiesTable
        elseif namtbl == 'RewardsPoints' then
            usecols = RewardsPointsTable
        elseif namtbl == 'RewardsPosition' or
                namtbl == 'RewardsEasy' or
                namtbl == 'RewardsNormal' or
                namtbl == 'RewardsLegendary' then
            --usecols = RewardsPositionTable
            usecols = PositionsTable
        elseif namtbl == 'Scoring' or
                namtbl == 'ScoringEasy' or
                namtbl == 'ScoringNormal' or
                namtbl == 'ScoringLegendary' then
            usecols = ScoringTable
        elseif namtbl == 'StoryEnemy' then
            usecols = StoryEnemyTable
        elseif namtbl == 'ScoringStory' then
            usecols = ScoringStoryTable
        elseif namtbl == 'Story' then
            usecols = StoryTable
        else
            usecols = StorylineTable
        end
    end
    -- store-back out...
    glbls.choices = usecols
	-- the :tag adds nodes-to-builder (row) and returns updated-instance (row)
    for _,c in ipairs(usecols) do
        if c=='Mission Title' then
            row
                :tag('th')
                    --:css('text-align','left;')
                    :css('width','35%')
                    :wikitext(c):done()
        elseif c=='Storyline' or c=='Enemy(ies)' or c=='EnemyDetails' then
            row
                :tag('th')
                    --:css('text-align','left;')
                    :css('width','45%')
                    :wikitext(c):done()
        elseif c=='Mission Enemy(ies)' then
            row
                :tag('th')
                    --:css('text-align','left;')
                    :css('width','15%')
                    :wikitext(c):done()
        else
            row
                --:tag('th'):wikitext(utils.TitleCase(c)):done()
                :tag('th')
                    :attr('scope','col')
                    :css('text-align','center;')
                    :wikitext(c):done()
        end
    -- endfor
    end
	return row
end


local function addParagraph(str,typ)
        local pa
        if typ ~= nil then
            pa = mw.html.create(typ)
        else
            pa = mw.html.create('p')
        end

            pa
                --:tag('th'):wikitext(utils.TitleCase(c)):done()
                --:tag('th')
                    :css('text-align','left;')
                    :wikitext(str):done()
        return pa
end

local function addRow(tbl,useMulticol)
	local row = mw.html.create('tr')
	-- the :tag adds nodes-to-builder (row) and returns updated-instance (row)
	local origCols,j,datMulti,colMulti
    if useMulticol ~= nil then
        -- currently only do this on mission-points-rows...
        --origCols = 4
        origCols = useMulticol
        datMulti = {}
        colMulti = {}
    else
        origCols = 0
    end
	local dat
    for i,c in ipairs(glbls.choices) do
        dat = tbl[c]
            row
                :css('text-align','center;')
                :tag('td'):wikitext(dat):done()
--        end
    end
    return row
end



local function parseArgsRewardsPoints()
    local keys,rewards,points
    local titles,mtx
    keys = {}
    points = {}
    rewards = {}
    mtx = {}
    glbls.choices = RewardsPointsTable
    titles = RewardsPointsTable
    -- glbls.data is a table holding 'what' and sets-of-three things
    for i,v in ipairs(glbls.data) do
        j = (i-1) % 3
        if j==1 then keys[#keys+1] = tostring(v) end
        if j==2 then points[#points+1] = tostring(v) end
        if i ~= 1 and j==0 then rewards[#rewards+1] = tostring(v) end
    end
    if (#keys ~= #points) or (#keys ~= #rewards) then return nil end
    mtx = {}
    for m=1,#keys do mtx[m]={} end
    -- need to split-apart points/rewards into 3-cols...
    for i,v in ipairs(keys) do
        local mkPts,mkRwds
        -- use code: // for split-pattern...
        mkPts = utils.splitStrPat(points[i],'%/%/')
        mkRwds = utils.splitStrPat(rewards[i],'%/%/')
        mtx[i][titles[1]] = v
        mtx[i][titles[2]] = mkPts[1]
        mtx[i][titles[3]] = mkRwds[1]
        mtx[i][titles[4]] = mkPts[2]
        mtx[i][titles[5]] = mkRwds[2]
        mtx[i][titles[6]] = mkPts[3]
        mtx[i][titles[7]] = mkRwds[3]
    end
    return mtx
end

local function parseArgsRewardsPosition(which)
    local keys,rewards,solo,team,rse,rsn,rsl,rte,rtn,rtl
    local tmpNM,tmpVAL
    local titles,mtx
    keys = {}
    solo = {}
    rse = {}
    rsn = {}
    rsl = {}
    rte = {}
    rtn = {}
    rtl = {}
    team = {}
    mtx = {}
    --glbls.choices = RewardsPositionTable
    glbls.choices = PositionsTable
    titles = PositionsTable
    --titles = RewardsPositionTable
    --rewards = RewardsPositionTable
    -- glbls.data is a table holding 'what' and sets-of-seven things
    for i,v in ipairs(glbls.data) do
        j = (i-1) % 7
        if j==1 then keys[#keys+1] = tostring(v) end
        --if j==2 then solo[#solo+1] = tostring(v) end
        if j==2 then rse[#rse+1] = tostring(v) end
        if j==3 then rsn[#rsn+1] = tostring(v) end
        if j==4 then rsl[#rsl+1] = tostring(v) end
        if j==5 then rte[#rte+1] = tostring(v) end
        if j==6 then rtn[#rtn+1] = tostring(v) end
        --if i ~= 1 and j==0 then team[#team+1] = tostring(v) end
        if i ~= 1 and j==0 then rtl[#rtl+1] = tostring(v) end
    end
    if (#keys ~= #rse) or (#keys ~= #rtl) then return nil end
    mtx = {}
    --for m=1,#keys do mtx[m]={} end
    tmpVAL = #Positions/2
    for m=1,tmpVAL do mtx[m]={} end
    --for m=1,#keys do mtx[m]={} end
    for i,v in ipairs(keys) do
        mtx[i][titles[1]] = Positions[2*i-1]
        mtx[i][titles[3]] = Positions[2*i]
        if which=='easy' then
                mtx[i][titles[2]] = rse[i]
                mtx[i][titles[4]] = rte[i]
        elseif which=='normal' then
                mtx[i][titles[2]] = rsn[i]
                mtx[i][titles[4]] = rtn[i]
        elseif which=='legendary' then
                mtx[i][titles[2]] = rsl[i]
                mtx[i][titles[4]] = rtl[i]
        else
            -- unused ?
                mtx[i][titles[2]] = "?"
                mtx[i][titles[4]] = "?"
        end
    end
    -- fill-out the table...
    --if #keys < #Positions/2 then
    --    for i = #keys+1, #Positions/2 do
    if #keys < tmpVAL then
        for i = #keys+1,tmpVAL do
                mtx[i][titles[1]] = Positions[2*i-1]
                mtx[i][titles[3]] = Positions[2*i]
                mtx[i][titles[2]] = "'''''-nothing-'''''"
                mtx[i][titles[4]] = "'''''-nothing-'''''"
        end
    end
    glbls.rows = utils.tableShallowCopy(mtx)
    return mtx
end



local function parseArgsEnemies()
    local keys,titles,nme,de,dn,dl
    local j,chkBonus,locBs
    local rows,mtx,tmpNM,tmpVAL
    keys = {}
    titles = {}
    nme = {}
    de = {}
    dn = {}
    dl = {}
    locBs = {}
    -- glbls.data is a table holding 'what' and sets-of-six things
    for i,v in ipairs(glbls.data) do
        j = (i-1) % 6
        if j==1 then keys[#keys+1] = tostring(v) end
        if j==2 then titles[#titles+1] = tostring(v) end
        if j==3 then nme[#nme+1] = tostring(v) end
        if j==4 then de[#de+1] = tostring(v) end
        if j==5 then dn[#dn+1] = tostring(v) end
        if i ~= 1 and j==0 then dl[#dl+1] = tostring(v) end
    end
    if (#keys ~= #titles) or (#keys ~= #dl) then return nil end
    mtx = {}
    for m=1,#keys do mtx[m]={} end
    -- #EnemiesTable is 7
    -- title=='.' for bonus-level
    for i,v in ipairs(titles) do
        -- bonus is stored in TITLEs
        tmpNM = EnemiesTable[2]
        if v=='.' then
            locBs[#locBs+1] = i
            mtx[i][tmpNM] = '--BONUS--'
        else
            mtx[i][tmpNM] = v
        end
        -- others
        tmpNM = EnemiesTable[1]
        mtx[i][tmpNM] = i  -- level-#
        tmpNM = EnemiesTable[4]
        mtx[i][tmpNM] = de[i]
        tmpNM = EnemiesTable[5]
        mtx[i][tmpNM] = dn[i]
        tmpNM = EnemiesTable[6]
        mtx[i][tmpNM] = dl[i]
    end
    -- key is X### for cols 3 and tier-#/enemy
    for i,v in ipairs(keys) do
        local mkNameBgn = '{{nowrap| '
        local mkTierBgn = '[[:Category:Tier '
        local mkT,mkNME,junk,mkNMET
        tmpNM = EnemiesTable[3]
        mtx[i][tmpNM] = string.sub(v,1,1)
        tmpNM = EnemiesTable[7]
        --mtx[i][tmpNM] = nme[i]
        mkNMET = {}
        -- cant split on space cuz of spaces-in-name-links...
        --mkNME = utils.splitStrPat(nme[i],'[%s]+')
        mkNME = utils.splitStrPat(nme[i],'%]%]')
        for j=2,string.len(v) do
            Tnum = utils.toNum(string.sub(v,j,j))
            -- recreating name-links...
            mkT = mkTierBgn..tostring(Tnum)..'|T-'..tostring(Tnum)..']] '
            -- adding {{nowrap}}
            --mkT = mkNameBgn..mkTierBgn..tostring(Tnum)
            --mkT = mkT..'|T-'..tostring(Tnum)..']] '
            --mkNMET[j-1] = mkT..mkNME[j-1]..']]}}'
            -- adding {{nowrap}} AGAIN...
            --mkNMET[j-1] = mkNameBgn..mkT..mkNME[j-1]..']] }}'
            mkNMET[j-1] = mkT..mkNME[j-1]..']]'
        end
        --junk = table.concat(mkNMET,', ')
        junk = table.concat(mkNMET,', <br>')
        mtx[i][tmpNM] = junk
        -- override...
        --mtx[i][tmpNM] = nme[i]
    end
    -- now we have to 'undo' the level-numbering for bonuses
    mtx = updateFirstNumbers(mtx,locBs,EnemiesTable)
    --return rows
    glbls.rows = utils.tableShallowCopy(mtx)
    return mtx
end

local function parseArgsScoring(which)
    local keys,titles,Eprz,Nprz,Lprz
    local j,chkBonus,locBs
    local tmpNM,tmpVAL
    local mtx
    -- glbls.data is a table holding 'what' and sets-of-three prizes
    keys = {}
    titles = {}
    Eprz = {}
    Nprz = {}
    Lprz = {}
    locBs = {}
    for i,v in ipairs(glbls.data) do
        j = (i-1) % 5
        if j==1 then keys[#keys+1] = tostring(v) end
        if j==2 then titles[#titles+1] = tostring(v) end
        if j==3 then Eprz[#Eprz+1] = tostring(v) end
        if j==4 then Nprz[#Nprz+1] = tostring(v) end
        if i ~= 1 and j==0 then Lprz[#Lprz+1] = tostring(v) end
    end
    if (#keys ~= #titles) or (#keys ~= #Lprz) then return nil end
    mtx = {}
    for m=1,#keys do mtx[m]={} end
    -- #ScoringTable is 7
    for i,v in ipairs(keys) do
        -- others (do first...)
        tmpNM = ScoringTable[1]
        mtx[i][tmpNM] = i  -- level-#
        tmpNM = ScoringTable[2]
        tmpVAL = 25  -- score-per-level
        if which=='easy' then
            mtx[i][tmpNM] = i * tmpVAL * 1 -- 25 pts
            tmpNM = ScoringTable[3]
            tmpVAL = string.sub(v,2,2)  -- #-prizes
            mtx[i][tmpNM] = tmpVAL
            tmpNM = ScoringTable[4]
            tmpVAL = Eprz[i]
            mtx[i][tmpNM] = tmpVAL
        elseif which=='normal' then
            mtx[i][tmpNM] = i * tmpVAL * 2 -- 50 pts
            tmpNM = ScoringTable[3]
            tmpVAL = string.sub(v,3,3)  -- #-prizes
            mtx[i][tmpNM] = tmpVAL
            tmpNM = ScoringTable[4]
            tmpVAL = Nprz[i]
            mtx[i][tmpNM] = tmpVAL
        elseif which=='legendary' then
            mtx[i][tmpNM] = i * tmpVAL * 3 -- 75 pts
            tmpNM = ScoringTable[3]
            tmpVAL = string.sub(v,4,4)  -- #-prizes
            mtx[i][tmpNM] = tmpVAL
            tmpNM = ScoringTable[4]
            tmpVAL = Lprz[i]
            mtx[i][tmpNM] = tmpVAL
        else
            -- unused ?
            mtx[i][tmpNM] = 1
            tmpNM = ScoringTable[3]
            tmpVAL = 0
            mtx[i][tmpNM] = tmpVAL
        end
        -- bonus is stored in KEYs, used for renum-locBs
        -- but dont need name-title or descs...
        chkBonus = string.sub(v,1,1)
        if chkBonus == 'B' then
            locBs[#locBs+1] = i
            -- could change-TITLE-back to generic-name
            -- titles[i] = '--BONUS--'
        end
    end
    -- need to split-apart prizes into 4-cols from first...
    for i,v in ipairs(keys) do
        local mkPrizes
        local pzs = {}
        tmpNM = ScoringTable[4]
        -- stupidities about pre/post evaluating of {{.}}
        -- so use code: // instead...
        mkPrizes = utils.splitStrPat(mtx[i][tmpNM],'%/%/')
        -- override
        --mtx[i][tmpNM] = mkPrizes[1]
        for j = 1,4 do
            pzs[j] = ' '
            if mkPrizes[j] ~= nil then
                pzs[j] = pzs[j]..mkPrizes[j]
            end
        end
        mtx[i][tmpNM] = pzs[1]
        for j = 5,7 do
            tmpNM = ScoringTable[j]
            mtx[i][tmpNM] = pzs[j-3]
        end
    end
    -- now we have to 'undo' the level-numbering for bonuses
    mtx = updateFirstNumbers(mtx,locBs,ScoringTable)
    --return rows
    glbls.rows = utils.tableShallowCopy(mtx)
    return mtx
end



local function parseArgsStoryline()
    local keys,titles,descs
    local j,chkBonus,locBs
    local rows,mtx,tmpNM,tmpVAL
    keys = {}
    titles = {}
    descs = {}
    locBs = {}
    -- glbls.data is a table holding 'what' and sets-of-three things
    for i,v in ipairs(glbls.data) do
        j = (i-1) % 3
        if j==1 then keys[#keys+1] = tostring(v) end
        if j==2 then titles[#titles+1] = tostring(v) end
        if i ~= 1 and j==0 then descs[#descs+1] = tostring(v) end
    end
    --rows = utils.dumpTable(keys)..utils.dumpTable(titles)..utils.dumpTable(descs)
    if (#keys ~= #titles) or (#keys ~= #descs) then return nil end
    mtx = {}
    for m=1,#keys do mtx[m]={} end
    -- #StorylineTable is 7
    -- key is X### for cols 3,5-7
    for i,v in ipairs(keys) do
        -- others (do first...)
        tmpNM = StorylineTable[1]
        mtx[i][tmpNM] = i  -- level-#
        tmpNM = StorylineTable[2]
        mtx[i][tmpNM] = titles[i]
        tmpNM = StorylineTable[4]
        mtx[i][tmpNM] = descs[i]
        -- bonus is stored in KEYs
        chkBonus = string.sub(v,1,1)
        tmpNM = StorylineTable[3]
        if chkBonus == 'B' then
            mtx[i][tmpNM] = string.sub(titles[i],1,1)
            locBs[#locBs+1] = i
            -- change-TITLE-back from 'type'-CDS to generic-name
            mtx[i][StorylineTable[2]] = '--BONUS--'
        else
            mtx[i][tmpNM] = string.sub(v,1,1)
        end
        -- #ENL is stored in KEYs
        for j=2,4 do
            k=j+3
            tmpNM = StorylineTable[k]
            tmpVAL = string.sub(v,j,j)
            mtx[i][tmpNM]=tmpVAL
        end
    end
    -- create numbers needed...
    glbls.numBoni = #locBs
    glbls.numLvls = #titles
    glbls.numPrzEasy = 0
    glbls.numPrzNorm = 0
    glbls.numPrzLegd = 0
    for i = 1,#keys do
        glbls.numPrzEasy = glbls.numPrzEasy + utils.toNum(mtx[i]['#E'])
        glbls.numPrzNorm = glbls.numPrzNorm + utils.toNum(mtx[i]['#N'])
        glbls.numPrzLegd = glbls.numPrzLegd + utils.toNum(mtx[i]['#L'])
        for _,j in ipairs({'#E','#N','#L',}) do
            tmpVAL = mtx[i][j]
            if utils.toNum(tmpVAL) ~= 4 then
                tmpVAL = "'''''"..tmpVAL.."'''''"
                mtx[i][j] = tmpVAL
            end
        end
    end
    -- now we have to 'undo' the level-numbering for bonuses
    mtx = updateFirstNumbers(mtx,locBs,StorylineTable)
    --return rows
    glbls.rows = utils.tableShallowCopy(mtx)
    return mtx
end





local function cnvtStoryline2Story(inMtx,typ)
    local row = {}
    local xfer = {}
    local mtx = {}
    local toTbl,fromTbl
    -- VERY hacky assumptions
    -- 1 - to is smaller than from
    -- 2 - to is in same-order as from
    -- 3 - enemies-table-didnt-work
    --      so special-case hack-worse...
    -- 4 - rewards/scoring-table-skips-col-2 instead
    --      so another hacky-worse...
    if typ=='e' then
        -- enemies-tables
        -- last-col needed to match-correctly
        -- egads, hacky...
        toTbl = StoryEnemyTable
        fromTbl = EnemiesTable
        for i=1,#toTbl-1 do
                xfer[toTbl[i]]=fromTbl[i]
        end
        xfer[toTbl[#toTbl]]=fromTbl[#fromTbl]
    elseif typ=='r' then
        -- scoring-rewards-tables
        toTbl = ScoringStoryTable
        fromTbl = ScoringTable
        xfer[toTbl[1]]=fromTbl[1]
        for i=2,#toTbl do
                xfer[toTbl[i]]=fromTbl[i+1]
        end
    else -- 's' for original Storyline2Story
        toTbl = StoryTable
        fromTbl = StorylineTable
        for i=1,#toTbl do
                xfer[toTbl[i]]=fromTbl[i]
        end
    end
    for lvl=1,#inMtx do
        local tmp = {}
        row = inMtx[lvl]
        for col,v in pairs(row) do
            for new,old in pairs(xfer) do
                if col==old then
                    tmp[new]=v
                end
            end
        end
        mtx[lvl]=tmp
    end
    return mtx
end





local function mkTable(what)
--    local allkeys = cc.getAK(fakeFrame)
    local r  -- to hold extra nodes/rows
    local tblrows,useCols,tmprows
--    glbls.out = mw.html.create('table'):addClass('wikitable sortable')
    glbls.out = mw.html.create('table'):addClass('wikitable '..glbls.sortable)
    r = addHeader(what)
    glbls.out:node(r)  -- adds a child-node of (row) to current-instance (table)
    if what=='Enemies' or what=='StoryEnemy' then
        tmprows = parseArgsEnemies()
        if what=='StoryEnemy' then
            tblrows = cnvtStoryline2Story(tmprows,'e')
        else
            tblrows = tmprows
        end
    elseif what=='Storyline' or what=='Story' then
        tmprows = parseArgsStoryline()
        if what=='Story' then
            tblrows = cnvtStoryline2Story(tmprows)
        else
            tblrows = tmprows
        end
    elseif what=='RewardsPoints' then
        tblrows = parseArgsRewardsPoints()
--    elseif what=='RewardsPosition' then
--        tblrows = parseArgsRewardsPosition()
    elseif what=='RewardsEasy' then
        tblrows = parseArgsRewardsPosition('easy')
    elseif what=='RewardsNormal' then
        tblrows = parseArgsRewardsPosition('normal')
    elseif what=='RewardsLegendary' then
        tblrows = parseArgsRewardsPosition('legendary')
--    elseif what=='Scoring' then
--        tblrows = parseArgsScoring('easy')
    elseif what=='ScoringStory' then
        tmprows = parseArgsScoring('easy')
        useCols = 4
        -- hack to remove-points...
        tblrows = cnvtStoryline2Story(tmprows,'r')
    elseif what=='ScoringEasy' then
        tblrows = parseArgsScoring('easy')
        useCols = 4
    elseif what=='ScoringNormal' then
        tblrows = parseArgsScoring('normal')
        useCols = 4
    elseif what=='ScoringLegendary' then
        tblrows = parseArgsScoring('legendary')
        useCols = 4
    else
        tblrows = {}
    end
    glbls.rows = tblrows  -- mtx[][]
    --
    for _,cols in ipairs(tblrows) do
        r = addRow(cols,useCols)
        glbls.out:node(r)
    end
    r = addHeader()
    glbls.out:node(r)
    return glbls.out
--    return utils.dumpTable(glbls.rows)
--    return 'inside mkTable()'
end
local function mkIndex()
    return 'inside mkIndex()'
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
        -- setup everything...
        holdstr = tostring(mkTable(what))
        if (what=='Storyline') then
            -- storyline info...
            tempstr = 'Easy: ?/'..glbls.numLvls
            tempstr = tempstr..' and ?/'..glbls.numPrzEasy
            out = out..tostring(addParagraph(tempstr,'li'))
            tempstr = 'Normal: ?/'..glbls.numLvls
            tempstr = tempstr..' and ?/'..glbls.numPrzNorm
            out = out..tostring(addParagraph(tempstr,'li'))
            tempstr = 'Legendary: ?/'..glbls.numLvls
            tempstr = tempstr..' and ?/'..glbls.numPrzLegd
            out = out..tostring(addParagraph(tempstr,'li'))
            --
            tempstr = out
            out = tostring(addParagraph(tempstr,'ul'))
        end
        out = out..holdstr
--        out = glbls.choices
        --out = utils.dumpTable(glbls.rows)
    elseif what=='Scoring' then
        out = ''
        --out = '<br>'
        --out = out..tostring(addParagraph('===EASY==='))
        out = out..tostring(addParagraph('Easy','h4'))
        out = out..tostring(mkTable('ScoringEasy'))
        out = out..tostring(addParagraph('Normal','h4'))
        out = out..tostring(mkTable('ScoringNormal'))
        out = out..tostring(addParagraph('Legendary','h4'))
        out = out..tostring(mkTable('ScoringLegendary'))
    elseif what=='RewardsPosition' then
        --out = 'Doing RewardsPosition here...'
        -- setup everything...
        glbls.sortable = ''
        out = ''
        out = out..tostring(addParagraph('Easy','h4'))
        out = out..tostring(mkTable('RewardsEasy'))
        out = out..tostring(addParagraph('Normal','h4'))
        out = out..tostring(mkTable('RewardsNormal'))
        out = out..tostring(addParagraph('Legendary','h4'))
        out = out..tostring(mkTable('RewardsLegendary'))
        --holdstr = tostring(mkTable(what))
        --out = out..holdstr
        --out = out..utils.dumpTable(glbls.rows)
    elseif (what=='Enemies') or
            (what=='StoryEnemy') or
            (what=='RewardsPoints') or
            (what=='ScoringStory') or
            (what=='ScoringEasy') or
            (what=='ScoringNormal') or
            (what=='ScoringLegendary') then

        out = mkTable(what)
--        out = glbls.choices
        -- storyline info...
--[[        tempstr = tempstr..'E='..glbls.numPrzEasy
        tempstr = tempstr..'N='..glbls.numPrzNorm
        tempstr = tempstr..'L='..glbls.numPrzLegd
        tempstr = tempstr..'B='..glbls.numBoni
        tempstr = tempstr..'N='..glbls.numLvls
        out = tempstr
--]]
        --out = utils.dumpTable(glbls.rows)
    else
        out = "Hello, world! - doing..."..tostring(what)..
            "... with ==>"..utils.dumpTable(glbls.data)
    end
    return tostring( out )
end

return p

