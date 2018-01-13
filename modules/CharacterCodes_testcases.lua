-- charactercodes/testcases module
-- inside: [[Category:Modules]] using this line once...

-- trying two kirk-codes and calling it ok...

-- Unit tests for [[Module:Charactercodes]]. Click talk page to run tests.
local p = require('Dev:UnitTests')

function p:test_hello()
    self:preprocess_equals('{{#invoke:Charactercodes | hello}}', 'Hello, world!')
end

function p:test_readargs()
    --- note: spaces are important for exactness...
    self:preprocess_equals('{{#invoke:Charactercodes | readargs}}', '{ } ')
    self:preprocess_equals('{{#invoke:Charactercodes | readargs | CK}}', '{ [1] = CK,} ')
end

function p:test_loadcrew()
    self:preprocess_equals('{{#invoke:Charactercodes | loadcrew}}', 'Empty Crew choice...>nil<...')
    self:preprocess_equals('{{#invoke:Charactercodes | loadcrew | ZZZZ}}', 'Unknown Crew member...>ZZZZ<...')
    self:preprocess_equals('{{#invoke:Charactercodes | loadcrew | 7}}', 'Unknown Crew member...>7<...')
    self:preprocess_equals('{{#invoke:Charactercodes | loadcrew | CK}}', 'Loaded...>CK<... as CO-CK')
    self:preprocess_equals('{{#invoke:Charactercodes | loadcrew | AK}}', 'Loaded...>AK<... as CO-AK')
    self:preprocess_equals('{{#invoke:Charactercodes | loadcrew | B1}}', 'Loaded...>B1<... as CN-B1')
    self:preprocess_equals('{{#invoke:Charactercodes | loadcrew | aaaaDEFAULT }}', 'Loaded...>aaaaDEFAULT<... as CO-aaaaDEFAULT')
end

--function p:test_expand()
--    self:preprocess_equals('{{#invoke:Charactercodes | expand | CK}}', 'CK-data goes here...')
--end

function p:test_igpt()
    self:preprocess_equals('{{#invoke:Charactercodes | codename | CK}}', 'kirk-1')
    self:preprocess_equals('{{#invoke:Charactercodes | codename | AK}}', 'kirk-2')
    self:preprocess_equals('{{#invoke:Charactercodes | codename | aaaaDEFAULT}}', 'default-1')
end

function p:test_skills_errors()
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK}}', 'not-useful-expansion for createSkillsString...')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|1}}', 'not-useful-expansion for createSkillsString...')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|1|0}}', 'not-useful-expansion for createSkillsString...')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|5|1}}', 'bad Skillnum=5')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | PC|3|1}}', 'bad Skillnum=3')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|1|6}}', 'bad SkillUpgrade=6')
end


function p:test_skills_ok()
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|1|1}}', 'Does 63 damage to the selected enemy.  Changes 3 random gems to yellow.')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|1|2}}', 'Does 95 damage to the selected enemy.  Changes 4 random gems to yellow.')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|1|3}}', 'Does 126 damage to the selected enemy.  Changes 4 random gems to yellow.')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|1|4}}', 'Does 151 damage to the selected enemy.  Changes 5 random gems to yellow.')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|1|5}}', 'Does 168 damage to the selected enemy.  Changes 5 random gems to yellow.')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|2|1}}', 'Does 125 damage to the selected enemy.  Changes 5 random gems to blue.')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|2|2}}', 'Does 170 damage to the selected enemy.  Changes 6 random gems to blue.')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|2|3}}', 'Does 205 damage to the selected enemy.  Changes 6 random gems to blue.')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|2|4}}', 'Does 255 damage to the selected enemy.  Changes 7 random gems to blue.')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|2|5}}', 'Does 303 damage to the selected enemy.  Changes 7 random gems to blue.')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|3|1}}', 'Does 125 damage to the selected enemy and 75 to his allies.')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|3|2}}', 'Does 170 damage to the selected enemy and 95 to his allies.')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|3|3}}', 'Does 230 damage to the selected enemy and 118 to his allies.')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|3|4}}', 'Does 295 damage to the selected enemy and 143 to his allies.')
    self:preprocess_equals('{{#invoke:Charactercodes | createSkillsString | CK|3|5}}', 'Does 345 damage to the selected enemy and 195 to his allies.')
end

