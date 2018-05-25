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

local currentCrewKeys = '{ [1] = AH,[2] = AK,[3] = AM,[4] = ANU,[5] = AP,[6] = AR,[7] = ASP,[8] = AV,[9] = AWR,[10] = B1,[11] = B2,[12] = B3,[13] = B4,[14] = BA,[15] = BD,[16] = BE,[17] = BRU,[18] = CA,[19] = CAV,[20] = CBC,[21] = CCP,[22] = CDA,[23] = CDR,[24] = CDT,[25] = CHS,[26] = CHT,[27] = CK,[28] = CLF,[29] = CLM,[30] = CMS,[31] = CNU,[32] = CP,[33] = CPC,[34] = CR,[35] = CT,[36] = CWF,[37] = CWR,[38] = DA,[39] = DBC,[40] = DE,[41] = DLM,[42] = DM,[43] = EK,[44] = EMS,[45] = GLF,[46] = HE,[47] = HO,[48] = HS,[49] = HV,[50] = IN,[51] = KG,[52] = KN,[53] = KO,[54] = KOR,[55] = KU,[56] = KY,[57] = LB,[58] = LD,[59] = LE,[60] = LF,[61] = LOP,[62] = LPC,[63] = MEL,[64] = MS,[65] = NL,[66] = NO,[67] = NU,[68] = NVZ,[69] = OP,[70] = PC,[71] = PG,[72] = PP,[73] = QQ,[74] = RU,[75] = SF,[76] = SG,[77] = SP,[78] = SS,[79] = SV,[80] = SWF,[81] = TA,[82] = TE,[83] = TH,[84] = TK,[85] = TK50,[86] = TN,[87] = TO,[88] = TR,[89] = TT,[90] = TV,[91] = TYD,[92] = TYL,[93] = TYM,[94] = TZZ,[95] = VE,[96] = WC,[97] = WF,[98] = WS,} '
local currentShipKeys = '{ [1] = BC1,[2] = BC2,[3] = BR,[4] = CG,[5] = CH,[6] = EN,[7] = ENA,[8] = ENB,[9] = END,[10] = FDM,[11] = HOZ,[12] = KBP,[13] = KD5,[14] = KEB,[15] = KKT,[16] = KNV,[17] = KR,[18] = KV,[19] = RBP,[20] = RD7,[21] = RDD,[22] = REL,[23] = RS,[24] = RV7,[25] = RVD,[26] = SGZ,[27] = TS,[28] = VA,[29] = VDK,[30] = VTM,} '
local currentShipsEnc = 'glbls.keys=["BC1","BC2","BR","CG","CH","EN","ENA","ENB","END","FDM","HOZ","KBP","KD5","KEB","KKT","KNV","KR","KV","RBP","RD7","RDD","REL","RS","RV7","SGZ","TM","TS","VA"]'



function p:test_mkindex()
--    self:preprocess_equals('{{#invoke:CommonLists | main | index }}', 'stargazer-3')
    self:preprocess_equals('{{#invoke:CommonLists | main | C | index0 }}', currentCrewKeys)
    self:preprocess_equals('{{#invoke:CommonLists | main | s | index0 }}', currentShipKeys)
    self:preprocess_equals('{{#invoke:CommonLists | main | c | count0 }}', '98')
    self:preprocess_equals('{{#invoke:CommonLists | main | c | count1 }}', '31')
    self:preprocess_equals('{{#invoke:CommonLists | main | c | count2 }}', '39')
    self:preprocess_equals('{{#invoke:CommonLists | main | c | count3 }}', '28')
    self:preprocess_equals('{{#invoke:CommonLists | main | c | count4 }}', '3')
    self:preprocess_equals('{{#invoke:CommonLists | main | s | count0 }}', '30')
    self:preprocess_equals('{{#invoke:CommonLists | main | s | count1 }}', '6')
    self:preprocess_equals('{{#invoke:CommonLists | main | s | count2 }}', '12')
    self:preprocess_equals('{{#invoke:CommonLists | main | s | count3 }}', '12')
    self:preprocess_equals('{{#invoke:CommonLists | main | s | count4 }}', '3')
    self:preprocess_equals('{{#invoke:CommonLists | main | s | index4 }}', '{ [1] = ENB,[2] = HOZ,[3] = VTM,} ')
--    self:preprocess_equals('{{#invoke:CommonLists | main | s | index }}', currentShipsEnc)
--    self:preprocess_equals('{{#invoke:CommonLists | main | s | index }}', currentShipKeys)
end


return p

