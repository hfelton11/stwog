-- commonlists/testcases module
-- inside: [[Category:Modules]] using this line once...

-- Unit tests for [[Module:CommonLists]]. Click talk page to run tests.
local p = require('Dev:UnitTests')

local ans1 =        'CommonLists bad-which :'
local ans2 =        'invalid sorc-value >>'
local ans3 =        'glbls.args={ [1] = s,'
local ans4 =        'main-fail'
local ans5 =        'Hello, world! - for... hello-1 doing... hello-2 ...using how... hello-3 ...choosing which... hello-4 ...as value... hello-5 ???\n\n\n'
local ans6 =        '{ } '


function p:test_hello()
--    self:preprocess_equals('{{#invoke:CommonLists | hello}}', 'Hello, world!')
    self:preprocess_equals('{{#invoke:CommonLists | main | hello-1 | hello-2 | hello-3 | hello-4 | hello-5 | hello-6 | hello-7 | hello-8 }}', ans2..'hello-1<<')
--    self:preprocess_equals('{{#invoke:CommonLists | main | s | testSkills }}', ans6)
--    self:preprocess_equals('{{#invoke:CommonLists | main | c | testSkills }}', ans6)
--    self:preprocess_equals('{{#invoke:CommonLists | main | C | testSkills }}', ans6)
--    self:preprocess_equals('{{#invoke:CommonLists | main | s | skills }}', ans4)
end

local currentCrewKeys = '{ [1] = AH,[2] = AK,[3] = AM,[4] = ANU,[5] = AP,[6] = AR,[7] = ASP,[8] = AV,[9] = AWR,[10] = B1,[11] = B2,[12] = B3,[13] = B4,[14] = BA,[15] = BD,[16] = BE,[17] = CA,[18] = CAV,[19] = CBC,[20] = CCP,[21] = CDA,[22] = CDR,[23] = CDT,[24] = CHS,[25] = CHT,[26] = CK,[27] = CLF,[28] = CLM,[29] = CMS,[30] = CNU,[31] = CP,[32] = CPC,[33] = CR,[34] = CT,[35] = CWF,[36] = CWR,[37] = DA,[38] = DBC,[39] = DE,[40] = DLM,[41] = DM,[42] = EK,[43] = EMS,[44] = GLF,[45] = HE,[46] = HO,[47] = HS,[48] = HV,[49] = IN,[50] = KG,[51] = KN,[52] = KO,[53] = KOR,[54] = KU,[55] = KY,[56] = LB,[57] = LD,[58] = LE,[59] = LF,[60] = LOP,[61] = LPC,[62] = MS,[63] = NL,[64] = NO,[65] = NU,[66] = OP,[67] = PC,[68] = PG,[69] = PP,[70] = QQ,[71] = RU,[72] = SF,[73] = SG,[74] = SP,[75] = SS,[76] = SV,[77] = SWF,[78] = TA,[79] = TE,[80] = TH,[81] = TK,[82] = TK50,[83] = TN,[84] = TO,[85] = TR,[86] = TT,[87] = TV,[88] = VE,[89] = WC,[90] = WF,[91] = WS,} '
local currentShipKeys = '{ [1] = BC1,[2] = BC2,[3] = BR,[4] = CG,[5] = CH,[6] = EN,[7] = ENA,[8] = ENB,[9] = END,[10] = FDM,[11] = HOZ,[12] = KBP,[13] = KD5,[14] = KEB,[15] = KKT,[16] = KNV,[17] = KR,[18] = KV,[19] = RBP,[20] = RD7,[21] = RDD,[22] = REL,[23] = RS,[24] = RV7,[25] = RVD,[26] = SGZ,[27] = TS,[28] = VA,[29] = VDK,[30] = VTM,} '
local currentShipsEnc = 'glbls.keys=["BC1","BC2","BR","CG","CH","EN","ENA","ENB","END","FDM","HOZ","KBP","KD5","KEB","KKT","KNV","KR","KV","RBP","RD7","RDD","REL","RS","RV7","SGZ","TM","TS","VA"]'



function p:test_mkindex()
--    self:preprocess_equals('{{#invoke:CommonLists | main | index }}', 'stargazer-3')
    self:preprocess_equals('{{#invoke:CommonLists | main | C | index0 }}', currentCrewKeys)
    self:preprocess_equals('{{#invoke:CommonLists | main | s | index0 }}', currentShipKeys)
    self:preprocess_equals('{{#invoke:CommonLists | main | c | count0 }}', '91')
    self:preprocess_equals('{{#invoke:CommonLists | main | s | count0 }}', '30')
--    self:preprocess_equals('{{#invoke:CommonLists | main | s | index }}', currentShipsEnc)
--    self:preprocess_equals('{{#invoke:CommonLists | main | s | index }}', currentShipKeys)
end


return p