-- these tests fail if the global containing skpchks=true is active ...
--local currentKeys = '{ [1] = AK,[2] = CK,[3] = KN,} '
--local currentKeys = '{ [1] = AK,[2] = CA,[3] = CK,[4] = HS,[5] = KN,[6] = MS,[7] = NU,[8] = PC,} '
--local currentCodes = '{ [1] = khan-3,[2] = kirk-1,[3] = kirk-2,} '
--local currentCodes = '{ [1] = chekov-1,[2] = khan-3,[3] = kirk-1,[4] = kirk-2,[5] = spock-1,[6] = sulu-1,[7] = tos-pnj-3-boss-2,[8] = uhura-1,} '
--local currentCodes = '{ [1] = alvaro-1,[2] = chekov-1,[3] = khan-3,[4] = kirk-1,[5] = kirk-2,[6] = pilus-1,[7] = spock-1,[8] = sulu-1,[9] = tos-pnj-3-boss-2,[10] = uhura-1,} '
--local currentCodes = '{ [1] = anita-1,[2] = armus-2,[3] = beverly-1,[4] = beverly-2,[5] = borg-1-2,[6] = borg-2-2,[7] = borg-3-3,[8] = borg-4-3,[9] = borja-1,[10] = carlos-1,[11] = chekov-1,[12] = chekov-2,[13] = clayton-1-2,[14] = danimetal-1,[15] = data-1,[16] = data-2,[17] = flopez-1-2,[18] = fonsi-1-2,[19] = francis-1-2,[20] = helmet-1,[21] = horta-2,[22] = human-antonio-2,[23] = ivan-total-1,[24] = jorge-2,[25] = khan-3,[26] = kirk-1,[27] = kirk-2,[28] = klingon-kurn-3,[29] = laforge-1,[30] = laforge-2,[31] = mccoy-1,[32] = mccoy-2,[33] = mhigueras-1,[34] = mordi-1,[35] = nodroz-1,[36] = pablo-1,[37] = picard-1,[38] = picard-2,[39] = q-3,[40] = riker-1,[41] = riker-2,[42] = romulan-antonio-2,[43] = ruk-2,[44] = sandra-1,[45] = scott-1,[46] = scott-2,[47] = spock-1,[48] = spock-2,[49] = sulu-1,[50] = sulu-2,[51] = talosian-keeper-3-4,[52] = tarr-2,[53] = tng-antican-2,[54] = tng-selay-2,[55] = tos-gorn-3,[56] = tos-human-alvaro-2,[57] = tos-m113-2,[58] = tos-masked-2-1,[59] = tos-masked-3-1,[60] = tos-pnj-10-alberto-1,[61] = tos-pnj-11-alejandro-2,[62] = tos-pnj-12-masked-boss-2,[63] = tos-pnj-2-bad-1,[64] = tos-pnj-3-boss-2,[65] = tos-pnj-4-mask-1,[66] = tos-pnj-7-ivan-2,[67] = tos-pnj-9-cigarrito-1,[68] = troi-1,[69] = troi-2,[70] = uhura-1,[71] = uhura-2,[72] = worf-1,[73] = worf-2,} '
--local currentCodes = '{ [1] = anita-1,[2] = armus-2,[3] = beverly-1,[4] = beverly-2,[5] = borg-1-2,[6] = borg-2-2,[7] = borg-3-3,[8] = borg-4-3,[9] = borja-1,[10] = carlos-1,[11] = chekov-1,[12] = chekov-2,[13] = clayton-1-2,[14] = danimetal-1,[15] = data-1,[16] = data-2,[17] = entellan-tataur-3,[18] = entellan-tenva-3,[19] = entellan-tolkir-2,[20] = entellan-tonak-2,[21] = flopez-1-2,[22] = fonsi-1-2,[23] = francis-1-2,[24] = helmet-1,[25] = horta-2,[26] = human-antonio-2,[27] = ivan-total-1,[28] = jorge-2,[29] = khan-3,[30] = kirk-1,[31] = kirk-2,[32] = klingon-kurn-3,[33] = laforge-1,[34] = laforge-2,[35] = mccoy-1,[36] = mccoy-2,[37] = mhigueras-1,[38] = mordi-1,[39] = nodroz-1,[40] = pablo-1,[41] = picard-1,[42] = picard-2,[43] = q-3,[44] = riker-1,[45] = riker-2,[46] = romulan-antonio-2,[47] = ruk-2,[48] = sandra-1,[49] = scott-1,[50] = scott-2,[51] = spock-1,[52] = spock-2,[53] = sulu-1,[54] = sulu-2,[55] = talosian-keeper-3-4,[56] = tarr-2,[57] = tng-antican-2,[58] = tng-selay-2,[59] = tos-gorn-3,[60] = tos-human-alvaro-2,[61] = tos-m113-2,[62] = tos-masked-2-1,[63] = tos-masked-3-1,[64] = tos-pnj-10-alberto-1,[65] = tos-pnj-11-alejandro-2,[66] = tos-pnj-12-masked-boss-2,[67] = tos-pnj-2-bad-1,[68] = tos-pnj-3-boss-2,[69] = tos-pnj-4-mask-1,[70] = tos-pnj-7-ivan-2,[71] = tos-pnj-9-cigarrito-1,[72] = troi-1,[73] = troi-2,[74] = uhura-1,[75] = uhura-2,[76] = worf-1,[77] = worf-2,} '
--local currentCodes = '{ [1] = anita-1,[2] = armus-2,[3] = beverly-1,[4] = beverly-2,[5] = beverly-3,[6] = borg-1-2,[7] = borg-2-2,[8] = borg-3-3,[9] = borg-4-3,[10] = borja-1,[11] = carlos-1,[12] = chekov-1,[13] = chekov-2,[14] = chekov-3,[15] = clayton-1-2,[16] = danimetal-1,[17] = data-1,[18] = data-2,[19] = entellan-tataur-3,[20] = entellan-tenva-3,[21] = entellan-tolkir-2,[22] = entellan-tonak-2,[23] = flopez-1-2,[24] = fonsi-1-2,[25] = francis-1-2,[26] = helmet-1,[27] = horta-2,[28] = human-antonio-2,[29] = ivan-total-1,[30] = jorge-2,[31] = kaylar-3.5,[32] = khan-3,[33] = kirk-1,[34] = kirk-2,[35] = klingon-kurn-3,[36] = laforge-1,[37] = laforge-2,[38] = mccoy-1,[39] = mccoy-2,[40] = mhigueras-1,[41] = mordi-1,[42] = nodroz-1,[43] = pablo-1,[44] = picard-1,[45] = picard-2,[46] = q-3,[47] = riker-1,[48] = riker-2,[49] = romulan-antonio-2,[50] = ruk-2,[51] = sandra-1,[52] = scott-1,[53] = scott-2,[54] = scott-3,[55] = spock-1,[56] = spock-2,[57] = sulu-1,[58] = sulu-2,[59] = talosian-keeper-3-3.5,[60] = tarr-2,[61] = tng-antican-2,[62] = tng-selay-2,[63] = tos-gorn-3,[64] = tos-human-alvaro-2,[65] = tos-m113-2,[66] = tos-masked-2-1,[67] = tos-masked-3-1,[68] = tos-pnj-10-alberto-1,[69] = tos-pnj-11-alejandro-2,[70] = tos-pnj-12-masked-boss-2,[71] = tos-pnj-2-bad-1,[72] = tos-pnj-3-boss-2,[73] = tos-pnj-4-mask-1,[74] = tos-pnj-7-ivan-2,[75] = tos-pnj-9-cigarrito-1,[76] = troi-1,[77] = troi-2,[78] = troi-3,[79] = uhura-1,[80] = uhura-2,[81] = uhura-3.5,[82] = wesley-3,[83] = worf-1,[84] = worf-2,[85] = worf-3,} '
local currentCodes = '{ [1] = anita-1,[2] = armus-2,[3] = beverly-1,[4] = beverly-2,[5] = beverly-3,[6] = borg-1-2,[7] = borg-2-2,[8] = borg-3-3,[9] = borg-4-3,[10] = borja-1,[11] = carlos-1,[12] = chekov-1,[13] = chekov-2,[14] = chekov-3,[15] = clayton-1-2,[16] = danimetal-1,[17] = data-1,[18] = data-2,[19] = entellan-tataur-3,[20] = entellan-tenva-3,[21] = entellan-tolkir-2,[22] = entellan-tonak-2,[23] = flopez-1-2,[24] = fonsi-1-2,[25] = francis-1-2,[26] = helmet-1,[27] = horta-2,[28] = human-antonio-2,[29] = ivan-total-1,[30] = jorge-2,[31] = kaylar-3.5,[32] = khan-3,[33] = kirk-1,[34] = kirk-2,[35] = klingon-kurn-3,[36] = laforge-1,[37] = laforge-2,[38] = mccoy-1,[39] = mccoy-2,[40] = mhigueras-1,[41] = mordi-1,[42] = nodroz-1,[43] = pablo-1,[44] = picard-1,[45] = picard-2,[46] = q-3,[47] = riker-1,[48] = riker-2,[49] = romulan-antonio-2,[50] = ruk-2,[51] = sandra-1,[52] = scott-1,[53] = scott-2,[54] = scott-3,[55] = spock-1,[56] = spock-2,[57] = sulu-1,[58] = sulu-2,[59] = talosian-keeper-3-3.5,[60] = tarr-2,[61] = tng-antican-2,[62] = tng-selay-2,[63] = tos-gorn-3,[64] = tos-human-alvaro-2,[65] = tos-m113-2,[66] = tos-masked-2-1,[67] = tos-masked-3-1,[68] = tos-pnj-10-alberto-1,[69] = tos-pnj-11-alejandro-2,[70] = tos-pnj-12-masked-boss-2,[71] = tos-pnj-2-bad-1,[72] = tos-pnj-3-boss-2,[73] = tos-pnj-4-mask-1,[74] = tos-pnj-7-ivan-2,[75] = tos-pnj-9-cigarrito-1,[76] = troi-1,[77] = troi-2,[78] = troi-3,[79] = uhura-1,[80] = uhura-2,[81] = uhura-3.5,[82] = wesley-3,[83] = worf-1,[84] = worf-2,[85] = worf-3,} '
--local currentKeys = '{ [1] = AK,[2] = B1,[3] = B2,[4] = B3,[5] = B4,[6] = CA,[7] = CK,[8] = CT,[9] = DA,[10] = HS,[11] = HV,[12] = KN,[13] = LB,[14] = LF,[15] = MS,[16] = NU,[17] = PC,[18] = PP,[19] = SF,[20] = SS,[21] = SV,[22] = TK,[23] = TN,[24] = TV,[25] = WS,} '
--local currentKeys = '{ [1] = AH,[2] = AK,[3] = AM,[4] = AP,[5] = AR,[6] = ASP,[7] = AV,[8] = B1,[9] = B2,[10] = B3,[11] = B4,[12] = BA,[13] = BD,[14] = BE,[15] = CA,[16] = CAV,[17] = CBP,[18] = CDA,[19] = CDR,[20] = CH,[21] = CHS,[22] = CK,[23] = CLF,[24] = CMS,[25] = CNU,[26] = CP,[27] = CPC,[28] = CR,[29] = CT,[30] = CWF,[31] = CWR,[32] = DA,[33] = DE,[34] = DLM,[35] = DM,[36] = EK,[37] = HE,[38] = HO,[39] = HS,[40] = HV,[41] = IN,[42] = KG,[43] = KN,[44] = KO,[45] = KU,[46] = LB,[47] = LD,[48] = LE,[49] = LF,[50] = MS,[51] = NL,[52] = NO,[53] = NU,[54] = OP,[55] = PC,[56] = PG,[57] = PP,[58] = QQ,[59] = RU,[60] = SF,[61] = SG,[62] = SP,[63] = SS,[64] = SV,[65] = TA,[66] = TE,[67] = TH,[68] = TK,[69] = TK50,[70] = TN,[71] = TO,[72] = TR,[73] = TT,[74] = TV,[75] = VE,[76] = WF,[77] = WS,} '
--local currentKeys = '{ [1] = AH,[2] = AK,[3] = AM,[4] = ANU,[5] = AP,[6] = AR,[7] = ASP,[8] = AV,[9] = B1,[10] = B2,[11] = B3,[12] = B4,[13] = BA,[14] = BD,[15] = BE,[16] = CA,[17] = CAV,[18] = CBP,[19] = CDA,[20] = CDR,[21] = CH,[22] = CHS,[23] = CK,[24] = CLF,[25] = CMS,[26] = CNU,[27] = CP,[28] = CPC,[29] = CR,[30] = CT,[31] = CWF,[32] = CWR,[33] = DA,[34] = DE,[35] = DLM,[36] = DM,[37] = EK,[38] = HE,[39] = HO,[40] = HS,[41] = HV,[42] = IN,[43] = KG,[44] = KN,[45] = KO,[46] = KU,[47] = LB,[48] = LD,[49] = LE,[50] = LF,[51] = MS,[52] = NL,[53] = NO,[54] = NU,[55] = OP,[56] = PC,[57] = PG,[58] = PP,[59] = QQ,[60] = RU,[61] = SF,[62] = SG,[63] = SP,[64] = SS,[65] = SV,[66] = SWF,[67] = TA,[68] = TE,[69] = TH,[70] = TK,[71] = TK50,[72] = TN,[73] = TO,[74] = TR,[75] = TT,[76] = TV,[77] = VE,[78] = WF,[79] = WS,} '
--local currentKeys = '{ [1] = AH,[2] = AK,[3] = AM,[4] = ANU,[5] = AP,[6] = AR,[7] = ASP,[8] = AV,[9] = B1,[10] = B2,[11] = B3,[12] = B4,[13] = BA,[14] = BD,[15] = BE,[16] = CA,[17] = CAV,[18] = CBC,[19] = CDA,[20] = CDR,[21] = CDT,[22] = CHS,[23] = CHT,[24] = CK,[25] = CLF,[26] = CLM,[27] = CMS,[28] = CNU,[29] = CP,[30] = CPC,[31] = CR,[32] = CT,[33] = CWF,[34] = CWR,[35] = DA,[36] = DBC,[37] = DE,[38] = DM,[39] = EK,[40] = EMS,[41] = HE,[42] = HO,[43] = HS,[44] = HV,[45] = IN,[46] = KG,[47] = KN,[48] = KO,[49] = KU,[50] = KY,[51] = LB,[52] = LD,[53] = LE,[54] = LF,[55] = LPC,[56] = MS,[57] = NL,[58] = NO,[59] = NU,[60] = OP,[61] = PC,[62] = PG,[63] = PP,[64] = QQ,[65] = RU,[66] = SF,[67] = SG,[68] = SP,[69] = SS,[70] = SV,[71] = SWF,[72] = TA,[73] = TE,[74] = TH,[75] = TK,[76] = TK50,[77] = TN,[78] = TO,[79] = TR,[80] = TT,[81] = TV,[82] = VE,[83] = WC,[84] = WF,[85] = WS,} '
local currentKeys = '{ [1] = AH,[2] = AK,[3] = AM,[4] = ANU,[5] = AP,[6] = AR,[7] = ASP,[8] = AV,[9] = B1,[10] = B2,[11] = B3,[12] = B4,[13] = BA,[14] = BD,[15] = BE,[16] = CA,[17] = CAV,[18] = CBC,[19] = CDA,[20] = CDR,[21] = CDT,[22] = CHS,[23] = CHT,[24] = CK,[25] = CLF,[26] = CLM,[27] = CMS,[28] = CNU,[29] = CP,[30] = CPC,[31] = CR,[32] = CT,[33] = CWF,[34] = CWR,[35] = DA,[36] = DBC,[37] = DE,[38] = DM,[39] = EK,[40] = EMS,[41] = HE,[42] = HO,[43] = HS,[44] = HV,[45] = IN,[46] = KG,[47] = KN,[48] = KO,[49] = KU,[50] = KY,[51] = LB,[52] = LD,[53] = LE,[54] = LF,[55] = LPC,[56] = MS,[57] = NL,[58] = NO,[59] = NU,[60] = OP,[61] = PC,[62] = PG,[63] = PP,[64] = QQ,[65] = RU,[66] = SF,[67] = SG,[68] = SP,[69] = SS,[70] = SV,[71] = SWF,[72] = TA,[73] = TE,[74] = TH,[75] = TK,[76] = TK50,[77] = TN,[78] = TO,[79] = TR,[80] = TT,[81] = TV,[82] = VE,[83] = WC,[84] = WF,[85] = WS,} '

