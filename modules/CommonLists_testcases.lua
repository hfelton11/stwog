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
local currentShipKeys = '{ [1] = ANT,[2] = BC1,[3] = BC2,[4] = BR,[5] = CG,[6] = CH,[7] = EN,[8] = ENA,[9] = ENB,[10] = END,[11] = FDM,[12] = HOZ,[13] = KBP,[14] = KD5,[15] = KEB,[16] = KKT,[17] = KNV,[18] = KR,[19] = KV,[20] = RBP,[21] = RD7,[22] = RDD,[23] = REL,[24] = RS,[25] = RV7,[26] = RVD,[27] = SGZ,[28] = THC,[29] = TS,[30] = VA,[31] = VDK,[32] = VTM,} '
local currentShipsEnc = 'glbls.keys=["ANT","BC1","BC2","BR","CG","CH","EN","ENA","ENB","END","FDM","HOZ","KBP","KD5","KEB","KKT","KNV","KR","KV","RBP","RD7","RDD","REL","RS","RV7","RVD","SGZ","THC","TS","VA","VDK","VTM"]'



function p:test_mkindex()
--    self:preprocess_equals('{{#invoke:CommonLists | main | index }}', 'stargazer-3')
    self:preprocess_equals('{{#invoke:CommonLists | main | C | index0 }}', currentCrewKeys)
    self:preprocess_equals('{{#invoke:CommonLists | main | s | index0 }}', currentShipKeys)
    self:preprocess_equals('{{#invoke:CommonLists | main | c | count0 }}', '98')
    self:preprocess_equals('{{#invoke:CommonLists | main | c | count1 }}', '31')
    self:preprocess_equals('{{#invoke:CommonLists | main | c | count2 }}', '39')
    self:preprocess_equals('{{#invoke:CommonLists | main | c | count3 }}', '28')
    self:preprocess_equals('{{#invoke:CommonLists | main | c | count4 }}', '3')
    self:preprocess_equals('{{#invoke:CommonLists | main | s | count0 }}', '32')
    self:preprocess_equals('{{#invoke:CommonLists | main | s | count1 }}', '6')
    self:preprocess_equals('{{#invoke:CommonLists | main | s | count2 }}', '12')
    self:preprocess_equals('{{#invoke:CommonLists | main | s | count3 }}', '14')
    self:preprocess_equals('{{#invoke:CommonLists | main | s | count4 }}', '3')
    self:preprocess_equals('{{#invoke:CommonLists | main | s | index4 }}', '{ [1] = ENB,[2] = HOZ,[3] = VTM,} ')
--    self:preprocess_equals('{{#invoke:CommonLists | main | s | index }}', currentShipsEnc)
--    self:preprocess_equals('{{#invoke:CommonLists | main | s | index }}', currentShipKeys)
end


return p

