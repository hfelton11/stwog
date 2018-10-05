-- CommonCodes/testcases module
-- inside: [[Category:Modules]] using this line once...

-- Unit tests for [[Module:CommonCodes]]. Click talk page to run tests.
local p = require('Dev:UnitTests')
local glbls = require('Module:Globals')

local badwh =       'CommonCodes bad-which :'
local invalidwh =   'invalid call to Commoncodes-main: cannot loadData'
local ans0 =        'invalid call to Commoncodes-main: '
local ans1 =        'CommonCodes bad-which :'
local ans2 =        'invalid sorc-value >>'
local ans3 =        'glbls.args={'

local tbl1 = '{"cost3":7,"cost1":9,"skill2":"Picard Maneuver","color1":"Orange","color2":"Yellow","cost2":"passive","desc1":{"t2":" blue gems to strike. Does ","v1":2,"v2":32,"t1":"Changes ","t3":" damage for each orange gem that the team has. Max ","v3":170,"t4":"."},"desc2":{"t2":"% life remaining, each strike will cause a damage of ","v1":10,"v2":17,"t1":"If you have less than ","t3":", for each yellow gem on the board. Max ","v3":170,"t4":"."},"skill1":"Constellation Class","desc3":{"t2":" and adds ","v1":50,"v2":2,"t1":"Repairs the shield by ","t3":" defensive gems that protext ","v3":18,"t4":" life during each turn."},"color3":"Blue","skill3":"Skirmish"} '


function p:test_hello()
    self:preprocess_equals('{{#invoke:CommonCodes | hello}}', 'Hello, world!')
end

function p:test_glblsPassthru()
    retstr = 'glbls.sorc='
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBL | sorc | s }}', retstr..'s')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBL | sorc | x }}', retstr..'x')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBL | sorc | c }}', retstr..'c')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBL | sorc | S }}', retstr..'S')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBLsorc | s }}', 'true')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBLsorc | x }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBLsorc | c }}', 'true')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBLsorc | S }}', 'true')
end

function p:test_fnParsers()
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBLsorc | SO }}', 'true')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBLsorc | SN }}', 'true')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBLsorc | CO }}', 'true')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBLsorc | CN }}', 'true')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBLsorc | CS }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBLsorc | SC }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBLsorc | CC }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBLsorc | SS }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBLsorc | OO }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBLsorc | NN }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBLsorc | soon }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | passGLBLsorc | soso }}', 'false')
end

function p:test_skillTrials()
    local sk1pc = 'Adds 3 defensive gems that protect 10 damage points each.'
    local sk1pc2 = 'Adds 3 defensive gems that protect 18 damage points each.'
    local sk1sgz = 'Changes 2 blue gems to strike.  Does 32 damage for each orange gem that the team has.  Max 170.'
    local sk1sgz2 = 'Changes 3 blue gems to strike.  Does 48 damage for each orange gem that the team has.  Max 250.'
    self:preprocess_equals('{{#invoke:CommonCodes | SkFt | s | SGZ | 1 | name | 1 }}', 'Constellation Class')
    self:preprocess_equals('{{#invoke:CommonCodes | SkFt | s | SGZ | 1 | color | 1 }}', 'Orange')
    self:preprocess_equals('{{#invoke:CommonCodes | SkFt | s | SGZ | 1 | cost | 1 }}', '9')
    self:preprocess_equals('{{#invoke:CommonCodes | SkFt | s | SGZ | 1 | desc | 1 }}', sk1sgz)
    self:preprocess_equals('{{#invoke:CommonCodes | SkFt | s | SGZ | 1 | cost | 2 }}', '9')
    self:preprocess_equals('{{#invoke:CommonCodes | SkFt | s | SGZ | 1 | desc | 2 }}', sk1sgz2)
    self:preprocess_equals('{{#invoke:CommonCodes | SkFt | S | SGZ | 1 | name | 1 }}', 'Constellation Class')
    self:preprocess_equals('{{#invoke:CommonCodes | SkFt | c | PC | 1 | name | 1 }}', 'Tactical Deployment')
    self:preprocess_equals('{{#invoke:CommonCodes | SkFt | c | PC | 1 | color | 1 }}', 'Blue')
    self:preprocess_equals('{{#invoke:CommonCodes | SkFt | c | PC | 1 | cost | 1 }}', '6')
    self:preprocess_equals('{{#invoke:CommonCodes | SkFt | c | PC | 1 | desc | 1 }}', sk1pc)
    self:preprocess_equals('{{#invoke:CommonCodes | SkFt | c | PC | 1 | cost | 2 }}', '6')
    self:preprocess_equals('{{#invoke:CommonCodes | SkFt | c | PC | 1 | desc | 2 }}', sk1pc2)
    self:preprocess_equals('{{#invoke:CommonCodes | SkFt | c | AK | 1 | cost | 1 }}', '9')
    self:preprocess_equals('{{#invoke:CommonCodes | SkFt | C | AK | 1 | cost | 2 }}', '10')