function p:test_listall()
    self:preprocess_equals('{{#invoke:Charactercodes | listkeys }}', currentKeys)
--    self:preprocess_equals('{{#invoke:Charactercodes | simpleListKeys }}', currentKeys)
    self:preprocess_equals('{{#invoke:Charactercodes | listcodes }}', currentCodes)
end

-- this is not-quite-correct...
--local expandVal01 = "{ [\"gorder\"] = RYWOBP,[\"xnpc\"] = yes,[\"datavalues\"] = { [\"dv6\"] = 2,[\"dv5\"] = 2,[\"dv4\"] = 2,[\"dv3\"] = 2,[\"dv2\"] = 3,[\"dv1\"] = 3,} ,[\"hp\"] = 0,[\"aliases\"] = Capt. James T. Kirk, Captain James Tiberius Kirk,[\"image\"] = Captain Kirk.png,[\"limit\"] = 50,[\"tier\"] = 1,[\"lmax\"] = 3,[\"aenu\"] = Ally,[\"ag\"] = +2,[\"lmin\"] = 1,[\"race\"] = Human,[\"ar\"] = +2,[\"gender\"] = Male,[\"aw\"] = +1,[\"currentlevel\"] = 1,[\"skills\"] = { [\"cost3\"] = 15,[\"desc3\"] = { [\"t2\"] = damage to the selected enemy and ,[\"v1\"] = xxx,[\"v2\"] = yyy,[\"t1\"] = Does ,[\"t3\"] = to his allies.,} ,[\"color3\"] = Blue,[\"color1\"] = Red,[\"color2\"] = Yellow,[\"skill3\"] = Starfleet Deployed,[\"desc1\"] = { [\"t2\"] = damage to the selected enemy. Changes ,[\"v1\"] = 63,[\"v2\"] = 3,[\"t1\"] = Does ,[\"t3\"] = random gems to ,[\"v3\"] = yellow,[\"t4\"] = .,} ,[\"desc2\"] = { [\"t2\"] = damage to the selected enemy. Changes ,[\"v1\"] = 125,[\"v2\"] = 5,[\"t1\"] = Does ,[\"t3\"] = random gems to ,[\"v3\"] = blue,[\"t4\"] = .,} ,[\"skill1\"] = Shot Maneuver,[\"cost2\"] = 9,[\"skill2\"] = Commander's Orders,[\"cost1\"] = 6,} ,[\"skillsUpgrades\"] = { [\"supgr4\"] = { [\"desc3\"] = { [\"v2\"] = 143,[\"v1\"] = 295,} ,[\"cost3\"] = 15,[\"desc1\"] = { [\"v1\"] = unk,[\"v2\"] = unk,[\"v3\"] = unk,} ,[\"desc2\"] = { [\"v1\"] = unk,[\"v2\"] = unk,[\"v3\"] = unk,} ,[\"cost2\"] = unk,[\"cost1\"] = unk,} ,[\"supgr5\"] = { [\"desc3\"] = { [\"v2\"] = unk,[\"v1\"] = unk,} ,[\"cost3\"] = unk,[\"desc1\"] = { [\"v1\"] = unk,[\"v2\"] = unk,[\"v3\"] = unk,} ,[\"desc2\"] = { [\"v1\"] = 303,[\"v2\"] = 7,[\"v3\"] = blue,} ,[\"cost2\"] = 9,[\"cost1\"] = unk,} ,[\"supgr2\"] = { [\"desc3\"] = { [\"v2\"] = bbb,[\"v1\"] = aaa,} ,[\"cost3\"] = 16,[\"desc1\"] = { [\"v1\"] = 64,[\"v2\"] = 3,[\"v3\"] = rainbow,} ,[\"desc2\"] = { [\"v1\"] = 126,[\"v2\"] = 5,[\"v3\"] = rainbow,} ,[\"cost2\"] = 10,[\"cost1\"] = 7,} ,[\"supgr3\"] = { [\"desc3\"] = { [\"v2\"] = yyy,[\"v1\"] = xxx,} ,[\"cost3\"] = 15,[\"desc1\"] = { [\"v1\"] = 63,[\"v2\"] = 3,[\"v3\"] = yellow,} ,[\"desc2\"] = { [\"v1\"] = 125,[\"v2\"] = 5,[\"v3\"] = blue,} ,[\"cost2\"] = 9,[\"cost1\"] = 6,} ,} ,[\"name\"] = ,[\"igp\"] = kirk,[\"sdate\"] = 2015-01-01,[\"series\"] = TOS,[\"nup\"] = 10,[\"imagecaption\"] = Capt. James T. Kirk,} "
-- local expandVal01 = '{ ["aenu"] = Ally,["ag"] = +2,["aliases"] = Capt. James T. Kirk, Captain James Tiberius Kirk,["ar"] = +2,["aw"] = +1,["currentlevel"] = 1,["datavalues"] = { ["dv1"] = 3,["dv2"] = 3,["dv3"] = 2,["dv4"] = 2,["dv5"] = 2,["dv6"] = 2,} ,["gender"] = Male,["gorder"] = RYWOBP,["hp"] = 0,["igp"] = kirk,["image"] = Captain Kirk.png,["imagecaption"] = Capt. James T. Kirk,["limit"] = 50,["lmax"] = 3,["lmin"] = 1,["name"] = ,["nup"] = 10,["race"] = Human,["sdate"] = 2015-01-01,["series"] = TOS,["skills"] = { ["color1"] = Red,["color2"] = Yellow,["color3"] = Blue,["cost1"] = 6,["cost2"] = 9,["cost3"] = 15,["desc1"] = { ["t1"] = Does ,["t2"] = damage to the selected enemy. Changes ,["t3"] = random gems to ,["t4"] = .,["v1"] = 63,["v2"] = 3,["v3"] = yellow,} ,["desc2"] = { ["t1"] = Does ,["t2"] = damage to the selected enemy. Changes ,["t3"] = random gems to ,["t4"] = .,["v1"] = 125,["v2"] = 5,["v3"] = blue,} ,["desc3"] = { ["t1"] = Does ,["t2"] = damage to the selected enemy and ,["t3"] = to his allies.,["v1"] = xxx,["v2"] = yyy,} ,["skill1"] = Shot Maneuver,["skill2"] = Commander\'s Orders,["skill3"] = Starfleet Deployed,} ,["skillsUpgrades"] = { ["supgr2"] = { ["cost1"] = 7,["cost2"] = 10,["cost3"] = 16,["desc1"] = { ["v1"] = 64,["v2"] = 3,["v3"] = rainbow,} ,["desc2"] = { ["v1"] = 126,["v2"] = 5,["v3"] = rainbow,} ,["desc3"] = { ["v1"] = aaa,["v2"] = bbb,} ,} ,["supgr3"] = { ["cost1"] = 6,["cost2"] = 9,["cost3"] = 15,["desc1"] = { ["v1"] = 63,["v2"] = 3,["v3"] = yellow,} ,["desc2"] = { ["v1"] = 125,["v2"] = 5,["v3"] = blue,} ,["desc3"] = { ["v1"] = xxx,["v2"] = yyy,} ,} ,["supgr4"] = { ["cost1"] = unk,["cost2"] = unk,["cost3"] = 15,["desc1"] = { ["v1"] = unk,["v2"] = unk,["v3"] = unk,} ,["desc2"] = { ["v1"] = unk,["v2"] = unk,["v3"] = unk,} ,["desc3"] = { ["v1"] = 295,["v2"] = 143,} ,} ,["supgr5"] = { ["cost1"] = unk,["cost2"] = 9,["cost3"] = unk,["desc1"] = { ["v1"] = unk,["v2"] = unk,["v3"] = unk,} ,["desc2"] = { ["v1"] = 303,["v2"] = 7,["v3"] = blue,} ,["desc3"] = { ["v1"] = unk,["v2"] = unk,} ,} ,} ,["tier"] = 1,["xnpc"] = yes,} '
--local expandVal01 = '{ ["aenu"] = Ally,["ag"] = +1,["aliases"] = Capt. James T. Kirk, Captain James Tiberius Kirk,["ar"] = +0,["aw"] = +0,["code"] = kirk-1,["currentlevel"] = 1,["datavalues"] = { ["dv1"] = 3,["dv2"] = 3,["dv3"] = 2,["dv4"] = 2,["dv5"] = 2,["dv6"] = 2,} ,["gender"] = Male,["gorder"] = RYWOBP,["hp"] = 85,["igp"] = kirk,["image"] = Captain Kirk.png,["imagecaption"] = Capt. James T. Kirk,["limit"] = 50,["lmax"] = 3,["lmin"] = 1,["name"] = ,["nup"] = 10,["race"] = Human,["sdate"] = 2015-01-01,["series"] = TOS,["skills"] = { ["color1"] = Red,["color2"] = Yellow,["color3"] = Blue,["cost1"] = 6,["cost2"] = 9,["cost3"] = 15,["desc1"] = { ["t1"] = Does ,["t2"] = damage to the selected enemy. Changes ,["t3"] = random gems to ,["t4"] = .,["v1"] = 63,["v2"] = 3,["v3"] = yellow,} ,["desc2"] = { ["t1"] = Does ,["t2"] = damage to the selected enemy. Changes ,["t3"] = random gems to ,["t4"] = .,["v1"] = 125,["v2"] = 5,["v3"] = blue,} ,["desc3"] = { ["t1"] = Does ,["t2"] = damage to the selected enemy and ,["t3"] = to his allies.,["v1"] = 125,["v2"] = 75,} ,["skill1"] = Shot Maneuver,["skill2"] = Commander\'s Orders,["skill3"] = Starfleet Deployed,} ,["skillsUpgrades"] = { ["supgr2"] = { ["desc1"] = { ["v1"] = 95,["v2"] = 4,} ,["desc2"] = { ["v1"] = 170,["v2"] = 6,} ,["desc3"] = { ["v1"] = 170,["v2"] = 95,} ,} ,["supgr3"] = { ["desc1"] = { ["v1"] = 126,["v2"] = 4,} ,["desc2"] = { ["v1"] = 205,["v2"] = 6,} ,["desc3"] = { ["v1"] = 230,["v2"] = 118,} ,} ,["supgr4"] = { ["desc1"] = { ["v1"] = 151,["v2"] = 5,} ,["desc2"] = { ["v1"] = 255,["v2"] = 7,} ,["desc3"] = { ["v1"] = 295,["v2"] = 143,} ,} ,["supgr5"] = { ["desc1"] = { ["v1"] = 168,["v2"] = 5,} ,["desc2"] = { ["v1"] = 303,["v2"] = 7,} ,["desc3"] = { ["v1"] = 345,["v2"] = 195,} ,} ,} ,["tier"] = 1,["xnpc"] = yes,} '
--local expandVal01 = '{ ["aenu"] = Ally,["ag"] = +1,["aliases"] = Capt. James T. Kirk, Captain James Tiberius Kirk,["ar"] = +0,["aw"] = +0,["code"] = kirk-1,["currentlevel"] = 1,["datavalues"] = { ["dv1"] = 3,["dv2"] = 3,["dv3"] = 2,["dv4"] = 2,["dv5"] = 2,["dv6"] = 2,} ,["gender"] = Male,["gorder"] = RYWOBP,["hp"] = 85,["igp"] = kirk,["image"] = Captain Kirk.png,["imagecaption"] = Capt. James T. Kirk,["limit"] = 50,["lmax"] = 3,["lmin"] = 1,["name"] = ,["nup"] = 10,["race"] = Human,["sdate"] = 2015-01-01,["series"] = TOS,["skills"] = { ["color1"] = Red,["color2"] = Yellow,["color3"] = Blue,["cost1"] = 6,["cost2"] = 9,["cost3"] = 15,["desc1"] = { ["t1"] = Does ,["t2"] = damage to the selected enemy.  Changes ,["t3"] = random gems to ,["t4"] = .,["v1"] = 63,["v2"] = 3,["v3"] = yellow,} ,["desc2"] = { ["t1"] = Does ,["t2"] = damage to the selected enemy.  Changes ,["t3"] = random gems to ,["t4"] = .,["v1"] = 125,["v2"] = 5,["v3"] = blue,} ,["desc3"] = { ["t1"] = Does ,["t2"] = damage to the selected enemy and ,["t3"] = to his allies.,["v1"] = 125,["v2"] = 75,} ,["skill1"] = Shot Maneuver,["skill2"] = Commander\'s Orders,["skill3"] = Starfleet Deployed,} ,["skillsUpgrades"] = { ["supgr2"] = { ["desc1"] = { ["v1"] = 95,["v2"] = 4,} ,["desc2"] = { ["v1"] = 170,["v2"] = 6,} ,["desc3"] = { ["v1"] = 170,["v2"] = 95,} ,} ,["supgr3"] = { ["desc1"] = { ["v1"] = 126,["v2"] = 4,} ,["desc2"] = { ["v1"] = 205,["v2"] = 6,} ,["desc3"] = { ["v1"] = 230,["v2"] = 118,} ,} ,["supgr4"] = { ["desc1"] = { ["v1"] = 151,["v2"] = 5,} ,["desc2"] = { ["v1"] = 255,["v2"] = 7,} ,["desc3"] = { ["v1"] = 295,["v2"] = 143,} ,} ,["supgr5"] = { ["desc1"] = { ["v1"] = 168,["v2"] = 5,} ,["desc2"] = { ["v1"] = 303,["v2"] = 7,} ,["desc3"] = { ["v1"] = 345,["v2"] = 195,} ,} ,} ,["tier"] = 1,["xnpc"] = yes,} '
local expandVal01 = '{ ["aenu"] = Ally,["ag"] = +1,["aliases"] = Capt. James T. Kirk, Captain James Tiberius Kirk,["ar"] = +0,["aw"] = +0,["code"] = kirk-1,["currentlevel"] = 1,["datavalues"] = { ["dv1"] = 3,["dv2"] = 3,["dv3"] = 2,["dv4"] = 2,["dv5"] = 2,["dv6"] = 2,} ,["gender"] = Male,["gorder"] = RYWOBP,["hp"] = 85,["igp"] = kirk,["image"] = Captain Kirk.png,["imagecaption"] = Capt. James T. Kirk,["limit"] = 50,["lmax"] = 3,["lmin"] = 1,["name"] = [[Captain Kirk]],["nup"] = 10,["race"] = Human,["sdate"] = 2015-01-01,["series"] = TOS,["skills"] = { ["color1"] = Red,["color2"] = Yellow,["color3"] = Blue,["cost1"] = 6,["cost2"] = 9,["cost3"] = 15,["desc1"] = { ["t1"] = Does  ,["t2"] =  damage to the selected enemy. Changes  ,["t3"] =  random gems to  ,["t4"] = .,["v1"] = 63,["v2"] = 3,["v3"] = yellow, }  ,["desc2"] = { ["t1"] = Does  ,["t2"] =  damage to the selected enemy. Changes  ,["t3"] =  random gems to  ,["t4"] = .,["v1"] = 125,["v2"] = 5,["v3"] = blue, }  ,["desc3"] = { ["t1"] = Does  ,["t2"] =  damage to the selected enemy and  ,["t3"] =  to his allies.,["v1"] = 125,["v2"] = 75, }  ,["skill1"] = Shot Maneuver,["skill2"] = Commander\'s Orders,["skill3"] = Starfleet Deployed,} ,["skillsUpgrades"] = { ["supgr2"] = { ["desc1"] = { ["v1"] = 95,["v2"] = 4, } ,["desc2"] = { ["v1"] = 170,["v2"] = 6, }  ,["desc3"] = { ["v1"] = 170,["v2"] = 95, } , }  ,["supgr3"] = { ["desc1"] = { ["v1"] = 126,["v2"] = 4, }  ,["desc2"] = { ["v1"] = 205,["v2"] = 6, }  ,["desc3"] = { ["v1"] = 230,["v2"] = 118, }  , }  ,["supgr4"] = { ["desc1"] = { ["v1"] = 151,["v2"] = 5, }  ,["desc2"] = { ["v1"] = 255,["v2"] = 7, }  ,["desc3"] = { ["v1"] = 295,["v2"] = 143, }  , }  ,["supgr5"] = { ["desc1"] = { ["v1"] = 168,["v2"] = 5, }  ,["desc2"] = { ["v1"] = 303,["v2"] = 7, }  ,["desc3"] = { ["v1"] = 345,["v2"] = 195, }  , }  , }  ,["tier"] = 1,["xnpc"] = yes, } '


