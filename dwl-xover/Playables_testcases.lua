-- Playables/testcases module

-- Unit tests for Module:PlayablesCode. Click talk page to run tests.
local p = require('Dev:UnitTests')

local docDump = 'main ok: DorA=D : { [1] = A Mad Man with a Box,[2] = Professor River Song,[3] = SA The First Doctor,[4] = Signature The Sixth Doctor,[5] = The Eighth Doctor,[6] = The Eighth Doctor +,[7] = The Eleventh Doctor,[8] = The Eleventh Doctor +,[9] = The Fifth Doctor,[10] = The Fifth Doctor +,[11] = The First Doctor,[12] = The First Doctor +,[13] = The Fourth Doctor,[14] = The Fourth Doctor +,[15] = The Ninth Doctor,[16] = The Ninth Doctor +,[17] = The Second Doctor,[18] = The Second Doctor +,[19] = The Seventh Doctor,[20] = The Seventh Doctor +,[21] = The Sixth Doctor,[22] = The Sixth Doctor +,[23] = The Tenth Doctor,[24] = The Tenth Doctor +,[25] = The Third Doctor,[26] = The Third Doctor +,[27] = The Twelfth Doctor,[28] = The Twelfth Doctor +,[29] = The War Doctor,[30] = The War Doctor +,[31] = Trickster The Tenth Doctor,} '
local allyDump = 'main ok: DorA=A : { [1] = "Me",[2] = "Me" +,[3] = 11th Doctor Flesh Clone,[4] = ARC,[5] = Abslom Daak,[6] = Adipose (Black),[7] = Adipose (Blue),[8] = Adipose (Green),[9] = Adipose (Red),[10] = Adipose (Yellow),[11] = Adipose +,[12] = Alex Thompson,[13] = Alice Uwaebuka Obiefune,[14] = Amy Pond,[15] = Amy Pond +,[16] = Angie Maitland,[17] = Artie Maitland,[18] = Astrid Peth,[19] = Bannakaffalatta,[20] = Bessie,[21] = Bill Potts,[22] = Bill Potts +,[23] = Bitey the Cybermat,[24] = Brian Williams,[25] = Brigadier Lethbridge-Stewart,[26] = Brigadier Lethbridge-Stewart +,[27] = Buzzer Ganger,[28] = Canton Delaware III,[29] = Captain Henry Avery,[30] = Captain Rory Williams,[31] = Charlotte Elspeth Pollard,[32] = Charlotte Elspeth Pollard +,[33] = Church Bishop,[34] = Church Cleric,[35] = Church Verger,[36] = Cinder,[37] = Clara Oswald,[38] = Clara Oswald +,[39] = Colonel Orson Pink,[40] = Courtney Woods,[41] = Craig Owens,[42] = Danny Pink,[43] = Danny Pink +,[44] = Donna Noble,[45] = Donna Noble +,[46] = Dorium Maldovar,[47] = Dorothy "Ace" McShane,[48] = Dorothy "Ace" McShane +,[49] = Dr. Edwin Bracewell,[50] = Einarr,[51] = Elizabeth X,[52] = Fan Area Grace Holloway,[53] = Fan Area Gwen Cooper,[54] = Fan Area Strax,[55] = Fan Brigadier,[56] = Fan Churchill,[57] = Fan Impresario Webley,[58] = Fan Jack,[59] = Fan Jenny,[60] = Fan Jenny Flint,[61] = Fan Josie Day,[62] = Fan Martha Jones,[63] = Fan Ood Sigma,[64] = Fan River Song,[65] = Fan Robin Hood,[66] = Fan Rose,[67] = Fan Rusty,[68] = Fan Sarah Jane Smith,[69] = Fan Sonic Sunglasses,[70] = Fan Teller,[71] = Fan Vastra,[72] = Father Octavian,[73] = Frobisher,[74] = Gabriella "Gabby" Gonzalez,[75] = Gastron,[76] = George Thompson,[77] = Grace Holloway,[78] = Grace Holloway +,[79] = Grant,[80] = Gwen Cooper,[81] = Handles,[82] = Harry Sullivan,[83] = Harry Sullivan +,[84] = Hawthorne,[85] = Hydroflax with Nardole Head,[86] = Hydroflax with Ramone Head,[87] = Ianto Jones,[88] = Ianto Jones +,[89] = Idris,[90] = Idris +,[91] = Impresario Webley,[92] = Jac,[93] = Jack Harkness,[94] = Jack Harkness +,[95] = Jacks Sonic Blaster,[96] = Jackson Lake,[97] = Jackson Lake +,[98] = Jagganth Daiki-Nagata,[99] = Jennifer Lucas,[100] = Jenny,[101] = Jenny +,[102] = Jenny Flint,[103] = Jenny Flint +,[104] = Jimmy Wicks Ganger,[105] = Jo Grant,[106] = Jo Grant +,[107] = John Jones,[108] = John Riddell,[109] = Josie Day,[110] = K9 MK 2,[111] = K9 MK 2 +,[112] = Kate Stewart,[113] = Kate Stewart +,[114] = Lorna Bucket,[115] = Lucy Fletcher,[116] = Madame Vastra,[117] = Madame Vastra +,[118] = Malohkeh,[119] = Martha Jones,[120] = Martha Jones +,[121] = Meta-Crisis Tenth Doctor,[122] = Mickey Smith,[123] = Mickey Smith +,[124] = Miranda Cleaves,[125] = Miranda Cleaves Ganger,[126] = Missy (ally),[127] = Mr. Huffle,[128] = Nardole,[129] = Nardole +,[130] = Ohila,[131] = Old Canton Delaware III,[132] = Ood,[133] = Ood (Black),[134] = Ood (Blue),[135] = Ood (Green),[136] = Ood (Red),[137] = Ood Sigma,[138] = Oswin Oswald,[139] = Perkins,[140] = Petronella Osgood,[141] = Petronella Osgood +,[142] = Polly Wright,[143] = Polly Wright +,[144] = Porridge,[145] = Professor River Song +,[146] = Punishment Medic,[147] = Punishment Soldier,[148] = Queen Nefertiti,[149] = Ramone,[150] = Reinette,[151] = Reinette +,[152] = Rigsy,[153] = River Song,[154] = River Song +,[155] = River Songs Sonic Blaster,[156] = River Songs Sonic Screwdriver,[157] = Robin Hood,[158] = Romanas Sonic Screwdriver,[159] = Rory Williams,[160] = Rory Williams +,[161] = Rory the Handbot,[162] = Rose Tyler,[163] = Rose Tyler +,[164] = Rusty the Dalek,[165] = SA Cool Mickey,[166] = SA Jack Harkness,[167] = SA Jo Grant,[168] = SA River Song,[169] = SA The First Doctors signet ring,[170] = Saibra,[171] = Sam Garner,[172] = Santa Claus,[173] = Santa Claus +,[174] = Sarah Jane Smith,[175] = Sarah Jane Smith +,[176] = Sarah Janes Sonic Lipstick,[177] = Shayde,[178] = Signature Dorothy "Ace" McShane,[179] = Signature Jo Grant,[180] = Signature Osgood,[181] = Signature Peri,[182] = Signature Rigsy,[183] = Signature Saibra,[184] = Signature Vincent Van Gogh,[185] = Silent Priest (Black),[186] = Silent Priest (Blue),[187] = Silent Priest (Green),[188] = Silent Priest (Red),[189] = Silent Priest (Yellow),[190] = Sonic Sunglasses,[191] = Sonic Trowel,[192] = Special Agent Amy Pond,[193] = Spoonhead 11th Doctor,[194] = Stormageddon,[195] = Strackman Lux,[196] = Strax,[197] = Strax +,[198] = Susan Foreman,[199] = Susan Foreman +,[200] = Tasha Lem,[201] = The Eighth Doctors Sonic Screwdriver,[202] = The Eleventh Doctors Sonic Cane,[203] = The Eleventh Doctors Sonic Screwdriver Mk 6,[204] = The Eleventh Doctors Sonic Screwdriver Mk 7,[205] = The Fifth Doctors Sonic Screwdriver,[206] = The Fourth Doctors Sonic Screwdriver,[207] = The Girl Who Waited,[208] = The Girl Who Waited Sonic Screwdriver,[209] = The Moment,[210] = The Moment +,[211] = The Ninth Doctors Sonic Screwdriver,[212] = The Second Doctors Sonic Screwdriver,[213] = The Seventh Doctors Sonic Screwdriver,[214] = The TARDIS,[215] = The Teller,[216] = The Tenth Doctors Sonic Screwdriver,[217] = The Third Doctors Sonic Screwdriver Mk 2,[218] = The Third Doctors Sonic Screwdriver Mk 3,[219] = The Twelfth Doctors Sonic Screwdriver,[220] = The War Doctors Sonic Screwdriver,[221] = Tobias "Toby" Zed,[222] = Tricey,[223] = Trickster Peri,[224] = Trickster Saibra,[225] = Trickster Sarah Jane Smith,[226] = Trickster TARDIS,[227] = Trickster Zygon,[228] = UNIT Commander,[229] = UNIT Medic,[230] = UNIT Soldier,[231] = Vincent Van Gogh,[232] = Whomobile,[233] = Wilfred Mott,[234] = Wilfred Mott +,[235] = William Shakespeare,[236] = Winder (Black),[237] = Winder (Blue),[238] = Winder (Green),[239] = Winder (Red),[240] = Winder (Yellow),[241] = Winston Churchill,[242] = Young Grant,[243] = Young Sarah Jane Smith,[244] = Zygon (Black),[245] = Zygon (Blue),[246] = Zygon (Green),[247] = Zygon (Red),[248] = Zygon (Yellow),} '

