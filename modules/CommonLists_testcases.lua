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

local currentCrewKeys = '{ [1] = AH,[2] = AK,[3] = AM,[4] = ANU,[5] = AP,[6] = AR,[7] = ASP,[8] = AV,[9] = B1,[10] = B2,[11] = B3,[12] = B4,[13] = BA,[14] = BD,[15] = BE,[16] = CA,[17] = CAV,[18] = CBC,[19] = CCP,[20] = CDA,[21] = CDR,[22] = CDT,[23] = CHS,[24] = CHT,[25] = CK,[26] = CLF,[27] = CLM,[28] = CMS,[29] = CNU,[30] = CP,[31] = CPC,[32] = CR,[33] = CT,[34] = CWF,[35] = CWR,[36] = DA,[37] = DBC,[38] = DE,[39] = DM,[40] = EK,[41] = EMS,[42] = GLF,[43] = HE,[44] = HO,[45] = HS,[46] = HV,[47] = IN,[48] = KG,[49] = KN,[50] = KO,[51] = KOR,[52] = KU,[53] = KY,[54] = LB,[55] = LD,[56] = LE,[57] = LF,[58] = LOP,[59] = LPC,[60] = MS,[61] = NL,[62] = NO,[63] = NU,[64] = OP,[65] = PC,[66] = PG,[67] = PP,[68] = QQ,[69] = RU,[70] = SF,[71] = SG,[72] = SP,[73] = SS,[74] = SV,[75] = SWF,[76] = TA,[77] = TE,[78] = TH,[79] = TK,[80] = TK50,[81] = TN,[82] = TO,[83] = TR,[84] = TT,[85] = TV,[86] = VE,[87] = WC,[88] = WF,[89] = WS,} '
local currentShipKeys = '{ [1] = BC1,[2] = BC2,[3] = BR,[4] = CG,[5] = CH,[6] = EN,[7] = ENA,[8] = ENB,[9] = END,[10] = FDM,[11] = HOZ,[12] = KBP,[13] = KD5,[14] = KEB,[15] = KKT,[16] = KNV,[17] = KR,[18] = KV,[19] = RBP,[20] = RD7,[21] = RDD,[22] = REL,[23] = RS,[24] = RV7,[25] = RVD,[26] = SGZ,[27] = TS,[28] = VA,[29] = VDK,[30] = VTM,} '
local currentShipsEnc = 'glbls.keys=["BC1","BC2","BR","CG","CH","EN","ENA","ENB","END","FDM","HOZ","KBP","KD5","KEB","KKT","KNV","KR","KV","RBP","RD7","RDD","REL","RS","RV7","SGZ","TM","TS","VA"]'



function p:test_mkindex()
--    self:preprocess_equals('{{#invoke:CommonLists | main | index }}', 'stargazer-3')
    self:preprocess_equals('{{#invoke:CommonLists | main | C | index0 }}', currentCrewKeys)
    self:preprocess_equals('{{#invoke:CommonLists | main | s | index0 }}', currentShipKeys)
    self:preprocess_equals('{{#invoke:CommonLists | main | c | count0 }}', '89')
    self:preprocess_equals('{{#invoke:CommonLists | main | s | count0 }}', '30')
--    self:preprocess_equals('{{#invoke:CommonLists | main | s | index }}', currentShipsEnc)
--    self:preprocess_equals('{{#invoke:CommonLists | main | s | index }}', currentShipKeys)
end


return p