-- this is not-quite-correct...
local expandVal02 = [[
{{infobox character
 | name         =
 | image        = Captain Kirk.png
 | imagecaption = Capt. James T. Kirk
 | aliases      = Capt. James T. Kirk, Captain James Tiberius Kirk
 | race         = Human
 | gender       = Male
 | series       = TOS
 | xnpc    = yes
 | sdate   = 2015-01-01
 | aenu    = Ally
 | tier       = 1
 | igpt       = kirk-1
 | lmin       = 1
 | lmax       = 3
 | limit      = 50
 | hp         = 100
 | nup            = 10
 | skill1         = Shot Maneuver
 | color1         = Red
 | cost1          = 6
 | desc1          = Does 63 damage to the selected enemy. Changes 3 random gems to yellow.
 | skill2         = Commander's Orders
 | color2         = Yellow
 | cost2          = 9
 | desc2          = Does 125 damage to the selected enemy. Changes 5 random gems to blue.
 | skill3         = Starfleet Deployed
 | color3         = Blue
 | cost3          = 15
 | desc3          = Does xxx damage to the selected enemy and xxx to his allies.
 | ar    = +2
 | ag    = +2
 | aw    = +1
 | gorder       = RYWOBP
 | dv1         = 3
 | dv2         = 3
 | dv3         = 2
 | dv4         = 2
 | dv5         = 2
 | dv6         = 2
}}
]]