end

function p:test_skills()
    self:preprocess_equals('{{#invoke:CommonCodes | passTBL }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | passTBL | s }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | passTBL | s | SGZ }}', '[[Stargazer]]')
    self:preprocess_equals('{{#invoke:CommonCodes | passTBL | S | SGZ }}', '[[Stargazer]]')
    self:preprocess_equals('{{#invoke:CommonCodes | passTBL | s | XXX }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | passTBL | s | SGZ | tier }}', 'not-a-sub-table...')
    self:preprocess_equals('{{#invoke:CommonCodes | passTBL | s | SGZ | badtblname }}', 'not-a-sub-table...')
--    self:preprocess_equals('{{#invoke:CommonCodes | passTBL | s | SGZ | skills }}', 'JSON-enc data')
--    self:preprocess_equals('{{#invoke:CommonCodes | passTBL | s | SGZ | skills }}', tbl1)
end


function p:test_prelist()
    self:preprocess_equals('{{#invoke:CommonCodes | isGoodList | SGZ }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | isGoodList | s | SGZ }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | isGoodList | s | SGZ | 1 }}', 'true')
    self:preprocess_equals('{{#invoke:CommonCodes | isGoodList | s | SGZ | 1 | HOR | 2 }}', 'true')
    self:preprocess_equals('{{#invoke:CommonCodes | isGoodList | s | SGZ | 1 | HOR }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | isGoodList | s | SGZ | 1 |  2 }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | isGoodList | s | SGZ | 1 | XXX | 0 }}', 'true')
    self:preprocess_equals('{{#invoke:CommonCodes | isGoodList | s | ZZZ | -2 | XXX | 0 }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | isGoodList | s | SGZ | -2 | XXX | 0 }}', 'true')
    self:preprocess_equals('{{#invoke:CommonCodes | isGoodList | s | SGZ | -2.340 | XXX | YYY }}', 'true')
    self:preprocess_equals('{{#invoke:CommonCodes | main | list | s | SGZ | 1 }}', ans0..ans2..'list<<')
--    self:preprocess_equals('{{#invoke:CommonCodes | main | s | list | SGZ | 1 }}', '1 [[Stargazer]]')
end

function p:test_NewerCalls()
    self:preprocess_equals('{{#invoke:CommonCodes | makeIGPTfromKey | s | SGZ }}', 'stargazer-3')
    self:preprocess_equals('{{#invoke:CommonCodes | makeIGPTfromKey | s | XXX }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | makeIGPTfromKey | c | PC }}', 'chekov-1')
    self:preprocess_equals('{{#invoke:CommonCodes | makeIGPTfromKey | SGZ }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | makeIGPTfromKey | S | SGZ }}', 'stargazer-3')
end

function p:test_keys()
    self:preprocess_equals('{{#invoke:CommonCodes | isGoodKey | s | SGZ }}', 'true')
    self:preprocess_equals('{{#invoke:CommonCodes | isGoodKey | s | XXX }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | isGoodKey | c | PC }}', 'true')
    self:preprocess_equals('{{#invoke:CommonCodes | isGoodKey | SGZ }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | isGoodKey | S | SGZ }}', 'true')
    self:preprocess_equals('{{#invoke:CommonCodes | getNamefromKey | s | SGZ }}', '[[Stargazer]]')
    self:preprocess_equals('{{#invoke:CommonCodes | getNamefromKey | s | XXX }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | getNamefromKey | c | PC }}', '[[Ensign&nbsp;Chekov]]')
    self:preprocess_equals('{{#invoke:CommonCodes | getNamefromKey | SGZ }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | getNamefromKey | S | SGZ }}', '[[Stargazer]]')
    self:preprocess_equals('{{#invoke:CommonCodes | getFullKey | s | SGZ }}', 'table')
    self:preprocess_equals('{{#invoke:CommonCodes | getFullKey | x | SGZ }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | getFullKey | s | XXX }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | getFullKey | x | XXX }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | getFullKey | c | PC }}', 'table')
    self:preprocess_equals('{{#invoke:CommonCodes | getFullKey | SGZ }}', 'false')
end

