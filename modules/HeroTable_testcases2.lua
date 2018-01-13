
-- trying scribuntu-version like at: https://en.wikipedia.org/wiki/Module:ScribuntoUnit

-- Unit tests for [[Module:Bananas]]. Click talk page to run tests.
local myMod = require('Module:HeroTable')
local scrUnit = require('Dev:ScribuntoUnit')
local s = scrUnit:new()

function s:test_numberOfHeroes()
    -- based upon current stripped-down version
--    self:assertEquals( 10, myMod.numberOfHeroes(), 'Can we count ?')
    self:assertEquals( 10, tonumber(myMod.numberOfTESTHeroes(nil)) )
    self:assertResultEquals( '10', '{{#invoke:HeroTable|numberOfTESTHeroes}}' )
    self:assertEquals( 2 + 4, tonumber(myMod.numberOfHeroes(nil)) )
--    self:assertEquals( 95 + 4, tonumber(myMod.numberOfHeroes(nil)) )
--    self:assertResultEquals( '10', '{{#invoke:HeroTable|numberOfHeroes}}' )
end

-- multiline-string
local HEROLISTER = [===[*[[Aira the Ice Mage]]
*[[Akayuki the Samurai]]
*[[Witch's Knight]]
*[[Wolf]]
*[[Wood Fairy]]
*[[Yeti]]
*[[Abracadaniel]]
*[[Banana Guard]]
*[[Tree Trunks]]
*[[Wildberry Princess]]]===]

function s:test_simpleList()
    -- based upon current stripped-down version
--    self:assertDeepEquals( SLISTDATA, myMod.simpleList(), 'Table concat strings work ?')
    self:assertEquals( type(HEROLISTER), type(myMod.simpleTESTList()) )
    self:assertEquals( HEROLISTER, myMod.simpleTESTList() )
--    self:assertEquals( type(HEROLISTER), type(myMod.simpleList()) )
--    self:assertEquals( HEROLISTER, myMod.simpleList() )
end

return s

