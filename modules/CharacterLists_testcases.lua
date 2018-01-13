-- charactercodes/testcases module
-- inside: [[Category:Modules]] using this line once...

-- trying two kirk-codes and calling it ok...

-- Unit tests for [[Module:Charactercodes]]. Click talk page to run tests.
-- <pre>
local p = require('Dev:UnitTests')


catlist01 = 'print out the categories...\nfor one hero...\nnamed >'
catlist01b = 'add the color categories to the category-list...\nfor one hero...\nnamed >'
cc1 = '[[:Category:Yellow|Yellow]]'
cc1b = '[[:Category:White|White]]'
cc2 = '[[:Category:Blue|Blue]]'
cc2b = '[[:Category:Purple|Purple]]'
cc3 = '[[:Category:Tier 1|Tier 1]]'
cc3b = '[[:Category:Tier 2|Tier 2]]'
cc4 = '[[:Category:TOS|TOS]]'
cc4b = '[[:Category:TNG|TNG]]'
cc5 = '[[:Category:Red|Red]]'
--
scy = '[[:Category:Yellow]]'
scw = '[[:Category:White]]'
scb = '[[:Category:Blue]]'
scp = '[[:Category:Purple]]'
scr = '[[:Category:Red]]'
catlist02 = '{ [1] = '..cc1..',[2] = '..cc2..',[3] = '..cc3..',[4] = '..cc4..',[5] = '..cc5..',} '
catlist03 = '{ [1] = '..cc1..',[2] = '..cc2b..',[3] = '..cc3b..',[4] = '..cc4b..',[5] = '..cc5..',} '
catlist04 = '{ [1] = '..cc1..',[2] = '..cc5..',[3] = '..cc3b..',[4] = '..cc4..',[5] = '..cc1b..',} '
--catlist02 = '{ [1] = Yellow,[2] = Blue,[3] = Tier 1,[4] = TOS,[5] = Red,} '
catlist05 = '{ [1] = '..scy..',[2] = '..scr..',[3] = '..scw..',} '
--
catlistCK = catlist01..'CK< ...\n\n'..catlist02
catlistAM = catlist01..'AM< ...\n\n'..catlist03
catlistAH = catlist01..'AH< ...\n\n'..catlist04
catlistAHs = catlist01b..'AH< ...\n\n'..catlist05
catlistAHs2 = scy..scr..scw
-- ..'\n\n\n'

function p:test_categories()
    self:preprocess_equals('{{#invoke:CharacterLists|main| categories |print|one|CK }}', catlistCK)
    self:preprocess_equals('{{#invoke:CharacterLists|main| categories |print|one|AM }}', catlistAM)
    self:preprocess_equals('{{#invoke:CharacterLists|main| categories |print|one|AH }}', catlistAH)
--    self:preprocess_equals('{{#invoke:CharacterLists|main| categories |colors|one|AH }}', catlistAHs2)
end




testJSONval01 = '>>>{ [1] = key,[2] = image,[3] = name,} <<< encodes to: >>>["key","image","name"]<<< and decodes to: >>>{ [1] = key,[2] = image,[3] = name,} <<<'
testJSONval02 = '>>>{ [1] = key,[2] = image,[3] = name,["tier"] = 2,} <<< encodes to: >>>{"1":"key","2":"image","3":"name","tier":2}<<< and decodes to: >>>{ ["1"] = key,["tier"] = 2,["3"] = name,["2"] = image,} <<<'
testJSONval03 = '>>>["key","image","name","tier"]<<< decodes to: >>>{ [1] = key,[2] = image,[3] = name,[4] = tier,} <<<'
testJSONval = testJSONval01..'\n\n\n'..testJSONval02..'\n\n\n'..testJSONval03..'\n\n\n'

function p:test_helloJSON()
    self:preprocess_equals('{{#invoke:CharacterLists | main | testJSON }}', testJSONval)
end