local currentCrewKeys = '{ [1] = AH,[2] = AK,[3] = AM,[4] = ANU,[5] = AP,[6] = AR,[7] = ASP,[8] = AV,[9] = AWR,[10] = B1,[11] = B2,[12] = B3,[13] = B4,[14] = BA,[15] = BD,[16] = BE,[17] = BRU,[18] = CA,[19] = CAV,[20] = CBC,[21] = CCP,[22] = CDA,[23] = CDR,[24] = CDT,[25] = CHS,[26] = CHT,[27] = CK,[28] = CLF,[29] = CLM,[30] = CMS,[31] = CNU,[32] = CP,[33] = CPC,[34] = CR,[35] = CT,[36] = CWF,[37] = CWR,[38] = DA,[39] = DBC,[40] = DE,[41] = DLM,[42] = DM,[43] = EK,[44] = EMS,[45] = GLF,[46] = HE,[47] = HO,[48] = HS,[49] = HV,[50] = IN,[51] = KG,[52] = KN,[53] = KO,[54] = KOR,[55] = KU,[56] = KY,[57] = LB,[58] = LD,[59] = LE,[60] = LF,[61] = LOP,[62] = LPC,[63] = MEL,[64] = MS,[65] = NL,[66] = NO,[67] = NU,[68] = NVZ,[69] = OP,[70] = PC,[71] = PG,[72] = PP,[73] = QQ,[74] = RU,[75] = SF,[76] = SG,[77] = SP,[78] = SS,[79] = SV,[80] = SWF,[81] = TA,[82] = TE,[83] = TH,[84] = TK,[85] = TK50,[86] = TN,[87] = TO,[88] = TR,[89] = TT,[90] = TV,[91] = TYD,[92] = TYL,[93] = TYM,[94] = TZZ,[95] = VE,[96] = WC,[97] = WF,[98] = WS,} '

local currentShipKeys = '{ [1] = ANT,[2] = BC1,[3] = BC2,[4] = BR,[5] = CG,[6] = CH,[7] = EN,[8] = ENA,[9] = ENB,[10] = END,[11] = FDM,[12] = HOZ,[13] = KBP,[14] = KD5,[15] = KEB,[16] = KKT,[17] = KNV,[18] = KR,[19] = KV,[20] = RBP,[21] = RD7,[22] = RDD,[23] = REL,[24] = RS,[25] = RV7,[26] = RVD,[27] = SGZ,[28] = THC,[29] = TS,[30] = VA,[31] = VDK,[32] = VTM,} '

local currentEnc = 'glbls.keys=["ANT","BC1","BC2","BR","CG","CH","EN","ENA","ENB","END","FDM","HOZ","KBP","KD5","KEB","KKT","KNV","KR","KV","RBP","RD7","RDD","REL","RS","RV7","RVD","SGZ","THC","TS","VA","VDK","VTM"]'


function p:test_items()
    retstr = 'really nothing found'
    self:preprocess_equals('{{#invoke:CommonCodes | mkOKitems | s | SGZ }}', 'table')
    self:preprocess_equals('{{#invoke:CommonCodes | mkOKitems | x | SGZ }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | mkOKitems | c | PC }}', 'table')
    self:preprocess_equals('{{#invoke:CommonCodes | mkOKitems | SGZ }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | getItemfromKey | s | SGZ | series }}', 'TNG')
    self:preprocess_equals('{{#invoke:CommonCodes | getItemfromKey | s | XXX | series }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | getItemfromKey | c | PC | series }}', 'TOS')
    self:preprocess_equals('{{#invoke:CommonCodes | getItemfromKey | S | SGZ | series }}', 'TNG')
    self:preprocess_equals('{{#invoke:CommonCodes | getItemfromKey | C | PC | series }}', 'TOS')
    self:preprocess_equals('{{#invoke:CommonCodes | getItemfromKey | s | SGZ | skills }}', 'table')
    self:preprocess_equals('{{#invoke:CommonCodes | getItemfromKey | s | SGZ | XXXXX }}', 'tbd...')
    self:preprocess_equals('{{#invoke:CommonCodes | getItemfromKey | s | SGZ | skill1 }}', 'tbd...')
    self:preprocess_equals('{{#invoke:CommonCodes | getItemfromKey | s | XXX | skill1 }}', 'false')
end

function p:test_encoding()
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | full | keyTbl }}', currentEnc )
end

function p:test_mains()
--    local ans1 = 'key=SGZ igpt=tbd...-tbd...'
--    local ans2 = 'sorc=x'
--    local ans3 = 'blnkdump'
    self:preprocess_equals('{{#invoke:CommonCodes | main }}', ans0..'zero arguments passed')
--    self:preprocess_equals('{{#invoke:CommonCodes | main | s }}', ans1..'s')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s }}', ans1..ans3..' [1] = s,} ')
    self:preprocess_equals('{{#invoke:CommonCodes | main | x }}', ans0..ans2..'x<<')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | SGZ }}', '[[Stargazer]]')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | name | SGZ }}', '[[Stargazer]]')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | name | XXX }}', 'tbd...')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | ZZZZ | SGZ }}', ans1..ans3..' [1] = s,[2] = ZZZZ,[3] = SGZ,} ')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | blank | SGZ }}', ans1..ans3..' [1] = s,[2] = blank,[3] = SGZ,} ')