-- this is not-quite-correct...
--local ckSkills = "{ [\"cost3\"] = 15,[\"desc3\"] = { [\"t2\"] = damage to the selected enemy and ,[\"v1\"] = xxx,[\"v2\"] = yyy,[\"t1\"] = Does ,[\"t3\"] = to his allies.,} ,[\"color3\"] = Blue,[\"color1\"] = Red,[\"color2\"] = Yellow,[\"skill3\"] = Starfleet Deployed,[\"desc1\"] = { [\"t2\"] = damage to the selected enemy. Changes ,[\"v1\"] = 63,[\"v2\"] = 3,[\"t1\"] = Does ,[\"t3\"] = random gems to ,[\"v3\"] = yellow,[\"t4\"] = .,} ,[\"desc2\"] = { [\"t2\"] = damage to the selected enemy. Changes ,[\"v1\"] = 125,[\"v2\"] = 5,[\"t1\"] = Does ,[\"t3\"] = random gems to ,[\"v3\"] = blue,[\"t4\"] = .,} ,[\"skill1\"] = Shot Maneuver,[\"cost2\"] = 9,[\"skill2\"] = Commander's Orders,[\"cost1\"] = 6,} "
--local ckSkills = '{ ["color1"] = Red,["color2"] = Yellow,["color3"] = Blue,["cost1"] = 6,["cost2"] = 9,["cost3"] = 15,["desc1"] = { ["t1"] = Does ,["t2"] = damage to the selected enemy. Changes ,["t3"] = random gems to ,["t4"] = .,["v1"] = 63,["v2"] = 3,["v3"] = yellow,} ,["desc2"] = { ["t1"] = Does ,["t2"] = damage to the selected enemy. Changes ,["t3"] = random gems to ,["t4"] = .,["v1"] = 125,["v2"] = 5,["v3"] = blue,} ,["desc3"] = { ["t1"] = Does ,["t2"] = damage to the selected enemy and ,["t3"] = to his allies.,["v1"] = xxx,["v2"] = yyy,} ,["skill1"] = Shot Maneuver,["skill2"] = Commander\'s Orders,["skill3"] = Starfleet Deployed,} '
local ckSkills = "{ [\"color1\"] = Red,[\"color2\"] = Yellow,[\"color3\"] = Blue,[\"cost1\"] = 6,[\"cost2\"] = 9,[\"cost3\"] = 15,[\"desc1\"] = { [\"t1\"] = Does  ,[\"t2\"] =  damage to the selected enemy.  Changes  ,[\"t3\"] = random gems to  ,[\"t4\"] = .,[\"v1\"] = 63,[\"v2\"] = 3,[\"v3\"] = yellow,}   ,[\"desc2\"] = { [\"t1\"] = Does  ,[\"t2\"] =  damage to the selected enemy.  Changes  ,[\"t3\"] =  random gems to  ,[\"t4\"] = .,[\"v1\"] = 125,[\"v2\"] = 5,[\"v3\"] = blue,}  ,[\"desc3\"] = { [\"t1\"] = Does  ,[\"t2\"] =  damage to the selected enemy and  ,[\"t3\"] =  to his allies.,[\"v1\"] = 125,[\"v2\"] = 75,}  ,[\"skill1\"] = Shot Maneuver,[\"skill2\"] = Commander's Orders,[\"skill3\"] = Starfleet Deployed,} "