skillval01 = 'Skill Number 1 is called \'\'\'Shot Maneuver\'\'\'.\n'
skillval01 = skillval01..'Its color is [[:Category:Red|Red]].  Red-gem+html-table'
skillval02 = 'Skill Number 2 is called \'\'\'Commander\'s Orders\'\'\'.\n'
skillval02 = skillval02..'Its color is [[:Category:Yellow|Yellow]].  Yellow-gem+html-table'
skillval03 = 'Skill Number 3 is called \'\'\'Starfleet Deployed\'\'\'.\n'
skillval03 = skillval03..'Its color is [[:Category:Blue|Blue]].  Blue-gem+html-table'
skillval = skillval01..'\n\n'..skillval02..'\n\n'..skillval03..'\n\n'
Tskillval01 = '{ [1] = { ["color"] = Red,["skill"] = Shot Maneuver,["cost"] = 6,} ,[2] = { ["color"] = Yellow,["skill"] = Commander\'s Orders,["cost"] = 9,} ,[3] = { ["color"] = Blue,["skill"] = Starfleet Deployed,["cost"] = 15,} ,} '
Tskillval02 = '{ [1] = { [1] = { ["cost"] = 6,["desc"] = Does 63 damage to the selected enemy. Changes 3 random gems to yellow.,}  ,[2] = { ["cost"] = 6,["desc"] = Does 95 damage to the selected enemy. Changes 4 random gems to yellow.,}  ,[3] = { ["cost"] = 6,["desc"] = Does 126 damage to the selected enemy. Changes 4 random gems to yellow.,}  ,[4] = { ["cost"] = 6,["desc"] = Does 151 damage to the selected enemy. Changes 5 random gems to yellow.,}  ,[5] = { ["cost"] = 6,["desc"] = Does 168 damage to the selected enemy. Changes 5 random gems to yellow.,}  ,}  ,[2] = { [1] = { ["cost"] = 9,["desc"] = Does 125 damage to the selected enemy. Changes 5 random gems to blue.,}  ,[2] = { ["cost"] = 9,["desc"] = Does 170 damage to the selected enemy. Changes 6 random gems to blue.,}  ,[3] = { ["cost"] = 9,["desc"] = Does 205 damage to the selected enemy. Changes 6 random gems to blue.,}  ,[4] = { ["cost"] = 9,["desc"] = Does 255 damage to the selected enemy. Changes 7 random gems to blue.,}  ,[5] = { ["cost"] = 9,["desc"] = Does 303 damage to the selected enemy. Changes 7 random gems to blue.,}  ,}  ,[3] = { [1] = { ["cost"] = 15,["desc"] = Does 125 damage to the selected enemy and 75 to his allies.,}  ,[2] = { ["cost"] = 15,["desc"] = Does 170 damage to the selected enemy and 95 to his allies.,}  ,[3] = { ["cost"] = 15,["desc"] = Does 230 damage to the selected enemy and 118 to his allies.,}  ,[4] = { ["cost"] = 15,["desc"] = Does 295 damage to the selected enemy and 143 to his allies.,}  ,[5] = { ["cost"] = 15,["desc"] = Does 345 damage to the selected enemy and 195 to his allies.,}  ,}  ,} '
Tskillval = Tskillval01..'\n\n'..Tskillval02

-- could not get spacing correct on longer tabledumps or full-html-renders...
function p:test_skills()
    self:preprocess_equals('{{#invoke:CharacterLists|main| testSkills |CK }}', Tskillval01)
    self:preprocess_equals('{{#invoke:CharacterLists|main| skills |CK }}', skillval)
end

--[[  DO NOT USE, these are too difficult to work-with...

function p:test_tables()
    self:preprocess_equals('{{#invoke:CharacterLists|main| index }}', 'hi')
    self:preprocess_equals('{{#invoke:CharacterLists|main| table |["key","hp","image","junk"] }}', 'hi')
end

--]]



return p