--    self:preprocess_equals('{{#invoke:CommonCodes | main | s | full | keyTbl }}', currentEnc )
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | full | keylist }}', currentShipKeys )
    self:preprocess_equals('{{#invoke:CommonCodes | main | c | full | keylist }}', currentCrewKeys )
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | full | keycount }}', '32' )
    self:preprocess_equals('{{#invoke:CommonCodes | main | c | full | keycount }}', '98' )
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | select | keycount | tier | 1 }}', '6' )
    self:preprocess_equals('{{#invoke:CommonCodes | main | c | select | keycount | tier | 1 }}', '31' )
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | full | SGZ }}', 'CommonCodes bad-listDBstring :glbls.args={ [1] = s,[2] = full,[3] = SGZ,} ')
--    self:preprocess_equals('{{#invoke:CommonCodes | main | s | dumpGLBL | SGZ }}', 'TEST-dumpGLBL')
end

-- these tests all need glbls.debug = true in CommonCodes.lua...
--[[
function p:test_infoBoxes()
    --- note: spaces are important for exactness...
    self:preprocess_equals('{{#invoke:CommonCodes | infoBoxes }}', 'invalid call to Commoncodes-infoBoxes: zero arguments passed')
    self:preprocess_equals('{{#invoke:CommonCodes | infoBoxes | xxx }}', 'invalid call to Commoncodes-infoBoxes: invalid sorc-value >>xxx<<')
--    self:preprocess_equals('{{#invoke:CommonCodes | infoBoxes | s | }}', 'Commoncodes-infoBoxes ok so far: sorc = >>s<<')
    self:preprocess_equals('{{#invoke:CommonCodes | infoBoxes | s | xxx }}', 'invalid call to Commoncodes-infoBoxes: invalid command >>xxx<<')
--    self:preprocess_equals('{{#invoke:CommonCodes | infoBoxes | s | mkInfobox }}', 'Commoncodes-infoBoxes ok so far: sorc = >>s<<, cmd = >>mkInfobox<<')
    self:preprocess_equals('{{#invoke:CommonCodes | infoBoxes | s | mkInfobox }}', 'invalid call to Commoncodes-infoBoxes: invalid key >>nil<<')
    self:preprocess_equals('{{#invoke:CommonCodes | infoBoxes | s | mkInfobox | SGZ }}', 'Commoncodes-infoBoxes ok so far: sorc = >>s<<, cmd = >>mkInfobox<<, key = >>SGZ<<')
    self:preprocess_equals('{{#invoke:CommonCodes | infoBoxes | s | mkInfobox | SGZ  | xxx }}', 'invalid call to Commoncodes-infoBoxes: too many args...')
end
--]]

function p:test_lists()
    --- note: spaces are important for exactness...
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | list | SGZ }}', 'Lists must be in name,number pairs')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | list | SGZ | 1 }}', '1 [[Stargazer]] ')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | list | SGZ | -1.250 }}', '-1.250 [[Stargazer]] ')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | list | SGZ | 2 | END | 4}}', '2 [[Stargazer]]  and 4 [[Next&nbsp;Enterprise]] ')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | list | SGZ | 2 | END | 4 | BC1 | 3 }}', '2 [[Stargazer]] , 4 [[Next&nbsp;Enterprise]] , and 3 [[Cube&nbsp;1]] ')
--    self:preprocess_equals('{{#invoke:CommonCodes | main | list | SGZ }}', invalidwh)
--    self:preprocess_equals('{{#invoke:CommonCodes | main | list | SGZ | 1 }}', invalidwh)
--    self:preprocess_equals('{{#invoke:CommonCodes | main | list | SGZ | -1.250 }}', invalidwh)
--    self:preprocess_equals('{{#invoke:CommonCodes | main | list | SGZ | 2 | END | 4}}', invalidwh)
--    self:preprocess_equals('{{#invoke:CommonCodes | main | list | SGZ | 2 | END | 4 | BC1 | 3 }}', invalidwh)
end

--[[

--]]
function p:test_singlemains()
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | n | SGZ }}', '[[Stargazer]]')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | name | SGZ }}', '[[Stargazer]]')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | hp | SGZ }}', '1228')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | i | SGZ }}', 'Stargazer.png')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | icon | SGZ }}', 'Stargazer.png')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | image | SGZ }}', 'Stargazer.png')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | s | SGZ }}', 'TNG')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | series | SGZ }}', 'TNG')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | t | SGZ }}', '3')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | tier | SGZ }}', '3')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | g | SGZ }}', '[[Federation]]')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | govt | SGZ }}', '[[Federation]]')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | aliases | SGZ }}', 'USS Stargazer')
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | igp | SGZ }}', 'stargazer')
end

return p

