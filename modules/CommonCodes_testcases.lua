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

--[[
function p:test_skills()
-- FAKES....
-- FAKES....   hardcoded first skill first evolution...
-- FAKES....
--    self:preprocess_equals('{{#invoke:CommonCodes | reduceTV | SGZ }}', 'false')
    self:preprocess_equals('{{#invoke:CommonCodes | reduceTV | s | SGZ }}', '???')
    self:preprocess_equals('{{#invoke:CommonCodes | reduceTV | s | EN }}', '???')
    self:preprocess_equals('{{#invoke:CommonCodes | reduceTV | c | PC }}', '???')
end
--]]

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

--local currentCrewKeys = '{ [1] = AH,[2] = AK,[3] = AM,[4] = ANU,[5] = AP,[6] = AR,[7] = ASP,[8] = AV,[9] = B1,[10] = B2,[11] = B3,[12] = B4,[13] = BA,[14] = BD,[15] = BE,[16] = CA,[17] = CAV,[18] = CBC,[19] = CDA,[20] = CDR,[21] = CDT,[22] = CHS,[23] = CHT,[24] = CK,[25] = CLF,[26] = CLM,[27] = CMS,[28] = CNU,[29] = CP,[30] = CPC,[31] = CR,[32] = CT,[33] = CWF,[34] = CWR,[35] = DA,[36] = DBC,[37] = DE,[38] = DM,[39] = EK,[40] = EMS,[41] = HE,[42] = HO,[43] = HS,[44] = HV,[45] = IN,[46] = KG,[47] = KN,[48] = KO,[49] = KU,[50] = KY,[51] = LB,[52] = LD,[53] = LE,[54] = LF,[55] = LPC,[56] = MS,[57] = NL,[58] = NO,[59] = NU,[60] = OP,[61] = PC,[62] = PG,[63] = PP,[64] = QQ,[65] = RU,[66] = SF,[67] = SG,[68] = SP,[69] = SS,[70] = SV,[71] = SWF,[72] = TA,[73] = TE,[74] = TH,[75] = TK,[76] = TK50,[77] = TN,[78] = TO,[79] = TR,[80] = TT,[81] = TV,[82] = VE,[83] = WC,[84] = WF,[85] = WS,} '
--local currentCrewKeys = '{ [1] = AH,[2] = AK,[3] = AM,[4] = ANU,[5] = AP,[6] = AR,[7] = ASP,[8] = AV,[9] = B1,[10] = B2,[11] = B3,[12] = B4,[13] = BA,[14] = BD,[15] = BE,[16] = CA,[17] = CAV,[18] = CBC,[19] = CDA,[20] = CDR,[21] = CDT,[22] = CHS,[23] = CHT,[24] = CK,[25] = CLF,[26] = CLM,[27] = CMS,[28] = CNU,[29] = CP,[30] = CPC,[31] = CR,[32] = CT,[33] = CWF,[34] = CWR,[35] = DA,[36] = DBC,[37] = DE,[38] = DM,[39] = EK,[40] = EMS,[41] = HE,[42] = HO,[43] = HS,[44] = HV,[45] = IN,[46] = KG,[47] = KN,[48] = KO,[49] = KU,[50] = KY,[51] = LB,[52] = LD,[53] = LE,[54] = LF,[55] = LPC,[56] = MS,[57] = NL,[58] = NO,[59] = NU,[60] = OP,[61] = PC,[62] = PG,[63] = PP,[64] = QQ,[65] = RU,[66] = SF,[67] = SG,[68] = SP,[69] = SS,[70] = SV,[71] = SWF,[72] = TA,[73] = TE,[74] = TH,[75] = TK,[76] = TK50,[77] = TN,[78] = TO,[79] = TR,[80] = TT,[81] = TV,[82] = VE,[83] = WC,[84] = WF,[85] = WS,} '
local currentCrewKeys = '{ [1] = AH,[2] = AK,[3] = AM,[4] = ANU,[5] = AP,[6] = AR,[7] = ASP,[8] = AV,[9] = B1,[10] = B2,[11] = B3,[12] = B4,[13] = BA,[14] = BD,[15] = BE,[16] = CA,[17] = CAV,[18] = CBC,[19] = CCP,[20] = CDA,[21] = CDR,[22] = CDT,[23] = CHS,[24] = CHT,[25] = CK,[26] = CLF,[27] = CLM,[28] = CMS,[29] = CNU,[30] = CP,[31] = CPC,[32] = CR,[33] = CT,[34] = CWF,[35] = CWR,[36] = DA,[37] = DBC,[38] = DE,[39] = DM,[40] = EK,[41] = EMS,[42] = GLF,[43] = HE,[44] = HO,[45] = HS,[46] = HV,[47] = IN,[48] = KG,[49] = KN,[50] = KO,[51] = KOR,[52] = KU,[53] = KY,[54] = LB,[55] = LD,[56] = LE,[57] = LF,[58] = LOP,[59] = LPC,[60] = MS,[61] = NL,[62] = NO,[63] = NU,[64] = OP,[65] = PC,[66] = PG,[67] = PP,[68] = QQ,[69] = RU,[70] = SF,[71] = SG,[72] = SP,[73] = SS,[74] = SV,[75] = SWF,[76] = TA,[77] = TE,[78] = TH,[79] = TK,[80] = TK50,[81] = TN,[82] = TO,[83] = TR,[84] = TT,[85] = TV,[86] = VE,[87] = WC,[88] = WF,[89] = WS,} '
--local currentShipKeys = '{ [1] = BC1,[2] = BC2,[3] = BR,[4] = CG,[5] = CH,[6] = EN,[7] = ENA,[8] = ENB,[9] = END,[10] = FDM,[11] = HOZ,[12] = KBP,[13] = KD5,[14] = KEB,[15] = KKT,[16] = KNV,[17] = KR,[18] = KV,[19] = RBP,[20] = RD7,[21] = RDD,[22] = REL,[23] = RS,[24] = RV7,[25] = SGZ,[26] = TM,[27] = TS,[28] = VA,} '
--local currentShipKeys = '{ [1] = BC1,[2] = BC2,[3] = BR,[4] = CG,[5] = CH,[6] = EN,[7] = ENA,[8] = ENB,[9] = END,[10] = FDM,[11] = HOZ,[12] = KBP,[13] = KD5,[14] = KEB,[15] = KKT,[16] = KNV,[17] = KR,[18] = KV,[19] = RBP,[20] = RD7,[21] = RDD,[22] = REL,[23] = RS,[24] = RV7,[25] = SGZ,[26] = TM,[27] = TS,[28] = VA,} '
local currentShipKeys = '{ [1] = BC1,[2] = BC2,[3] = BR,[4] = CG,[5] = CH,[6] = EN,[7] = ENA,[8] = ENB,[9] = END,[10] = FDM,[11] = HOZ,[12] = KBP,[13] = KD5,[14] = KEB,[15] = KKT,[16] = KNV,[17] = KR,[18] = KV,[19] = RBP,[20] = RD7,[21] = RDD,[22] = REL,[23] = RS,[24] = RV7,[25] = RVD,[26] = SGZ,[27] = TS,[28] = VA,[29] = VDK,[30] = VTM,} '
--local currentEnc = '["BC1","BC2","BR","CG","CH","EN","ENA","ENB","END","FDM","HOZ","KBP","KD5","KEB","KKT","KNV","KR","KV","RBP","RD7","RDD","REL","RS","RV7","SGZ","TM","TS","VA"]'
--local currentEnc = 'glbls.keys=["BC1","BC2","BR","CG","CH","EN","ENA","ENB","END","FDM","HOZ","KBP","KD5","KEB","KKT","KNV","KR","KV","RBP","RD7","RDD","REL","RS","RV7","SGZ","TM","TS","VA"]'
local currentEnc = 'glbls.keys=["BC1","BC2","BR","CG","CH","EN","ENA","ENB","END","FDM","HOZ","KBP","KD5","KEB","KKT","KNV","KR","KV","RBP","RD7","RDD","REL","RS","RV7","RVD","SGZ","TS","VA","VDK","VTM"]'


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
    self:preprocess_equals('{{#invoke:CommonCodes | main | s | full | keycount }}', '30' )
    self:preprocess_equals('{{#invoke:CommonCodes | main | c | full | keycount }}', '89' )
--    self:preprocess_equals('{{#invoke:CommonCodes | main | s | full | SGZ }}', 'sgzdump')
--    self:preprocess_equals('{{#invoke:CommonCodes | main | s | dumpGLBL | SGZ }}', 'TEST-dumpGLBL')
end

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