local docBgn = 'main ok: DorA=D : mKey=>>>'
local allyBgn = 'main ok: DorA=A : mKey=>>>'
local whatBgn = '<<< : what='
local whatEnd = ' means ???'
local whichBgn = ',which='
local codeEnd = '<<< : code='
local frCodeBgn = '<<< : from CODE='
local colorsBgn = ' : colors=>>>'
local anyEnd = '<<< : tbd...'

function p:test_hello()
	self:preprocess_equals('{{#invoke:PlayablesCode | hello}}', 'Hello, world!')
end

function p:test_main()
	self:preprocess_equals('{{#invoke:PlayablesCode | main}}', 'invalid call to PlayablesCode-main: zero arguments passed')
	self:preprocess_equals('{{#invoke:PlayablesCode | main | xxx }}', 'xxx')
	self:preprocess_equals('{{#invoke:PlayablesCode | main | xxx | yYYy }}', 'xxx')
	self:preprocess_equals('{{#invoke:PlayablesCode | main | xxx | dump }}', 'xxx')
	self:preprocess_equals('{{#invoke:PlayablesCode | main | xxx | code }}', 'xxx')
	self:preprocess_equals('{{#invoke:PlayablesCode | main | xxx | decode }}', 'xxx')
	self:preprocess_equals('{{#invoke:PlayablesCode | main | D | yYYy }}', 'main ok: DorA=D : yYYy')
	self:preprocess_equals('{{#invoke:PlayablesCode | main | D | yYYy | }}', 'main ok: DorA=D : yYYy')
	self:preprocess_equals('{{#invoke:PlayablesCode | main | D | yYYy | 100000 }}', 'main ok: DorA=D : what='..'yYYy'..whichBgn..'100000')
	self:preprocess_equals('{{#invoke:PlayablesCode | main | A | yYYy }}', 'main ok: DorA=A : yYYy')
	self:preprocess_equals('{{#invoke:PlayablesCode | main | D | dUMp }}', docDump )
	self:preprocess_equals('{{#invoke:PlayablesCode | main | A | Dump }}', allyDump )
	self:preprocess_equals('{{#invoke:PlayablesCode | main | D | cODe | The First Doctor }}', docBgn..'The First Doctor'..codeEnd..'102141' )
	self:preprocess_equals('{{#invoke:PlayablesCode | main | D | happy | The First Doctor }}', docBgn..'The First Doctor'..whatBgn..'happy'..whatEnd )
	self:preprocess_equals('{{#invoke:PlayablesCode | main | D | happy | A Witch Doctor }}', 'main ok: DorA=D : what='..'happy'..whichBgn..'A Witch Doctor' )
	self:preprocess_equals('{{#invoke:PlayablesCode | main | A | Code | "Me" + }}', allyBgn..'"Me" +'..codeEnd..'202101' )
	self:preprocess_equals('{{#invoke:PlayablesCode | main | D | DEcODe | The First Doctor }}', docBgn..'The First Doctor'..anyEnd )
	self:preprocess_equals('{{#invoke:PlayablesCode | main | A | deCode | "Me" + }}', allyBgn..'"Me" +'..anyEnd )
	self:preprocess_equals('{{#invoke:PlayablesCode | main | D | cOLors | 100000 }}', docBgn..'100000'..frCodeBgn..'100000'..colorsBgn..anyEnd)
end

function p:test_GoodKey()
	self:preprocess_equals('{{#invoke:PlayablesCode | isGoodKey}}', 'false')
	self:preprocess_equals('{{#invoke:PlayablesCode | isGoodKey | xxx }}', 'false')
	self:preprocess_equals('{{#invoke:PlayablesCode | isGoodKey | AllDoctors }}', 'true')
	self:preprocess_equals('{{#invoke:PlayablesCode | isGoodKey | D | The First Doctor }}', 'true')
end


return p