local ckSK1 = '{ ["t1"] = Does ,["t2"] = damage to the selected enemy.  Changes ,["t3"] = random gems to ,["t4"] = .,["v1"] = 63,["v2"] = 3,["v3"] = yellow,} '


function p:test_expand()
    self:preprocess_equals('{{#invoke:Charactercodes | expand }}', '')
--    self:preprocess_equals('{{#invoke:Charactercodes | expand | CK }}', string.format("%.40s",expandVal01))
--    self:preprocess_equals('{{#invoke:Charactercodes | expand | CK }}', "hero is 2045 (2031?) chars long..." )
    self:preprocess_equals('{{#invoke:Charactercodes | expand | CK }}', expandVal01)
    self:preprocess_equals('{{#invoke:Charactercodes | expand | CK | infobox }}', 'Unknown expansion-key >>infobox<<\n')
    self:preprocess_equals('{{#invoke:Charactercodes | expand | CK | race }}', 'Human')
--    self:preprocess_equals('{{#invoke:Charactercodes | expand | CK | race }}', '"Human"')
--    self:preprocess_equals('{{#invoke:Charactercodes | expand | CK | race }}', '"Human" (string)')
    self:preprocess_equals('{{#invoke:Charactercodes | expand | aaaaDEFAULT | tier }}', '1')
    self:preprocess_equals('{{#invoke:Charactercodes | expand | aaaaDEFAULT | race }}', 'tbd')
    self:preprocess_equals('{{#invoke:Charactercodes | expand | CK | skills }}', ckSkills)
--    self:preprocess_equals('{{#invoke:Charactercodes | expand | CK | skills | desc1 }}', ckSK1)
    self:preprocess_equals('{{#invoke:Charactercodes | expand | CK | skills | skill1 }}', 'Shot Maneuver')
    self:preprocess_equals('{{#invoke:Charactercodes | expand | CK | skills | skill2 }}', 'Commander\'s Orders')
    self:preprocess_equals('{{#invoke:Charactercodes | expand | CK | skills | skill9999 }}', 'Unknown dbl-expansion-key >>skill9999<<\n')
    self:preprocess_equals('{{#invoke:Charactercodes | expand | CK | gender | skill2 }}', 'Cannot use dbl-expansion-key >>skill2<< because >>gender<< did not return a table !!\n')
end

function p:test_mkInfobox()
    self:preprocess_equals('{{#invoke:Charactercodes | mkInfobox }}', 'NO JOY on igpt...  check input data...\n')
    self:preprocess_equals('{{#invoke:Charactercodes | mkInfobox | CK }}', expandVal02)
end

return p

